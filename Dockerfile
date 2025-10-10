FROM nvidia/cudagl:11.4.2-devel-ubuntu20.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    wget git build-essential ca-certificates curl && \
    rm -rf /var/lib/apt/lists/*

ENV CONDA_DIR=/opt/conda
ENV PATH=$CONDA_DIR/bin:$PATH

RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh && \
    bash ~/miniconda.sh -b -p $CONDA_DIR && \
    rm ~/miniconda.sh && \
    conda clean -afy

RUN conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/main && \
conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/r

ARG ENV_NAME=env
RUN conda create -y -n $ENV_NAME python=3.9 && conda clean -afy
ENV PATH=$CONDA_DIR/envs/$ENV_NAME/bin:$PATH

WORKDIR /app
COPY requirements.txt .

RUN apt-get update && apt-get install -yq --no-install-recommends \
    bc \
    build-essential \
    cmake \
    curl \
    g++ \
    gfortran \
    git \
    libffi-dev \
    libfreetype6-dev \
    libhdf5-dev \
    libjpeg-dev \
    liblcms2-dev \
    libopenblas-dev \
    liblapack-dev \
    libssl-dev \
    libtiff5-dev \
    libwebp-dev \
    libzmq3-dev \
    nano \
    pkg-config \
    software-properties-common \
    screen \
    tmux \
    unzip \
    vim \
    wget \
    zlib1g-dev \
    qt5-default \
    libvtk6-dev \
    zlib1g-dev \
    libjpeg-dev \
    libwebp-dev \
    libtiff5-dev \
    libopenexr-dev \
    libgdal-dev \
    libdc1394-22-dev \
    libavcodec-dev \
    libavformat-dev \
    libswscale-dev \
    libtheora-dev \
    libvorbis-dev \
    libxvidcore-dev \
    libx264-dev \
    yasm \
    libopencore-amrnb-dev \
    libopencore-amrwb-dev \
    libv4l-dev \
    libxine2-dev \
    libtbb-dev \
    libeigen3-dev \
    doxygen \
    ffmpeg \
    zip \
    swig \
    rsync \
    python3-pip \
    python3-dev \
    python-dev \
    xvfb && \
    apt-get clean && \
    apt-get autoremove && \
    rm -rf /var/lib/apt/lists/*

RUN pip install --upgrade pip && \
    pip install -r requirements.txt


RUN pip install git+https://github.com/IDEA-Research/GroundingDINO.git && \
    pip install git+https://github.com/Farama-Foundation/Metaworld.git@v2.0.0#egg=metaworld && \
    pip install git+https://github.com/facebookresearch/fvcore && \
    pip install git+https://github.com/facebookresearch/segment-anything.git && \
    pip install git+https://github.com/openai/CLIP.git

RUN pip install "moviepy==1.0.3" --no-deps

ENV NVIDIA_VISIBLE_DEVICES=all
ENV NVIDIA_DRIVER_CAPABILITIES=compute,utility


CMD ["bash", "-c", "source /opt/conda/etc/profile.d/conda.sh && conda activate env && exec bash"]