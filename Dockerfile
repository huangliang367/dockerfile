FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Shanghai

# Use Aliyun mirror for faster apt in China
RUN sed -i 's|http://archive.ubuntu.com/ubuntu/|http://mirrors.aliyun.com/ubuntu/|g' /etc/apt/sources.list && \
    sed -i 's|http://security.ubuntu.com/ubuntu/|http://mirrors.aliyun.com/ubuntu/|g' /etc/apt/sources.list

# Install base build tools, cross-compiler, QEMU, and utilities
RUN apt-get update && apt-get install -y \
    # Base build essentials
    build-essential \
    gcc \
    g++ \
    make \
    cmake \
    ninja-build \
    bc \
    bison \
    flex \
    libssl-dev \
    libgnutls28-dev \
    libncurses5-dev \
    libncursesw5-dev \
    pkg-config \
    python3 \
    python3-pip \
    python3-venv \
    # ARM64 cross-compiler
    gcc-aarch64-linux-gnu \
    g++-aarch64-linux-gnu \
    binutils-aarch64-linux-gnu \
    libc6-dev-arm64-cross \
    # QEMU
    qemu-system-arm \
    qemu-system-aarch64 \
    qemu-utils \
    # U-Boot tools
    u-boot-tools \
    # Filesystem / image tools
    debootstrap \
    qemu-user-static \
    binfmt-support \
    parted \
    dosfstools \
    e2fsprogs \
    genext2fs \
    kpartx \
    fdisk \
    gdisk \
    # Utilities
    git \
    wget \
    curl \
    vim \
    nano \
    tree \
    file \
    cpio \
    gzip \
    xz-utils \
    unzip \
    rsync \
    sudo \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Create aarch64-none-elf- symlinks for U-Boot build
# (aarch64-linux-gnu-gcc works for bare-metal U-Boot)
RUN for tool in gcc g++ ar ld objcopy objdump nm strip; do \
        ln -sf /usr/bin/aarch64-linux-gnu-${tool} /usr/local/bin/aarch64-none-elf-${tool}; \
    done

# Install Google repo tool
RUN curl -o /usr/local/bin/repo https://storage.googleapis.com/git-repo-downloads/repo \
    && chmod a+x /usr/local/bin/repo

# Set up binfmt for ARM64 binary execution (optional, for chroot)
RUN update-binfmts --enable qemu-aarch64 || true

# Create a non-root user for daily use
ARG USERNAME=hl
ARG USER_UID=1000
ARG USER_GID=1000
RUN groupadd --gid ${USER_GID} ${USERNAME} \
    && useradd --uid ${USER_UID} --gid ${USER_GID} -m ${USERNAME} \
    && echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/${USERNAME} \
    && chmod 0440 /etc/sudoers.d/${USERNAME}

# Set working directory
WORKDIR /workspace

# Default to bash
CMD ["/bin/bash"]
