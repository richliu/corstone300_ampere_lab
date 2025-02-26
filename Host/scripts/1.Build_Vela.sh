#!/bin/bash
cd /home/ubuntu/YOLOv8_on_WE2/vela

echo "Build NN models for M55+U55"

vela --accelerator-config ethos-u55-64 \
                --config himax_vela.ini \
                --system-config My_Sys_Cfg \
                --memory-mode My_Mem_Mode_Parent \
                --output-dir ./img_yolov8_pose_192 \
                ./img_yolov8_pose_192/yolov8n-pose_full_integer_quant.tflite

cp -a /home/ubuntu/YOLOv8_on_WE2/vela/* /home/ubuntu/ml-embedded-evaluation-kit/resources_downloaded/