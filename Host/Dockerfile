#  SPDX-FileCopyrightText: Copyright 2022-2024 Arm Limited and/or its
#  affiliates <open-source-office@arm.com>
#  SPDX-License-Identifier: Apache-2.0
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.
#  ChangeLog: 
#       Move to Ampere Altra ARM64 platform and clean some code

FROM ubuntu:20.04
ENV DEBIAN_FRONTEND noninteractive

ENV EVAL_SRC_DIR="/home/ubuntu"
ENV FVP_300="FVP_Corstone_SSE-300"

# Setup Local Proxy Server
RUN echo "Acquire::http::Proxy \"http://192.168.1.254:3142\";" >> /etc/apt/apt.conf

## User added
RUN useradd -m ubuntu && echo "ubuntu:ubuntu" | chpasswd
RUN usermod -aG sudo ubuntu


RUN apt-get update && \
    apt-get install -y \
    make \
    build-essential \
    fakeroot \
    dpkg-dev \
    git \
    python3 python3-pip python3.8-venv libpython3.8-dev \
    cmake \
    gnutls-bin \
    unzip \
    curl \
    wget \
    gpg \
    libsndfile1 \
    sudo \
    vim \
    curl \
    net-tools \
    wget \
    xterm \
    p7zip-full \
    nomacs \
    telnet \
    x11-apps \
    openssh-server apt-utils \
    python3.9 libpython3.9

ENV USER_NAME ubuntu
RUN echo "${USER_NAME} ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/${USER_NAME} 

# +----------------------------------------------------------------------------
# | Download and install GNU GCC 10.2.1 embedded toolchain
# +----------------------------------------------------------------------------
RUN curl -k -L "https://developer.arm.com/-/media/Files/downloads/gnu-rm/10-2020q4/gcc-arm-none-eabi-10-2020-q4-major-aarch64-linux.tar.bz2?revision=cff794bc-3fb1-4c9c-934b-782886767324&rev=cff794bc3fb14c9c934b782886767324&hash=14BD0CC7D78E6D5E5FCF87DBB6D845C4A651BFD7" -o gcc-arm-none-eabi.tar.xz && \
    echo "343d8c812934fe5a904c73583a91edd812b1ac20636eb52de04135bb0f5cf36a gcc-arm-none-eabi.tar.xz" | sha256sum -c && \
    mkdir /opt/gcc-arm-none-eabi && \
    tar -xf  gcc-arm-none-eabi.tar.xz -C /opt/gcc-arm-none-eabi --strip-components 1 && \
    rm gcc-arm-none-eabi.tar.xz

USER ubuntu
WORKDIR ${EVAL_SRC_DIR}
# Check versions
RUN gcc --version && g++ --version && python3 --version
RUN git config --global http.sslVerify false
RUN git config --global http.postBuffer 1048576000
RUN git config --global https.postBuffer 1048576000
RUN git config --global advice.detachedHead false
ENV PATH="/opt/gcc-arm-none-eabi/bin/:$PATH"

# +----------------------------------------------------------------------------
# | Download YOLOv8 Source code
# +----------------------------------------------------------------------------
RUN git clone https://github.com/HimaxWiseEyePlus/YOLOv8_on_WE2.git --depth=1
ENV EVAL_MLFVP_DIR="${EVAL_SRC_DIR}/YOLOv8_on_WE2"
WORKDIR ${EVAL_MLFVP_DIR}
RUN git submodule update --init

# +----------------------------------------------------------------------------
# | Download and install Arm Corstone-300 FVP
# +----------------------------------------------------------------------------
WORKDIR ${EVAL_SRC_DIR}
RUN mkdir temp
ENV FVP_BIN_URL="https://developer.arm.com/-/cdn-downloads/permalink/FVPs-Corstone-IoT/Corstone-300/FVP_Corstone_SSE-300_11.27_42_Linux64_armv8l.tgz"
ENV FVP_300_SHA="32a5e84d5f5e39c2832beda5747b2cba0deafee1ac8e3909d7c3fbcad844d031"
RUN wget --no-check-certificate "${FVP_BIN_URL}"
RUN echo "${FVP_300_SHA} FVP_Corstone_SSE-300_11.27_42_Linux64_armv8l.tgz" | sha256sum -c
RUN tar -xf FVP_Corstone_SSE-300_11.27_42_Linux64_armv8l.tgz -C temp
RUN temp/FVP_Corstone_SSE-300.sh --no-interactive --i-agree-to-the-contained-eula -d ${FVP_300}
RUN rm "FVP_Corstone_SSE-300_11.27_42_Linux64_armv8l.tgz"

# download the 22.02 ml-embedded-evaluation-kit repository
WORKDIR ${EVAL_SRC_DIR}
RUN git clone -b 22.02-arm64 https://github.com/richliu/ml-embedded-evaluation-kit.git --depth=1
ENV EVAL_KIT_DIR="${EVAL_SRC_DIR}/ml-embedded-evaluation-kit"

# copy some header from YOLO to ml-embedded-evaluation 
WORKDIR "${EVAL_SRC_DIR}"
COPY install.sh install.sh
RUN bash install.sh

## Go out ml-embedded-evaluation-kit folder and copy the example resources to ML embedded evaluation kit
WORKDIR ${EVAL_SRC_DIR}
COPY post_install.sh post_install.sh
RUN bash post_install.sh

## cd ml-embedded-evaluation-kit/
WORKDIR ${EVAL_KIT_DIR}
RUN rm -rf ./dependencies
# Download dependencies packages and build the first sample code. 
RUN python3 ./download_dependencies.py

## Install vela
RUN sudo pip install ethos-u-vela
RUN pip install Pillow

# Buile Build NN models for M55+U55
WORKDIR ${EVAL_MLFVP_DIR}/vela
RUN vela --accelerator-config ethos-u55-64 \
    --config himax_vela.ini \
    --system-config My_Sys_Cfg \
    --memory-mode My_Mem_Mode_Parent \
    --output-dir ./img_yolov8_pose_192 \
    ./img_yolov8_pose_192/yolov8n-pose_full_integer_quant.tflite
RUN cp ${EVAL_MLFVP_DIR}/vela/* ${EVAL_KIT_DIR}/resources_downloaded/ -a
WORKDIR ${EVAL_KIT_DIR}
RUN ./build_default.py --npu-config-name ethos-u55-64

# yolov8 example
# RUN mkdir build_img_yolov8_192
# WORKDIR ${ITRI_MLFVP_DIR}/ml-embedded-evaluation-kit/build_img_yolov8_192
# RUN cmake ../ -DUSE_CASE_BUILD=img_yolov8_192 \-DETHOS_U_NPU_ENABLED=ON
# RUN make -j8



RUN sudo mkdir -p /var/run/sshd
RUN echo 'root:root' |sudo chpasswd # echo password | passwd --stdin root
RUN sudo sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sudo sed -i '/pam_loginuid.so/c session    optional     pam_loginuid.so'  /etc/pam.d/sshd
# RUN echo "export VISIBLE=now" >> /etc/profile
RUN sudo bash -c 'echo "export VISIBLE=now" >> /etc/profile'
RUN sudo sed -i "s/UsePAM yes/UsePAM no/" /etc/ssh/sshd_config
RUN sudo ssh-keygen -A


