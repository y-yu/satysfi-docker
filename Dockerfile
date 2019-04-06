FROM akabe/ocaml:alpine_ocaml4.06.1

ENV SATYSFI_VERSION 0.0.3+dev2019.03.10

RUN apk add --no-cache bash git

# Setup build directory
VOLUME ["/workdir"]

WORKDIR /workdir

# Setup SATySFi
RUN apk add --no-cache m4 && \
    # Prepare for dependencies
    opam repository add satysfi-external https://github.com/gfngfn/satysfi-external-repo.git && \
    opam update && \
    # Install SATySFi
    git clone https://github.com/gfngfn/SATySFi.git && \
    cd SATySFi && \
    opam pin add -y --no-action satysfi . && \
    opam install -y --deps-only satysfi && \
    eval $(opam env) && \
    make all && \
    make install && \
    ./download-fonts.sh && \
    ./install-libs.sh && \
    cd .. && \
    # Remove SATySFi source directory
    rm -rf SATySFi && \
    # Remove OPAM
    rm -rf /root/.opam && \
    # Remove a dependency
    apk del m4

# Setup entrypoint
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["docker-entrypoint.sh"]
