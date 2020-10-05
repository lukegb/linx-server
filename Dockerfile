FROM golang:1

COPY . /go/src/github.com/andreimarcu/linx-server
WORKDIR /go/src/github.com/andreimarcu/linx-server

RUN go get -v . && \
	install -d -o 65534:65534 /data/files /data/meta

VOLUME ["/data/files", "/data/meta"]

EXPOSE 8080
USER nobody
ENTRYPOINT ["/go/bin/linx-server", "-bind=0.0.0.0:8080", "-filespath=/data/files/", "-metapath=/data/meta/"]
CMD ["-sitename=linx", "-allowhotlink"]
