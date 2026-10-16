# ------------------------------------------------------------
# NGS Workshop - IDR
# ------------------------------------------------------------

FROM mambaorg/micromamba:2.3.2

LABEL org.opencontainers.image.title="NGS IDR"
LABEL org.opencontainers.image.description="IDR 2.0.4.2 for ChIP-seq reproducibility analysis"
LABEL org.opencontainers.image.authors="fgualdr"

USER root

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        bash \
        coreutils \
        ca-certificates \
    && rm -rf /var/lib/apt/lists/*

USER $MAMBA_USER

# Install IDR with its compatible dependencies
RUN micromamba install -y -n base \
    -c conda-forge \
    -c bioconda \
    --strict-channel-priority \
    idr=2.0.4.2 \
    && micromamba clean --all --yes

WORKDIR /work

# Activate the Conda environment during Docker build
ARG MAMBA_DOCKERFILE_ACTIVATE=1

# Verify installation
RUN command -v idr && \
    idr --version && \
    python --version

CMD ["bash"]