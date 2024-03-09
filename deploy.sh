#!/bin/bash
npm run build-prod
poetry run \
    pilothouse run sarwyd-taswyn-talfus-laddus/
alacritty --command \
    poetry run \
    pilothouse sync sarwyd-taswyn-talfus-laddus tahuti/ \
    &
sleep 2
poetry run \
    pilothouse commit sarwyd-taswyn-talfus-laddus tahuti/
