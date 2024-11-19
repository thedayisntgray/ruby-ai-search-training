FROM rubydata/datascience-notebook

USER root

# Install system dependencies
RUN apt-get update && \
    apt-get install -y \
    build-essential \
    cmake \
    git \
    curl \
    unzip \
    ruby-dev \
    pkg-config \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Download and install LibTorch (CPU version)
RUN cd /tmp && \
    curl -L "https://download.pytorch.org/libtorch/cpu/libtorch-cxx11-abi-shared-with-deps-2.5.1%2Bcpu.zip" > libtorch.zip && \
    unzip -q libtorch.zip -d /usr/local && \
    rm libtorch.zip

# Set environment variables for LibTorch and Rice
ENV TORCH_DIR=/usr/local/libtorch
ENV LD_LIBRARY_PATH=${TORCH_DIR}/lib:$LD_LIBRARY_PATH
ENV CPATH="/home/jovyan/.local/share/gem/ruby/3.1.0/gems/rice-4.3.3/include:$CPATH"
ENV LIBRARY_PATH="/home/jovyan/.local/share/gem/ruby/3.1.0/gems/rice-4.3.3/lib:$LIBRARY_PATH"

# Switch to notebook user for gem installations
USER ${NB_UID}

# Install gems with specific configurations
RUN gem uninstall rice torch-rb transformers-rb --all --executables --ignore-dependencies || true && \
    gem install rice -- --with-opt-include=/home/jovyan/.local/share/gem/ruby/3.1.0/gems/rice-4.3.3/include && \
    gem install torch-rb -- \
        --with-torch-dir=/usr/local/libtorch \
        --with-opt-include=/home/jovyan/.local/share/gem/ruby/3.1.0/gems/rice-4.3.3/include && \
    gem install transformers-rb

# Switch back to notebook user
USER ${NB_UID}

# Set working directory
WORKDIR /home/jovyan/work