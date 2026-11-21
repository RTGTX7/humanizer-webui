FROM golang:1.24-bookworm AS build
WORKDIR /src
COPY app/go.mod app/go.sum ./app/
RUN cd app && go mod download
COPY app ./app
RUN cd app && CGO_ENABLED=0 go build -trimpath -ldflags='-s -w -X main.version=webui' -o /out/humanizer ./

FROM debian:bookworm-slim
COPY --from=build /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
COPY LICENSE NOTICE /usr/share/doc/humanizer/
RUN useradd --create-home --uid 10001 humanizer
COPY --from=build /out/humanizer /usr/local/bin/humanizer
RUN mkdir -p /data && chown -R humanizer:humanizer /data
USER humanizer
ENV HUMANIZER_DATA_DIR=/data \
    HUMANIZER_EXTERNAL_URL=http://host.docker.internal:1234/v1 \
    HUMANIZER_EXTERNAL_MODEL=humanizer@q6_k \
    HUMANIZER_BIND=0.0.0.0 \
    HUMANIZER_NO_BROWSER=1 \
    HUMANIZER_SERVER=1 \
    HUMANIZER_IDLE_EXIT=0 \
    HUMANIZER_PORT=47616
EXPOSE 47616
ENTRYPOINT ["/usr/local/bin/humanizer", "--serve"]
