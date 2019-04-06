FROM akabe/ocaml:alpine_ocaml4.06.1

ENV SATYSFI_VERSION 0.0.3+dev2019.03.10

ENV PATH /root/.opam/${OCAML_VERSION}/bin:$PATH

RUN apk add --no-cache bash make git

# Setup SATySFi
RUN opam repository add satysfi-external --all-switches https://github.com/gfngfn/satysfi-external-repo.git && \
    opam repository add satyrographos-repo --all-switches https://github.com/na4zagin3/satyrographos-repo.git && \
    opam update && \
    opam install -y depext && \
    opam depext satysfi.${SATYSFI_VERSION} satysfi-lib-dist.${SATYSFI_VERSION} satyrographos && \
    opam install -y satysfi.${SATYSFI_VERSION} satysfi-lib-dist.${SATYSFI_VERSION} satyrographos && \
    satyrographos install && \
    opam clean -a -c -s --logs

COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh

VOLUME ["/workdir"]

WORKDIR /workdir

ENTRYPOINT ["docker-entrypoint.sh"]
