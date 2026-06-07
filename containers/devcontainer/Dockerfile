FROM rocker/r-ver:4.4.2

RUN apt-get update && apt-get install -y --no-install-recommends \
    git curl wget make bash pandoc ca-certificates \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /workspaces/ngs-workshop

