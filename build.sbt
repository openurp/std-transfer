import org.openurp.parent.Dependencies._
import org.openurp.parent.Settings._

ThisBuild / organization := "org.openurp.std.transfer"
ThisBuild / version := "0.0.2-SNAPSHOT"

ThisBuild / scmInfo := Some(
  ScmInfo(
    url("https://github.com/openurp/std-transfer"),
    "scm:git@github.com:openurp/std-transfer.git"
  )
)

ThisBuild / developers := List(
  Developer(
    id = "chaostone",
    name = "Tihua Duan",
    email = "duantihua@gmail.com",
    url = url("http://github.com/duantihua")
  )
)

ThisBuild / description := "OpenURP Std Transfer"
ThisBuild / homepage := Some(url("http://openurp.github.io/std-transfer/index.html"))

val apiVer = "0.33.0"
val starterVer = "0.3.1"
val baseVer = "0.4.0"
val openurp_base_api = "org.openurp.base" % "openurp-base-api" % apiVer
val openurp_std_api = "org.openurp.std" % "openurp-std-api" % apiVer
val openurp_edu_api = "org.openurp.edu" % "openurp-edu-api" % apiVer
val openurp_stater_web = "org.openurp.starter" % "openurp-starter-web" % starterVer
val openurp_base_tag = "org.openurp.base" % "openurp-base-tag" % baseVer

lazy val root = (project in file("."))
  .enablePlugins(WarPlugin, TomcatPlugin)
  .settings(
    name := "openurp-std-transfer-webapp",
    common,
    libraryDependencies ++= Seq(openurp_base_api, openurp_edu_api, openurp_std_api, beangle_ems_app),
    libraryDependencies ++= Seq(openurp_stater_web, openurp_base_tag, beangle_doc_docx)
  )
