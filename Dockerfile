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

FROM petronetto/opencv-alpine:latest

MAINTAINER Guilherme Sousa <guisousa09@hotmail.com>

ENV LANG=C.UTF-8

# Install required packages
RUN apk --no-cache add \
  wget \
  apache-ant \
  tesseract-ocr

WORKDIR /opt

# Install Java
COPY resources/OpenJDK11U-jdk_x64_alpine-linux_hotspot_11.0.13_8.tar.gz OpenJDK11U-jdk_x64_alpine-linux_hotspot_11.0.13_8.tar.gz
RUN tar -xf OpenJDK11U-jdk_x64_alpine-linux_hotspot_11.0.13_8.tar.gz && rm OpenJDK11U-jdk_x64_alpine-linux_hotspot_11.0.13_8.tar.gz
ENV JAVA_HOME /opt/jdk-11.0.13+8
ENV PATH $JAVA_HOME/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

# Tesseract tessdata Path configuration
ENV TESSDATA_PREFIX /usr/share/tessdata

WORKDIR /opt/opencv-3.2.0/build

# Install OpenCV
RUN cmake -D CMAKE_BUILD_TYPE=RELEASE \
    -D CMAKE_C_COMPILER=/usr/bin/clang \
    -D CMAKE_CXX_COMPILER=/usr/bin/clang++ \
    -D CMAKE_INSTALL_PREFIX=/usr/lib \
    -D INSTALL_PYTHON_EXAMPLES=OFF \
    -D INSTALL_C_EXAMPLES=OFF \
    -D WITH_FFMPEG=ON \
    -D WITH_TBB=ON \
    -D BUILD_opencv_python2=OFF \
    -D BUILD_opencv_python3=OFF \
    -D OPENCV_EXTRA_MODULES_PATH=/opt/opencv_contrib-3.2.0/modules \
    .. && \
  make -j$(nproc) && make install && cp lib/* $JAVA_HOME/lib/. && \
  cd .. && rm -rf build

WORKDIR /opt