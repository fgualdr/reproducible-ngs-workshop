# Containers

The course supports Docker and Podman. Students should normally pull prebuilt images provided by the instructor. Building locally is optional and may be slow.

This directory stores the container recipes:

```text
containers/ngs-cli/Dockerfile
containers/ngs-cli/Containerfile
containers/ngs-cli/environment.yml
containers/ngs-r/Dockerfile
containers/ngs-r/Containerfile
containers/ngs-r/install_bioc.R
containers/devcontainer/Dockerfile
containers/devcontainer/devcontainer.json
```

Runtime convention:

```bash
docker run --rm -it -v "$PWD":/work -w /work IMAGE bash
podman run --rm -it -v "$PWD":/work -w /work IMAGE bash
```

Use `THREADS=2` unless the instructor approves more.

Example local builds, for instructor testing only:

```bash
docker build -t ngs-cli:local -f containers/ngs-cli/Dockerfile containers/ngs-cli
podman build -t ngs-cli:local -f containers/ngs-cli/Containerfile containers/ngs-cli
```

Students should use the images and commands specified by the instructor during class rather than debugging container builds.
