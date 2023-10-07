#!/bin/bash
set -e
echo "Build UI"
cleancss -o "tahuti/app/ui/static/css/min/style.css" "tahuti/app/ui/static/css/style.css"
cleancss -o "tahuti/app/ui/static/css/min/print.css" "tahuti/app/ui/static/css/print.css"
echo "OK"
