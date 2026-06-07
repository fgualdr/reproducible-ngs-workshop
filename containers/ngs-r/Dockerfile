FROM rocker/r-ver:4.4.2

RUN apt-get update && apt-get install -y --no-install-recommends \
    libcurl4-openssl-dev libssl-dev libxml2-dev libhdf5-dev libgit2-dev \
    libfontconfig1-dev libharfbuzz-dev libfribidi-dev libfreetype6-dev \
    libpng-dev libtiff5-dev libjpeg-dev pandoc \
  && rm -rf /var/lib/apt/lists/*

COPY install_bioc.R /tmp/install_bioc.R
RUN Rscript /tmp/install_bioc.R
WORKDIR /work
CMD ["R"]

