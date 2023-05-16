[#ftl]
[@b.head/]
[#macro panel title]
<div class="panel panel-default">
  <div class="panel-heading">
    <h5 class="panel-title">${title}</h5>
  </div>
  [#nested/]
</div>
[/#macro]

<div class="container" style="width:95%">

<nav class="navbar navbar-default" role="navigation">
  <div class="container-fluid">
    <div class="navbar-header">
        <a class="navbar-brand" href="#"><i class="fas fa-book"></i>转专业申请</a>
    </div>
    <ul class="nav navbar-nav navbar-right">
    [#list schemes as scheme]
       [#if scheme.canApply()]
        <li>
        [@b.form class="navbar-form navbar-left" role="search" action="!editNew"]
            [@b.a class="btn btn-sm btn-info" href="!editNew?scheme.id="+scheme.id]<i class="fas fa-plus"></i>申请[/@]
        [/@]
        </li>
       [/#if]
     [/#list]
    </ul>
    </div>
</nav>

  [#list applies as apply]
  [@b.form name="removeApplyForm_"+apply.id action="!remove?id="+apply.id+"&_method=delete" ][/@]
  [#assign scheme= apply.option.scheme/]
  [#assign title]
     <i class="fas fa-bookmark"></i>${apply.option.scheme.name}<span style="font-size:0.8em">(${scheme.applyBeginAt?string("yyyy-MM-dd HH:mm")}~${scheme.applyEndAt?string("yyyy-MM-dd HH:mm")})</span>
       <div class="btn-group">
     [#if scheme.canApply()]
       [@b.a href="!edit?id="+apply.id+"&scheme.id="+scheme.id class="btn btn-sm btn-info"]<i class="fas fa-edit"></i>修改[/@]
     [/#if]
       [@b.a href="!download?id="+apply.id class="btn btn-sm btn-info" target="_blank"]<i class="fas fa-download"></i>下载[/@]
       </div>
     [#if scheme.canApply()]
       [#if apply.status!="通过"]
       <a href="#" onclick="return removeApply('${apply.id}');" class="btn btn-sm btn-warning"><i class="fas fa-times"></i>删除</a>
       [/#if]
     [/#if]

  [/#assign]
  [@panel title=title]
    [@b.div id="scheme_info"][#include "info.ftl"/][/@]
  [/@]
  [/#list]
</div>
<script>
   function removeApply(id){
       if(confirm("确定删除?")){
         return bg.form.submit(document.getElementById("removeApplyForm_"+id));
       }else{
         return false;
       }
   }
</script>
</div>
[@b.foot/]
