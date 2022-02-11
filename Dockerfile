# https://ngc.nvidia.com/catalog/containers/nvidia:tensorrt
FROM nvcr.io/nvidia/tensorrt:21.12-py3
ARG DEBIAN_FRONTEND=noninteractive
# if you have 404 problems when you build the docker, try to run the upgrade
#RUN apt-get dist-upgrade -y
RUN apt-get -y update
# torch
RUN pip3 install torch==1.10.0+cu113 torchvision==0.11.1+cu113 torchaudio==0.10.0+cu113 -f https://download.pytorch.org/whl/cu113/torch_stable.html
RUN pip install https://github.com/NVIDIA/Torch-TensorRT/releases/download/v1.0.0/torch_tensorrt-1.0.0-cp38-cp38-linux_x86_64.whl

# installing vapoursynth
RUN apt install ffmpeg autoconf libtool yasm python3.9 python3.9-venv python3.9-dev ffmsindex libffms2-4 libffms2-dev -y
RUN git clone https://github.com/sekrit-twc/zimg.git && cd zimg && ./autogen.sh && ./configure && make -j4 && make install && cd .. && rm -rf zimg
RUN pip install Cython
RUN git clone https://github.com/vapoursynth/vapoursynth.git && cd vapoursynth && ./autogen.sh && ./configure && make && make install && cd .. && ldconfig
RUN ln -s /usr/local/lib/python3.9/site-packages/vapoursynth.so /usr/lib/python3.9/lib-dynload/vapoursynth.so
RUN pip install vapoursynth

# onnx
RUN pip install onnx onnxruntime onnxruntime-gpu

# installing onnx tensorrt with a workaround, error with import otherwise
# https://github.com/onnx/onnx-tensorrt/issues/643
RUN git clone --depth 1 --branch 21.02 \
    https://github.com/onnx/onnx-tensorrt.git && \
    cd onnx-tensorrt && \
    cp -r onnx_tensorrt /usr/local/lib/python3.8/dist-packages && \
    cd .. && \
    rm -rf onnx-tensorrt

# downloading models
RUN wget https://github.com/xinntao/Real-ESRGAN/releases/download/v0.2.3.0/RealESRGANv2-animevideo-xsx2.pth
RUN wget https://github.com/xinntao/Real-ESRGAN/releases/download/v0.2.3.0/RealESRGANv2-animevideo-xsx4.pth
RUN wget https://github.com/xinntao/Real-ESRGAN/releases/download/v0.2.2.4/RealESRGAN_x4plus_anime_6B.pth
# fatal anime
RUN wget https://de-next.owncube.com/index.php/s/x99pKzS7TNaErrC/download -O 4x_fatal_Anime_500000_G.pth
# rvp1
RUN pip install gdown && gdown --id 1IJe6WLvT43iwl-3J6ectgnjas5mjnQ51
# sepconv
RUN pip install cupy-cuda115
RUN wget http://content.sniklaus.com/resepconv/network-paper.pytorch -O sepconv.pth
# EGVSR
RUN wget https://github.com/Thmen/EGVSR/raw/master/pretrained_models/EGVSR_iter420000.pth
# rife4 (fixed rife4.0 model)
RUN gdown --id 1UzCbpjxWJsfiDjoc7wuzq3K0RCf5Oxr3
# RealBasicVSR_x4
RUN gdown --id 1OYR1J2GXE90Zu2gVU5xc0t0P_UmKH7ID
# cugan models
RUN gdown --id 1Y7SGNuivVjPf1g6F3IMvTsqt64p_pTeH
RUN gdown --id 1SBdf89kqcFg6LbPRO1npEcRfUgVzOyhu
RUN gdown --id 1bkSBMPia1Wkf2mqK7ygWIdDndymHyYSk
RUN gdown --id 1DfB-tMUKU_3NwQuM9Z0ZGYPhfLmzkDHb
RUN gdown --id 1-cc-Hh8TPZUpkScU97P1KQzZAKS9wese
RUN gdown --id 1lJvAtgZgRj27VXuDhSxD1mhD1bmn5g1J
RUN gdown --id 1VtBY4ZEebEiYL-IZRGJ61LUDCSRvkdoC
RUN gdown --id 1ZecBTGJogjXjZWdNnw0tlvpcbQVL1Wmg
RUN gdown --id 1lf6fTG90YRNLzLYu_jVfChSnvByznaTV
RUN gdown --id 1uMSkSaear_f3BhIVoyPAeEYecpTNSV6W
RUN gdown --id 1CaQ15NiDQlFoOYGe4OJTsHbdxa8zQvME
# film style
RUN mkdir /workspace/film_style
RUN cd /workspace/film_style && gdown --id 1nfi15im3LQvCx84ZRiNcfMuodDkRL_Ei && gdown --id 1dT85Z-HyYsiUgIQbOgYFjwWPOw8en1RC
RUN mkdir /workspace/film_style/variables && cd /workspace/film_style/variables && gdown --id 1ceC2kbJs3U1dMMrp4hNIpoHRFxO33SFC && wget https://files.catbox.moe/v84ufq.data-00000-of-00001 mv v84ufq.data-00000-of-00001 variables.data-00000-of-00001
# film l1
RUN mkdir /workspace/film_l1
RUN cd /workspace/film_l1 && gdown --id 1WPHyhqRmIhpsCCAuWmlE2j_VHPe6c4eR && gdown --id 1HxAfoDIkJs9HUT6GmyHeiO4NDFtBhQKO
RUN mkdir /workspace/film_l1/variables && cd /workspace/film_l1/variables && gdown --id 1jvMCG321Ws0WswWjZPSiYudrUWYvP10l && wget https://files.catbox.moe/renvnu.data-00000-of-00001 && mv renvnu.data-00000-of-00001 variables.data-00000-of-00001
# film vgg
RUN mkdir /workspace/film_vgg
RUN cd /workspace/film_vgg && gdown --id 11nvcQvf5n9JMrryvIPfypYEbRYz_1egM && gdown --id 1-KW5CVihmeiiMki9fIqwUfsnrVJyLdyn
RUN mkdir /workspace/film_vgg/variables && cd variables && gdown --id 1QsBtJFG9GLcjprjgnf6R-eQJq3k6mWnN && wget https://files.catbox.moe/qt4iya.data-00000-of-00001 && mv qt4iya.data-00000-of-00001 variables.data-00000-of-00001

# optional, rvp uses it to convert colorspace
RUN pip install kornia
# image read/write for image inference
RUN pip install opencv-python

# vs plugings from others
# https://github.com/HolyWu/vs-swinir
RUN pip install --upgrade vsswinir && python -m vsswinir
# https://github.com/HolyWu/vs-basicvsrpp
RUN pip install --upgrade vsbasicvsrpp && python -m vsbasicvsrpp

# dependencies for RealBasicVSR_x4
# mmedit
RUN git clone https://github.com/open-mmlab/mmediting.git && cd mmediting && pip install -v -e .
# RealBasicVSR_x4 will download this
RUN wget "https://download.pytorch.org/models/vgg19-dcbb9e9d.pth" -P /root/.cache/torch/hub/checkpoints/

# installing tensorflow because of FILM
RUN pip install tensorflow tensorflow-gpu tensorflow_addons gin-config -U