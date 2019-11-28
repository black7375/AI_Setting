## -*- docker-image-name: "alstjr7375/typed" -*-
# == Init ================================
FROM tensorflow/tensorflow:latest-gpu-py3
MAINTAINER alstjr375 <alstjr7375@daum.net>

ENV DEBIAN_FRONTEND teletype
RUN  apt-get -y -qq update &&  \
        apt-get install -y -qq --no-install-recommends apt-utils && \
        apt-get -y -qq full-upgrade && \
        pip3 install --upgrade pip

# == Setting =============================
# -- AI Packages -------------------------
WORKDIR /ai
RUN apt-get -y -qq --no-install-recommends install \
        python3-pip        \
        # cuda
        nvidia-cuda-toolkit

RUN pip3 install --no-cache-dir  \
        keras      \
        sklearn    \
        numpy      \
        pandas     \
        h5py       \
        image      \
        matplotlib

# Port for Tensorboard
EXPOSE 6006

# -- Server Packages -------------------------
RUN apt-get -y -qq install --no-install-recommends openjdk-8-jdk && \
        apt-get clean && \
        rm -rf /var/lib/apt/lists/*
RUN pip3 install --no-cache-dir  \
        lxml          \
        gensim        \
        pyarrow       \
        flask-restful \
        boilerpipe3

# -- Font Packages (for ascii2hangul) -------------
RUN pip3 install --no-cache-dir \
        fonttools \
        zopfli    \
        brotli
