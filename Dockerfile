FROM registry.sensetime.com/robot-env/kitty:melodic

ARG cwd=/opt
ARG cvVersion=4.5.1
ENV HTTP_PROXY=http://10.54.0.22:3128
ENV HTTPS_PROXY=https://10.54.0.22:3128
ENV http_proxy=http://10.54.0.22:3128
ENV https_proxy=https://10.54.0.22:3128


RUN apt -y update
RUN apt -y remove x264 libx264-dev
RUN apt -y install build-essential checkinstall cmake pkg-config yasm \
    git gfortran \ 
    libjpeg8-dev libpng-dev \
    software-properties-common
RUN add-apt-repository "deb http://security.ubuntu.com/ubuntu xenial-security main" && apt -y update
RUN apt -y install libjasper1 \
    libtiff-dev \
    libavcodec-dev libavformat-dev libswscale-dev libdc1394-22-dev \
    libxine2-dev libv4l-dev 
RUN cd /usr/include/linux && ln -s -f ../libv4l1-videodev.h videodev.h
RUN apt -y install libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev \
    libgtk2.0-dev libtbb-dev qt5-default \
    libatlas-base-dev \
    libfaac-dev libmp3lame-dev libtheora-dev \
    libvorbis-dev libxvidcore-dev \
    libopencore-amrnb-dev libopencore-amrwb-dev \
    libavresample-dev \
    x264 v4l-utils \
    libprotobuf-dev protobuf-compiler \
    libgoogle-glog-dev libgflags-dev \
    libgphoto2-dev libeigen3-dev libhdf5-dev doxygen

RUN apt -y install python3-dev python3-pip && \
    pip3 install -U pip numpy && \
    apt -y install python3-testresources

RUN git config --global https.proxy https://10.54.0.22:3128 && \
    git config --global http.proxy http://10.54.0.22:3128

RUN cd ${cwd} && \
    mkdir installation && \
    mkdir installation/OpenCV-"$cvVersion" && \
    git clone https://github.com/opencv/opencv.git && \
    cd opencv && \
    git checkout ${cvVersion}

RUN cd ${cwd} && \
    git clone https://github.com/opencv/opencv_contrib.git && \
    cd opencv_contrib && \
    git checkout ${cvVersion}

RUN cd ${cwd}/opencv && \
    mkdir build && \
    cd build && \
    cmake -D CMAKE_BUILD_TYPE=RELEASE \
    -D CMAKE_INSTALL_PREFIX=${cwd}/installation/OpenCV-"$cvVersion" \
    -D INSTALL_PYTHON_EXAMPLES=OFF \
    -D INSTALL_C_EXAMPLES=OFF \
    -D BUILD_opencv_python2=OFF \
    -D BUILD_opencv_python3=OFF \
    -D BUILD_opencv_java=OFF \
    -D WITH_GSTREAMER=ON \
    -D WITH_TBB=ON \
    -D WITH_V4L=ON \
    -D WITH_QT=ON \
    -D WITH_OPENGL=ON \
    -D BUILD_TESTS=OFF \
    -D BUILD_PERF_TESTS=OFF \
    -D OPENCV_EXTRA_MODULES_PATH=../../opencv_contrib/modules \
    -D BUILD_EXAMPLES=ON ..
COPY ./download_xfeatures2d.sh ${cwd}/opencv/download_xfeatures2d.sh
RUN cd ${cwd}/opencv && \
    chmod +x download_xfeatures2d.sh && \
    ./download_xfeatures2d.sh && \
    ls -ltra ${cwd}/opencv/.cache/xfeatures2d/boostdesc && \
    ls -ltra ${cwd}/opencv/.cache/xfeatures2d/vgg && \
    cd ${cwd}/opencv && \
    cd build && \
    rm -rf * && \
    cmake -D CMAKE_BUILD_TYPE=RELEASE \
    -D CMAKE_INSTALL_PREFIX=${cwd}/installation/OpenCV-"$cvVersion" \
    -D INSTALL_PYTHON_EXAMPLES=OFF \
    -D INSTALL_C_EXAMPLES=OFF \
    -D BUILD_opencv_python2=OFF \
    -D BUILD_opencv_python3=OFF \
    -D BUILD_opencv_java=OFF \
    -D WITH_GSTREAMER=ON \
    -D WITH_TBB=ON \
    -D WITH_V4L=ON \
    -D WITH_QT=ON \
    -D WITH_OPENGL=ON \
    -D BUILD_TESTS=OFF \
    -D BUILD_PERF_TESTS=OFF \
    -D OPENCV_EXTRA_MODULES_PATH=../../opencv_contrib/modules \
    -D BUILD_EXAMPLES=ON ..

RUN cd ${cwd}/opencv/build && make -j6 install

ENV HTTP_PROXY=""
ENV HTTPS_PROXY=""
ENV http_proxy=""
ENV https_proxy=""