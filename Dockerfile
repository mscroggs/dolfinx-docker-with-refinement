# Last updated: 13 July 2021

FROM dolfinx/dev-env AS dolfinx-with-refinement
WORKDIR /tmp
ENV PETSC_ARCH "linux-gnu-real-32"

RUN git clone https://github.com/FEniCS/basix.git && \
    cd basix && \
    git checkout ed714a4fe7bb6c86e17c7796d938d05a724ce174 && \
    rm -rf build-dir && \
    cmake -G Ninja -DCMAKE_BUILD_TYPE=RelWithDebInfo -B build-dir -S .  && \
    cmake --build build-dir --parallel 3 && \
    cmake --install build-dir && \
    pip3 install -v -e ./python  && \
    pip3 install git+https://github.com/FEniCS/ufl.git --no-cache-dir &&\
    pip3 install git+https://github.com/FEniCS/ffcx.git@4f8f74b2d1c84455b34927f7cc301df681d8f97d --no-cache-dir
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
