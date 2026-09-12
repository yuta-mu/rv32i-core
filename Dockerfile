FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential cmake git curl wget make ca-certificates sudo \
    gcc-riscv64-unknown-elf binutils-riscv64-unknown-elf \
    qemu-system-misc gdb-multiarch \
    verilator iverilog gtkwave \
    ocaml-nox vim \
    && rm -rf /var/lib/apt/lists/*

RUN echo "ubuntu ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/ubuntu && \
    chmod 0440 /etc/sudoers.d/ubuntu
RUN mkdir -p /workspace && chown ubuntu:ubuntu /workspace

USER ubuntu
WORKDIR /workspace
SHELL ["/bin/bash", "-c"]
CMD ["/bin/bash"]
