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

package org.openurp.std.transfer.web.helper

import org.apache.poi.xwpf.usermodel.XWPFDocument
import org.beangle.commons.collection.Collections
import org.beangle.doc.docx.DocHelper
import org.openurp.std.transfer.model.TransferApply

import java.io.ByteArrayOutputStream
import java.net.URL

object ApplyDocHelper {

  def toDoc(apply: TransferApply): Array[Byte] = {
    val std = apply.std
    val data = Collections.newMap[String, String]
    data.put("school", std.project.school.name)
    data.put("code", std.code)
    data.put("name", std.name)
    data.put("mobile", apply.mobile)
    data.put("x", std.gender.name)

    data.put("depart", apply.fromDepart.name)
    data.put("major", apply.fromMajor.name)
    data.put("direction", apply.fromDirection.map(_.name).getOrElse(""))
    data.put("squad", apply.fromSquad.map(_.name).getOrElse(""))

    data.put("toDepart", apply.option.depart.name)
    data.put("toMajor", apply.option.major.name)
    data.put("toDirection", apply.option.direction.map(_.name).getOrElse(""))

    data.put("reason", apply.reason)
    data.put("adjustable", if (apply.adjustable) "是" else "否")

    import java.text.NumberFormat
    val nf = NumberFormat.getNumberInstance
    nf.setMinimumFractionDigits(2)
    nf.setMaximumFractionDigits(2)
    data.put("gpa", nf.format(apply.gpa))
    nf.setMinimumFractionDigits(5)
    nf.setMaximumFractionDigits(5)
    data.put("majorGpa", nf.format(apply.majorGpa))
    data.put("otherGpa", nf.format(apply.otherGpa))

    val url = this.getClass.getResource("/org/openurp/std/transfer/application.docx")
    DocHelper.toDoc(url, data)
  }

}
