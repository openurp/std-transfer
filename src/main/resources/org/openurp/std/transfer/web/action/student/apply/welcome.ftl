[#ftl]
[@b.head/]

<div class="container" style="width:95%">

<nav class="navbar navbar-default" role="navigation">
  <div class="container-fluid">
    <div class="navbar-header">
        <a class="navbar-brand" href="#"><i class="fa-solid fa-books"></i>转专业申请</a>
    </div>
    <ul class="nav navbar-nav navbar-right">
    [#list schemes  as scheme]
       [#if scheme.canApply()]
        <li>
        [@b.form class="navbar-form navbar-left" role="search" action="!editNew"]
            [@b.a class="btn btn-sm btn-info" href="!editNew?scheme.id="+scheme.id]<i class="fa-solid fa-plus"></i>申请[/@]
        [/@]
        </li>
      [/#if]
     [/#list]
    </ul>
    </div>
</nav>

<div class="jumbotron">
    <div class="container">
        <h2>转专业</h2>
        [#if schemes?size>0]
        [#list schemes  as scheme]
        <p>欢迎进入转专业申请和结果查询，现在就申请。</p>
        <p>
         [#if scheme.canApply()]
         [@b.a class="btn btn-lg btn-info" role="button" href="!editNew?scheme.id="+scheme.id]<i class="fa-solid fa-plus"></i>申请<small>(${scheme.applyBeginAt?string("yyyy-MM-dd HH:mm")}~${scheme.applyEndAt?string("yyyy-MM-dd HH:mm")})</small>[/@]
         [#else]
         <a class="btn btn-lg btn-info" role="button" diabled="disabled">申请时间：${scheme.applyBeginAt?string("yyyy-MM-dd HH:mm")}~${scheme.applyEndAt?string("yyyy-MM-dd HH:mm")})</a>
         [/#if]
        </p>
        [/#list]
        [#else]
         <p>欢迎进入转专业申请和结果查询，现在还不能申请。</p>
        [/#if]
    </div>
</div>
</div>
[@b.foot/]
