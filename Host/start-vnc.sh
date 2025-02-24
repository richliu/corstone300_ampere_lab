#!/bin/bash
export DISPLAY=:1
export XDG_RUNTIME_DIR=/home/ubuntu/.runtime
mkdir -p $XDG_RUNTIME_DIR
chmod 700 $XDG_RUNTIME_DIR
vncserver :1 -xstartup /usr/bin/startplasma-x11

tail -f /dev/null