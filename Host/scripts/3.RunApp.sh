#!/bin/bash

echo "Launch Corstone-300 FVP Application"

cd /home/ubuntu/
./FVP_Corstone_SSE-300/models/Linux64_armv8l_GCC-9.3/FVP_Corstone_SSE-300_Ethos-U55 \
    -C ethosu.num_macs=64 \
    ml-embedded-evaluation-kit/build/bin/ethos-u-img_yolov8_192.axf
