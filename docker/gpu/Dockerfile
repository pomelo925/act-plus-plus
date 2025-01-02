# Use a base image with Python 3.8.10
FROM nvidia/cuda:12.4.0-runtime-ubuntu22.04

# Set working directory
WORKDIR /actpp

# Install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    libgl1-mesa-glx \
    libglib2.0-0 \
    libsm6 \
    libxrender1 \
    libxext6 \
    wget \
    git \
    pip \
    cmake \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install Python dependencies
RUN pip install --upgrade pip && \
    pip install \
    torchvision \
    torch \
    pyquaternion \
    pyyaml \
    rospkg \
    pexpect \
    mujoco==2.3.7 \
    dm_control==1.0.14 \
    opencv-python \
    matplotlib \
    einops \
    packaging \
    h5py \
    ipython

# Clone and install the act package
RUN git clone https://github.com/tonyzhaozh/act.git && \
    cd act/detr && \
    pip install -e . && \
    cd ../.. && rm -rf act

# Clone and install the robomimic package (r2d2 branch)
RUN git clone -b r2d2 https://github.com/ARISE-Initiative/robomimic.git && \
    cd robomimic && \
    pip install -e . && \
    cd .. && rm -rf robomimic

CMD ["/bin/bash"]
