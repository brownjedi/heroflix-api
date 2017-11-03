FROM golang:1.9.2-alpine3.6

ENV GIN_MODE=${GIN_MODE:-release}

# File Author / Maintainer
LABEL maintainer="Sai Karthik Reddy Ginni"

# set port
ENV PORT 8080
EXPOSE 8080

# install curl bash and git
RUN apk add --update tzdata bash wget curl git;

# Create binary directory, install glide and
RUN mkdir -p $GOPATH/bin && \
	curl https://glide.sh/get | sh && \
	go get github.com/pilu/fresh

# create src directory
RUN mkdir -p $GOPATH/src/github.com/saikarthikreddyginni/heroflix-api
WORKDIR $GOPATH/src/github.com/saikarthikreddyginni/heroflix-api

# Install all dependencies of the current project
COPY glide.lock .
COPY glide.yaml .
RUN glide install

# Copy all local files into the image
COPY . .

# if production setting will build binary
RUN go install

# run
CMD ["heroflix-api"]
