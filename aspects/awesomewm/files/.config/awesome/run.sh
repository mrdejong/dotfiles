#!/bin/bash

Xephyr -br -ac -reset -screen 1920x1080 :2 &
sleep 1s
export DISPLAY=:2
awesome &
