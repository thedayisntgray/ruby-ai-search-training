FROM rubydata/datascience-notebook

USER root
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

RUN cd /tmp && \
    curl -L "https://download.pytorch.org/libtorch/cpu/libtorch-cxx11-abi-shared-with-deps-2.5.1%2Bcpu.zip" > libtorch.zip && \
    unzip -q libtorch.zip -d /usr/local && \
    rm libtorch.zip

ENV TORCH_DIR=/usr/local/libtorch \
    LD_LIBRARY_PATH=/usr/local/libtorch/lib:$LD_LIBRARY_PATH \
    CPATH="/home/jovyan/.local/share/gem/ruby/3.1.0/gems/rice-4.3.3/include:$CPATH" \
    LIBRARY_PATH="/home/jovyan/.local/share/gem/ruby/3.1.0/gems/rice-4.3.3/lib:$LIBRARY_PATH"

USER ${NB_UID}

RUN gem uninstall rice torch-rb transformers-rb --all --executables --ignore-dependencies || true && \
    gem install rice -- --with-opt-include=/home/jovyan/.local/share/gem/ruby/3.1.0/gems/rice-4.3.3/include && \
    gem install torch-rb -- \
        --with-torch-dir=/usr/local/libtorch \
        --with-opt-include=/home/jovyan/.local/share/gem/ruby/3.1.0/gems/rice-4.3.3/include

RUN gem install transformers-rb && \
    gem install tqdm && \
    gem install polars-df && \
    gem install opensearch-ruby && \
    gem install httparty && \
    gem install mini_magick && \
    gem install onnxruntime && \
    gem install rmagick && \
    gem install ruby-openai && \
    gem install faiss

WORKDIR /home/jovyan/work