FROM ghcr.io/jj/raku-zef-gha

LABEL version="1.0.0" maintainer="JJMerelo@GMail.com"

COPY META6.json bin lib .

RUN zef install .


ENTRYPOINT ["ake", "CSV"]

