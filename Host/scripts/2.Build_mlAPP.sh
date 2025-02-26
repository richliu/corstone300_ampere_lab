#!/bin/bash

echo "Build Corstone-300 FVP application"

cd /home/ubuntu/ml-embedded-evaluation-kit
mkdir -p ./build && cd ./build
cmake ../ -DUSE_CASE_BUILD=img_yolov8_192 \-DETHOS_U_NPU_ENABLED=ON
make -j4