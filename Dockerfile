FROM golang:1.16-alpine3.13

RUN apk add --no-cache protobuf-dev bash make git curl

RUN ver=`protoc --version` \
    && ver=${ver/libprotoc /} \
    && PROTOC_ZIP=protoc-${ver}-linux-x86_64.zip \
    && curl -OL https://github.com/protocolbuffers/protobuf/releases/download/v${ver}/$PROTOC_ZIP \
    && unzip -o $PROTOC_ZIP -d /usr/local 'include/*' \
    && rm -f $PROTOC_ZIP

RUN ls -alh /usr/local/include/ && go env && echo $PATH

RUN GO111MODULE=on go get \
    github.com/golang/protobuf/protoc-gen-go@v1.3.2 \
    github.com/gogo/protobuf/protoc-gen-gogoslick@v1.2.1 \
    github.com/gogo/protobuf/gogoproto@v1.2.1 \
    github.com/go-delve/delve/cmd/dlv@v1.7.2 \
    # Due to the lack of a proper release tag, we use the commit hash of
    # https://github.com/golang/tools/releases v0.1.7
    github.com/mitchellh/gox && \
    rm -rf ${GOPATH}/pkg ${GOPATH}/src
