FROM ghcr.io/jj/raku-zef-gha

LABEL version="1.0.0" maintainer="JJMerelo@GMail.com"

COPY META6.json Akefile .
COPY lib/ lib/
COPY resources/ resources/

RUN zef install --/test .

WORKDIR /home/raku/test
USER root

ENTRYPOINT ["ake", "CSV"]

