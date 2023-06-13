/*
 * Copyright (C) 2014, The OpenURP Software.
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published
 * by the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

package org.openurp.std.transfer.web.action.student

import org.beangle.commons.collection.Collections
import org.beangle.data.dao.OqlBuilder
import org.beangle.security.Securities
import org.beangle.web.action.annotation.{ignore, mapping, param}
import org.beangle.web.action.view.{Status, View}
import org.beangle.web.servlet.util.RequestUtils
import org.beangle.webmvc.support.action.RestfulAction
import org.openurp.base.model.{AuditStatus, Project, User}
import org.openurp.base.std.model.Student
import org.openurp.starter.web.support.ProjectSupport
import org.openurp.std.transfer.config.{TransferOption, TransferScheme}
import org.openurp.std.transfer.log.TransferApplyLog
import org.openurp.std.transfer.model.TransferApply
import org.openurp.std.transfer.service.FirstGradeService
import org.openurp.std.transfer.web.helper.ApplyDocHelper

import java.time.Instant

class ApplyAction extends RestfulAction[TransferApply] with ProjectSupport {

  var firstGradeService: FirstGradeService = _

  override def index(): View = {
    val std = getStudent(getProject)
    val query = OqlBuilder.from(classOf[TransferApply], "apply")
    query.where("apply.std=:std", std)
    query.orderBy("apply.updatedAt desc")
    val applies = entityDao.search(query)
    put("applies", applies)
    val schemeQuery = OqlBuilder.from(classOf[TransferScheme], "scheme")
    schemeQuery.where("scheme.project=:project", std.project)
    schemeQuery.where("scheme.published=true")
    schemeQuery.where("scheme.grade=:grade", std.grade)
    schemeQuery.where("scheme.applyEndAt>:now", Instant.now)
    val schemes = entityDao.search(schemeQuery)
    put("schemes", schemes)
    if applies.isEmpty then forward("welcome")
    else forward()
  }

  @mapping(value = "new", view = "new,form")
  override def editNew(): View = {
    val scheme = entityDao.get(classOf[TransferScheme], getLongId("scheme"))
    if (!scheme.canApply()) {
      redirect("index", "不在操作时间内")
    }

    var entity = getEntity(classOf[TransferApply], simpleEntityName)
    //如果没有给id,也需要查一查
    if (!entity.persisted) {
      val applyQuery = OqlBuilder.from(classOf[TransferApply], "apply")
      applyQuery.where("apply.option.scheme=:scheme", scheme)
      applyQuery.where("apply.std.code=:me", Securities.user)
      entityDao.search(applyQuery) foreach { e =>
        entity = e
      }
    }
    editSetting(entity)
    put(simpleEntityName, entity)
    forward()
  }

  override def editSetting(apply: TransferApply): Unit = {
    val std = getStudent(getProject)
    val scheme = entityDao.get(classOf[TransferScheme], getLongId("scheme"))
    if (!apply.persisted) {
      apply.toGrade = scheme.grade
      val user = entityDao.findBy(classOf[User], "code" -> std.code, "school" -> std.project.school).headOption
      user foreach { u =>
        apply.mobile = u.mobile.orNull
        apply.email = u.email.orNull
      }
    }
    put("std", std)
    put("scheme", scheme)
    val options = scheme.options.sortBy(x => x.depart.code + x.major.code)
    put("options", options)
  }

  @ignore
  override protected def removeAndRedirect(entities: Seq[TransferApply]): View = {
    val std = getStudent(getProject)
    val my = entities.filter(x => x.std == std)
    val logs = Collections.newBuffer[TransferApplyLog]
    var outdated = false
    my foreach { a =>
      val log = makeLog(a)
      log.operation = "删除"
      logs += log
      if (!a.option.scheme.canApply()) {
        outdated = true
      }
    }
    if (outdated) {
      redirect("index", "不在操作允许的时间内")
    } else {
      remove(my)
      saveOrUpdate(logs)
      redirect("index", "info.remove.success")
    }
  }

  override def saveAndRedirect(apply: TransferApply): View = {
    val scheme = entityDao.get(classOf[TransferScheme], getLongId("scheme"))

    if (!scheme.canApply()) {
      return redirect("index", "不在操作时间内")
    }
    val std = getStudent(getProject)
    apply.std = std
    val state = std.state.get
    apply.fromGrade = state.grade
    apply.fromDepart = state.department
    apply.fromMajor = state.major
    apply.fromDirection = state.direction
    apply.fromSquad = state.squad

    val option = entityDao.get(classOf[TransferOption], apply.option.id)
    apply.option = option
    apply.toDepart = option.depart
    apply.toMajor = option.major
    apply.toDirection = option.direction
    apply.toGrade = scheme.grade

    apply.updatedAt = Instant.now
    apply.status = AuditStatus.Submited

    val gpaStat = firstGradeService.stat(apply)
    apply.gpa = gpaStat.gpa
    apply.majorGpa = gpaStat.majorGpa
    apply.otherGpa = gpaStat.otherGpa
    apply.transferGpa = gpaStat.transferGpa
    apply.hasFail = gpaStat.hasFail

    val log = makeLog(apply)
    saveOrUpdate(List(apply, log))
    redirect("index", "info.save.success")
  }

  private def makeLog(apply: TransferApply): TransferApplyLog = {
    val log = new TransferApplyLog
    log.std = apply.std
    log.operation = if (apply.persisted) "修改" else "新增"
    val option = entityDao.get(classOf[TransferOption], apply.option.id)
    log.contents = option.depart.name + " " + option.major.name + " " + option.direction.map(_.name).getOrElse("")
    log.ip = RequestUtils.getIpAddr(request)
    log.operateAt = Instant.now
    log
  }

  @mapping("download/{id}")
  def download(@param("id") id: String): View = {
    val apply = entityDao.get(classOf[TransferApply], id.toLong)
    val std = getStudent(getProject)
    if (std == apply.std) {
      val bytes = ApplyDocHelper.toDoc(apply)
      val filename = new String(std.code.getBytes, "ISO8859-1")
      response.setHeader("Content-disposition", "attachment; filename=" + filename + ".docx")
      response.setHeader("Content-Length", bytes.length.toString)
      val out = response.getOutputStream
      out.write(bytes)
      out.flush()
      out.close()
      null
    } else {
      Status.NotFound
    }
  }

  def getStudent(project: Project): Student = {
    val builder = OqlBuilder.from(classOf[Student], "s")
      .where("s.code=:code", Securities.user)
      .where("s.project=:project", project)
    val stds = entityDao.search(builder)
    if (stds.isEmpty) {
      throw new RuntimeException("Cannot find student with code " + Securities.user)
    } else {
      stds.head
    }
  }

}
