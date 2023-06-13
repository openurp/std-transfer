[#ftl]
[@b.head/]
  [@b.grid items=transferApplies var="transferApply"]
    [@b.gridbar]
      bar.addItem("计算绩点", action.multi("recalcGpa"));
      bar.addItem("打印申请表",action.multi("report",null,null,"_blank"));
      bar.addItem("${b.text('action.export')}", "exportData()");
      function exportData(){
        var form = document.searchForm;
        bg.form.addInput(form, "titles",
                        "std.code:学号,std.name:姓名,std.gender.name:性别,fromGrade.code:转出年级,fromDepart.name:转出院系,"+
                        "fromMajor.name:转出专业,fromDirection.name:转出方向,fromSquad.name:转出班级,toGrade.code:转入年级,"+
                        "toDepart.name:转入院系,toMajor.name:转入专业,toDirection.name:转入方向,toSquad.name:转入班级,"+
                        "gpa:总绩点,majorGpa:专业课成绩绩点,otherGpa:专业课外成绩绩点,transferGpa:转专业绩点,hasFail:有不及格课程,"+
                        "mobile:联系电话,adjustable:是否服从调剂,status:状态");
        bg.form.addInput(form, "fileName", "学生转专业申请名单");
        bg.form.submit(form, "${b.url('!exportData')}","_self");
      }
    [/@]
    [@b.row]
      [@b.boxcol/]
      [@b.col title="学号" property="std.code" width="11%"/]
      [@b.col title="姓名" property="std.name" width="8%"]
        [@b.a href="!info?id="+transferApply.id]${transferApply.std.name}[/@]
      [/@]
      [@b.col title="转出院系" property="std.fromDepart.name"  width="10%"]
        ${(transferApply.fromDepart.shortName)!transferApply.fromDepart.name}
      [/@]
      [@b.col title="转出专业" property="fromMajor.name"]
      <span style="font-size:0.8em">${(transferApply.fromMajor.name)!}</span>
      [/@]
      [@b.col title="申请转入" property="option.major.name"]
        <span style="font-size:0.8em">${transferApply.option.major.name} ${(transferApply.option.direction.name)!}</span>
      [/@]
      [@b.col title="服从调剂" width="6%" property="adjustable"]
        ${transferApply.adjustable?string('是','否')}
      [/@]
      [@b.col title="平均绩点" property="gpa" width="6%"]
        ${transferApply.gpa?string("#.00")}
      [/@]
      [@b.col title="专业课绩点" property="gpa" width="8%"]
        ${transferApply.majorGpa?string("#.00000")}
      [/@]
      [@b.col title="专业课外绩点" property="gpa" width="8%"]
        ${transferApply.otherGpa?string("#.00000")}
      [/@]
      [@b.col title="转专业绩点" property="gpa" width="8%"]
        ${transferApply.transferGpa?string("#.00000")}
      [/@]
      [@b.col title="状态" width="6%" property="status"/]
    [/@]
  [/@]
[@b.foot/]
