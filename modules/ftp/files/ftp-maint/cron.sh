#!/bin/bash

MAINT_SCRIPTS_HOME=/opt/ftp-maint

cd $MAINT_SCRIPTS_HOME/manifest && ./manifest_rebuild_s.sh >cronmsg 2>&1
grep -i '\(warning\|error\)' cronmsg >/dev/null 2>&1 && echo -e "\n\n--- Manifest rebuild ---\n\n" && cat cronmsg

$MAINT_SCRIPTS_HOME/problem_db_update.sh >cronmsg 2>&1
grep -i '\(warning\|error\)' cronmsg >/dev/null 2>&1 && echo -e "\n\n--- problem_db update ---\n\n" && cat cronmsg

