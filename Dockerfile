FROM golang:1 AS builder

RUN install -d -o 65532:65532 /data/files /data/meta
WORKDIR /go/src/github.com/andreimarcu/linx-server
COPY . /go/src/github.com/andreimarcu/linx-server

RUN go get -d -v ./... && \
	go get github.com/GeertJohan/go.rice/rice

RUN go build -o /go/bin/linx-server && \
	go build -o /go/bin/linx-cleanup ./linx-cleanup && \
	/go/bin/rice append --exec /go/bin/linx-server

FROM gcr.io/distroless/base
COPY --from=builder --chown=nonroot:nonroot /data /data
COPY --from=builder /go/bin/linx-server /go/bin/linx-cleanup /

VOLUME ["/data/files", "/data/meta"]

EXPOSE 8080
USER nonroot
ENTRYPOINT ["/linx-server", "-bind=0.0.0.0:8080", "-filespath=/data/files/", "-metapath=/data/meta/"]
CMD ["-sitename=linx", "-allowhotlink"]
