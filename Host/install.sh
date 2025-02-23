#!/bin/bash

cp -r ./YOLOv8_on_WE2/source/application/main/include ./ml-embedded-evaluation-kit/source/application/main
cp -r ./YOLOv8_on_WE2/source/application/tensorflow-lite-micro/include ./ml-embedded-evaluation-kit/source/application/tensorflow-lite-micro
cp -r ./YOLOv8_on_WE2/source/profiler/include ./ml-embedded-evaluation-kit/source/profiler
cp -r ./YOLOv8_on_WE2/source/use_case/ad/include ./ml-embedded-evaluation-kit/source/use_case/ad
cp -r ./YOLOv8_on_WE2/source/use_case/asr/include ./ml-embedded-evaluation-kit/source/use_case/asr
cp -r ./YOLOv8_on_WE2/source/use_case/img_class/include ./ml-embedded-evaluation-kit/source/use_case/img_class
cp -r ./YOLOv8_on_WE2/source/use_case/inference_runner/include ./ml-embedded-evaluation-kit/source/use_case/inference_runner
cp -r ./YOLOv8_on_WE2/source/use_case/kws/include ./ml-embedded-evaluation-kit/source/use_case/kws
cp -r ./YOLOv8_on_WE2/source/use_case/kws_asr/include ./ml-embedded-evaluation-kit/source/use_case/kws_asr
cp -r ./YOLOv8_on_WE2/source/use_case/noise_reduction/include ./ml-embedded-evaluation-kit/source/use_case/noise_reduction
cp -r ./YOLOv8_on_WE2/source/use_case/object_detection/include ./ml-embedded-evaluation-kit/source/use_case/object_detection
cp -r ./YOLOv8_on_WE2/source/use_case/vww/include ./ml-embedded-evaluation-kit/source/use_case/vww
# cp -r download_dependencies.py ./ml-embedded-evaluation-kit/
# cp -r set_up_default_resources.py ./ml-embedded-evaluation-kit/
# cp -r gen_rgb_cpp.py ./ml-embedded-evaluation-kit/scripts/py/
# cp -r requirements.txt ./ml-embedded-evaluation-kit/scripts/py/
# cd ml-embedded-evaluation-kit/
# rm -rf ./dependencies
# python3 ./download_dependencies.py
# ./build_default.py --npu-config-name ethos-u55-64
