################################################################################################
# - Base stage
#   - This stage serves as the foundational stage for all other stages.
#   - Base image: Nvidia CUDE 12.4.0 runtime image on Ubuntu 22.04
#       - https://hub.docker.com/layers/nvidia/cuda/12.4.0-runtime-ubuntu22.04/images/sha256-2d205a50fefc321aca51a1d3aa46fb9a633dd2509a10e28c8bd34a6cb2027619
################################################################################################

FROM nvidia/cuda:12.4.0-runtime-ubuntu22.04 AS base

LABEL org.opencontainers.image.title="Docker Image of HRC ACT-Plus-Plus for Koch"
LABEL org.opencontainers.image.authors="yoseph.huang@gmail.com"
LABEL org.opencontainers.image.licenses="MIT"

ARG USERNAME=user
ARG USER_UID=1000
ARG USER_GID=$USER_UID

SHELL ["/bin/bash", "-c"]


################################################################################################
# - Python Building stage
#   - In this stage, I will install and set python3.8.10 as the default python version.
#   - Building tools will be removed after this stage.
################################################################################################

FROM base AS python-build

RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    cmake \ 
    curl \
    libbz2-dev \
    libffi-dev \
    liblzma-dev \
    libncurses5-dev \
    libreadline-dev \
    libsqlite3-dev \
    libssl-dev \
    wget \
    xz-utils \
    zlib1g-dev \
    && rm -rf /var/lib/apt/lists/*

# Download and compile Python 3.8.10
RUN wget https://www.python.org/ftp/python/3.8.10/Python-3.8.10.tgz && \
    tar -xvf Python-3.8.10.tgz && \
    cd Python-3.8.10 && \
    ./configure --enable-optimizations && \
    make -j$(nproc) && \
    make altinstall && \
    cd .. && rm -rf Python-3.8.10 Python-3.8.10.tgz


################################################################################################
# - Python Dependencies Installation stage
#   - In this stage, I will install all the python dependencies.
#       - act github repository: https://github.com/tonyzhaozh/act
#       - robomimic github repository:: https://github.com/ARISE-Initiative/robomimic
################################################################################################

FROM base AS python-dep

COPY --from=python-build /usr/local/lib/python3.8 /usr/local/lib/python3.8
COPY --from=python-build /usr/local/bin/python3.8 /usr/local/bin/python3.8
COPY --from=python-build /usr/local/bin/pip3.8 /usr/local/bin/pip3

# Set Python 3.8.10 as default
RUN ln -sf /usr/local/bin/python3.8 /usr/bin/python3 && \
    ln -sf /usr/local/bin/pip3.8 /usr/bin/pip

# Install Python dependencies
RUN pip3 install --upgrade pip && \
    pip3 install \
    dm_control==1.0.14 \
    einops \
    h5py \
    ipython \
    matplotlib \
    mujoco==2.3.7 \
    opencv-python \
    packaging \
    pexpect \
    pyquaternion \
    pyyaml \
    rospkg \
    torch \
    torchvision \
    wandb

################################################################################################
# - Tools Installation stage 
#   - In this stage, I will install some useful development tools.
################################################################################################

FROM python-dep AS actpp-core

# Install Git 
RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    build-essential \
    cmake \
    git \
    libgl1-mesa-glx \
    libglib2.0-0 \
    libsm6 \
    libxrender1 \
    libxext6 \
    && rm -rf /var/lib/apt/lists/*

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


################################################################################################
# - ACT++ Workspace Setup stage
#   - In this stage, I will setup act-plus-plus workspace.
################################################################################################

FROM python-dep AS final

COPY --from=actpp-core /usr/local/lib/python3.8 /usr/local/lib/python3.8
COPY --from=actpp-core /usr/local/bin/python3.8 /usr/local/bin/python3.8
COPY --from=actpp-core /usr/local/bin/pip3.8 /usr/local/bin/pip3

# Install some tools
RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    nano \
    x11-apps \
    && rm -rf /var/lib/apt/lists/*

# Workspace directory
WORKDIR /actpp-core

CMD ["/bin/bash"]
