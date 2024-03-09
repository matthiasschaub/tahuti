#!/bin/bash
alacritty --command \
    npm run build-dev \
    &
alacritty --command \
    poetry run \
    pilothouse chain zod tahuti \
    &
sleep 1
alacritty --command \
    poetry run \
    pilothouse chain nus tahuti \
    &
sleep 1
alacritty --command \
    poetry run \
    pilothouseph chain lus tahuti \
    &
poetry shell --directory=tests
