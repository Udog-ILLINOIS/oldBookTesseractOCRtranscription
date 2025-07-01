FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV TESSDATA_PREFIX=/usr/local/share/tessdata

RUN apt update && apt install -y \
    git curl wget make cmake g++ pkg-config \
    libleptonica-dev \
    libtiff-dev libjpeg-dev zlib1g-dev \
    libpng-dev libicu-dev \
    libpango1.0-dev libcairo2-dev \
    libtool automake autoconf \
    fonts-dejavu fonts-liberation fonts-freefont-ttf \
    && apt clean

# --- Build Tesseract with training ---
WORKDIR /opt
RUN git clone --branch 4.1.1 https://github.com/tesseract-ocr/tesseract.git && \
    cd tesseract && \
    ./autogen.sh && \
    ./configure --enable-training && \
    make -j$(nproc) && \
    make training && \
    make install && \
    make training-install && \
    ldconfig

# --- Download traineddata ---
RUN mkdir -p /usr/local/share/tessdata && \
    wget -O /usr/local/share/tessdata/spa.traineddata \
    https://github.com/tesseract-ocr/tessdata_best/raw/main/spa.traineddata

WORKDIR /workspace
