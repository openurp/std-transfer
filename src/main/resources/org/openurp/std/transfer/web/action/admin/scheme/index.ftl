[#ftl]
[@b.head/]
[#macro panel title]
<div class="panel panel-default">
  <div class="panel-heading">
    <h4 class="panel-title">${title}</h4>
  </div>
  [#nested/]
</div>
[/#macro]

<div class="container" style="width:95%">

<nav class="navbar navbar-default" role="navigation">
  <div class="container-fluid">
    <div class="navbar-header">
        <a class="navbar-brand" href="#"><i class="fa-solid fa-books"></i>转专业设置</a>
    </div>
    <ul class="nav navbar-nav navbar-right">
        [#--<li>
         [@edu_base.semester_bar name="semester.id" value=semester style="margin-top: 10px;"/]
        </li>
        --]
        <li>
        [@b.form class="navbar-form navbar-left" role="search" action="!editNew"]
            [@b.a class="btn btn-sm btn-info" href="!editNew"]<i class="fa-solid fa-plus"></i>添加[/@]
        [/@]
        </li>
    </ul>
    </div>
</nav>

  [#list schemes as scheme]
  [@b.form name="removeSchemeForm_"+scheme.id action="!remove?id="+scheme.id+"&_method=delete"][/@]
  [#assign title]
     <i class="fas fa-bookmark"></i>${scheme.name}<span style="font-size:0.8em">(${scheme.applyBeginAt?string("yyyy-MM-dd HH:mm")}~${scheme.applyEndAt?string("yyyy-MM-dd HH:mm")})</span>
     <div class="btn-group">
     [@b.a href="!edit?id="+scheme.id class="btn btn-sm btn-info"]<i class="fas fa-edit"></i>修改[/@]
     [@b.a href="!addOptions?transferScheme.id="+scheme.id target="scheme_info" class="btn btn-sm btn-info"]<i class="fa-solid fa-plus"></i>增加专业[/@]
     [@b.a href="!editOptions?transferScheme.id="+scheme.id target="scheme_info" class="btn btn-sm btn-info"]<i class="fas fa-edit"></i>修改人数[/@]
     </div>
     [#assign removeable=true/]
     [#list scheme.options as o]
       [#if o.currentCount>0][#assign removeable=false/][#break/][/#if]
     [/#list]
     [#if removeable]
     [@b.a href="!remove?id="+scheme.id onclick="return removeScheme(${scheme.id});" class="btn btn-sm btn-warning"]<i class="fas fa-times"></i>删除[/@]
     [/#if]
  [/#assign]
  [@panel title=title]
    [@b.div id="scheme_info"][#include "info.ftl"/][/@]
  [/@]
  [/#list]
</div>
<script>
   function removeScheme(id){
       if(confirm("确定删除?")){
         return bg.form.submit(document.getElementById("removeSchemeForm_"+id));
       }else{
         return false;
       }
   }
</script>
[@b.foot/]
