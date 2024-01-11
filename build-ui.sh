#!/bin/bash
set -e
echo "Build UI"
cleancss -o "tahuti/app/ui/static/css/min/style.css" "ui/css/style.css"
cleancss -o "tahuti/app/ui/static/css/min/print.css" "ui/css/print.css"
echo "OK"
