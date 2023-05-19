[#ftl/]
[@b.messages slash="4"/]
<table class="infoTable">
    <tr>
      <td class="title" style="width:10%">学年学期：</td>
      <td style="width:28%">${scheme.semester.schoolYear}学年度${scheme.semester.name}学期</td>
      <td class="title" style="width:12%">院系制定计划：</td>
      <td style="width:26%">${scheme.editBeginAt?string("yyyy-MM-dd HH:mm")}~${scheme.editEndAt?string("yyyy-MM-dd HH:mm")}</td>
      <td class="title">专业数目：</td>
      <td>${scheme.options?size}</td>
    </tr>
    <tr>
      <td class="title">名称：</td>
      <td>${scheme.name}</td>
      <td class="title">学生提交申请：</td>
      <td>${scheme.applyBeginAt?string("yyyy-MM-dd HH:mm")}~${scheme.applyEndAt?string("yyyy-MM-dd HH:mm")}</td>
      <td class="title">总体计划人数：</td>
      <td>[#assign total=0][#list scheme.options as o][#assign total=total+o.planCount][/#list]${total}</td>
    </tr>
    <tr>
      <td class="title">是否发布</td>
      <td style="color:${scheme.published?string('green','red')}">${(scheme.published!false)?string("是","否")}</td>
      <td class="title">院系面试审核：</td>
      <td>${scheme.auditBeginAt?string("yyyy-MM-dd HH:mm")}~${scheme.auditEndAt?string("yyyy-MM-dd HH:mm")}</td>
      <td class="title">总体申请人数：</td>
      <td>[#assign total=0][#list scheme.options as o][#assign total=total+o.currentCount][/#list]${total}</td>
    </tr>
  </table>
  [#assign optionMap={}/]
  [#list scheme.options as o]
    [#assign option_key]${o.depart.code}_${o.major.code}_${(o.direction.code)!}[/#assign]
    [#assign optionMap={option_key:o}+optionMap/]
  [/#list]
  [#assign options=[]/]
  [#list optionMap?keys?sort as ok]
    [#assign options=options + [optionMap[ok]]/]
  [/#list]
  [@b.grid items=options sortable="false" var="option" ]
      [@b.row]
          [@b.col title="序号" width="5%"]${option_index+1}[/@]
          [@b.col property="depart.name" title="院系" width="25%"/]
          [@b.col property="major.name"  title="专业" width="25%"/]
          [@b.col property="direction.name" title="方向" width="25%"/]
          [@b.col property="currentCount"  title="已申请人数" width="10%"/]
          [@b.col property="planCount"  title="计划人数" width="10%"/]
      [/@]
  [/@]
