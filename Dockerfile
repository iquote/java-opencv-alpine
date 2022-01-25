# MIT License

# Copyright (c) 2022 dilhelh

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE

FROM alpine:edge

MAINTAINER Guilherme Sousa <guisousa09@hotmail.com>

ENV LANG=C.UTF-8

# Install required packages
RUN apk update && apk upgrade && apk --no-cache add \
  bash \
  build-base \
  ca-certificates \
  clang-dev \
  clang \
  cmake \
  coreutils \
  curl \
  freetype-dev \
  ffmpeg-dev \
  ffmpeg-libs \
  gcc \
  g++ \
  git \
  gettext \
  lcms2-dev \
  libavc1394-dev \
  libc-dev \
  libffi-dev \
  libjpeg-turbo-dev \
  libpng-dev \
  libressl-dev \
  libtbb \
  libtbb-dev \
  libwebp-dev \
  linux-headers \
  make \
  musl \
  openblas \
  openblas-dev \
  openjpeg-dev \
  openssl \
  python3 \
  python3-dev \
  tiff-dev \
  unzip \
  zlib-dev \
  wget \
  apache-ant \
  tesseract-ocr

WORKDIR /opt

# Install Java 11
RUN wget http://www.cs.tohoku-gakuin.ac.jp/pub/Tools/OpenJDK/JDK11-HotSpot/OpenJDK11U-jdk_x64_alpine-linux_hotspot_11.0.13_8.tar.xz \
 && tar -xvf OpenJDK11U-jdk_x64_alpine-linux_hotspot_11.0.13_8.tar.xz && rm OpenJDK11U-jdk_x64_alpine-linux_hotspot_11.0.13_8.tar.xz
ENV JAVA_HOME /opt/jdk-11.0.13+8
ENV PATH $JAVA_HOME/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

# Tesseract tessdata Path configuration
ENV TESSDATA_PREFIX /usr/share/tessdata

RUN wget https://github.com/opencv/opencv/archive/4.5.1.zip \
  && unzip 4.5.1.zip \
  && rm 4.5.1.zip \
  && wget https://github.com/opencv/opencv_contrib/archive/4.5.1.zip \
  && unzip 4.5.1.zip \
  && rm 4.5.1.zip

WORKDIR /opt/opencv-4.5.1/build

# Install OpenCV
RUN cmake -DCMAKE_BUILD_TYPE=RELEASE \
    -DCMAKE_C_COMPILER=/usr/bin/clang \
    -DCMAKE_CXX_COMPILER=/usr/bin/clang++ \
    -DCMAKE_INSTALL_PREFIX=/usr/lib \
    -DINSTALL_PYTHON_EXAMPLES=OFF \
    -DINSTALL_C_EXAMPLES=OFF \
    -DWITH_FFMPEG=ON \
    -DWITH_TBB=ON \
    -DBUILD_opencv_python2=OFF \
    -DBUILD_opencv_python3=OFF \
    -DBUILD_TESTS=OFF \
    -DBUILD_PERF_TESTS=OFF \
    -DBUILD_opencv_alphamat=OFF \
    -DBUILD_opencv_aruco=OFF \
    -DBUILD_opencv_barcode=OFF \
    -DBUILD_opencv_bgsegm=OFF \
    -DBUILD_opencv_bioinspired=OFF \
    -DBUILD_opencv_ccalib=OFF \
    -DBUILD_opencv_cnn_3dobj=OFF \
    -DBUILD_opencv_datasets=OFF \
    -DBUILD_opencv_dnn_objdetect=OFF \
    -DBUILD_opencv_dnn_superres=OFF \
    -DBUILD_opencv_dpm=OFF \
    -DBUILD_opencv_dnns_easily_fooled=OFF \
    -DBUILD_opencv_face=OFF \
    -DBUILD_opencv_freetype=OFF \
    -DBUILD_opencv_fuzzy=OFF \
    -DBUILD_opencv_hdf=OFF \
    -DBUILD_opencv_hfs=OFF \
    -DBUILD_opencv_img_hash=OFF \
    -DBUILD_opencv_intensity_transform=OFF \
    -DBUILD_opencv_julia=OFF \
    -DBUILD_opencv_line_descriptor=OFF \
    -DBUILD_opencv_matlab=OFF \
    -DBUILD_opencv_mcc=OFF \
    -DBUILD_opencv_optflow=OFF \
    -DBUILD_opencv_ovis=OFF \
    -DBUILD_opencv_phase_unwrapping=OFF \
    -DBUILD_opencv_plot=OFF \
    -DBUILD_opencv_quality=OFF \
    -DBUILD_opencv_rapid=OFF \
    -DBUILD_opencv_reg=OFF \
    -DBUILD_opencv_rgbd=OFF \
    -DBUILD_opencv_saliency=OFF \
    -DBUILD_opencv_sfm=OFF \
    -DBUILD_opencv_shape=OFF \
    -DBUILD_opencv_stereo=OFF \
    -DBUILD_opencv_structured_light=OFF \
    -DBUILD_opencv_superres=OFF \
    -DBUILD_opencv_surface_matching=OFF \
    -DBUILD_opencv_text=ON \
    -DBUILD_opencv_tracking=OFF \
    -DBUILD_opencv_videostab=OFF \
    -DBUILD_opencv_viz=OFF \
    -DBUILD_opencv_wechat_qrcode=OFF \
    -DBUILD_opencv_xfeatures2d=OFF \
    -DBUILD_opencv_ximgproc=OFF \
    -DBUILD_opencv_xobjdetect=OFF \
    -DBUILD_opencv_xphoto=OFF \
    -DOPENCV_EXTRA_MODULES_PATH=/opt/opencv_contrib-4.5.1/modules \
    .. && \
  make -j$(nproc) && make install \
  && cp lib/* $JAVA_HOME/lib/. && cp bin/*.jar $JAVA_HOME/lib/. \
  && cd .. && rm -rf build

  WORKDIR /opt