FROM denoland/deno:latest

LABEL version="1.0.0" maintainer="JJMerelo@GMail.com"

WORKDIR /app
COPY tools/serve-data.ts .
RUN mkdir resources
COPY resources/*.csv resources/

EXPOSE 31415
VOLUME resources

CMD ["run", "--allow-net", "--allow-read",  "serve-data.ts"]
