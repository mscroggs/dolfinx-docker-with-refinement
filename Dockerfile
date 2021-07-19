# Last updated: 19 July 2021

FROM dolfinx/dev-env AS dolfinx-with-refinement
WORKDIR /tmp
ENV PETSC_ARCH "linux-gnu-real-32"

RUN git clone https://github.com/FEniCS/basix.git && \
    cd basix && \
    rm -rf build-dir && \
    cmake -G Ninja -DCMAKE_BUILD_TYPE=RelWithDebInfo -B build-dir -S .  && \
    cmake --build build-dir --parallel 3 && \
    cmake --install build-dir && \
    pip3 install -v -e ./python  && \
    pip3 install git+https://github.com/FEniCS/ufl.git --no-cache-dir &&\
    pip3 install git+https://github.com/FEniCS/ffcx.git --no-cache-dir
RUN git clone https://github.com/fenics/dolfinx.git && \
    cd dolfinx && \
    git checkout mscroggs/refinement && \
    mkdir build && \
    cd build && \
    cmake -G Ninja ../cpp && \
    ninja ${MAKEFLAGS} install && \
    cd ../python && \
    . /usr/local/lib/dolfinx/dolfinx.conf && \
    pip3 install .
RUN rm -rf /tmp/*

WORKDIR /root
