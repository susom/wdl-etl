#   -*- coding: utf-8 -*-
from pybuilder.core import use_plugin, init, task

use_plugin("python.core")
use_plugin("python.flake8")
use_plugin("python.distutils")
use_plugin("pypi:pybuilder_docker")

name = "utilities"
default_task = "publish"
version = "1.0.0"


@init
def initialize(project):
    project.set_property('distutils_console_scripts', [
        "jbq = jgcp.bigquery:main",
        "yaml2wdl = common.yaml2wdl:main",
        "slacker = common.slacker:main",
        "mailer = common.mailer:main"
    ])
