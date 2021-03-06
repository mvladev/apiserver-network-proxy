# Build the proxy-agent binary
FROM golang:1.12.1 as builder

# Copy in the go src
WORKDIR /go/src/sigs.k8s.io/apiserver-network-proxy
COPY pkg/    pkg/
COPY cmd/    cmd/
COPY proto/  proto/
COPY vendor/ vendor/

# Build
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -a -o proxy-agent sigs.k8s.io/apiserver-network-proxy/cmd/agent

# Copy the loader into a thin image
FROM scratch
WORKDIR /
COPY --from=builder /go/src/sigs.k8s.io/apiserver-network-proxy/proxy-agent .
ENTRYPOINT ["/proxy-agent"]
