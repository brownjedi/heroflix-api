FROM golang:1.9.2-alpine3.6

ARG app_env
ENV APP_ENV ${app_env:-production}
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
RUN mkdir -p $GOPATH/src/api
WORKDIR $GOPATH/src/api

# Install all dependencies of the current project
COPY glide.lock .
COPY glide.yaml .
RUN glide install

# Copy all local files into the image
COPY . .

# if production setting will build binary
RUN if [ ${APP_ENV} = production ]; \
	then \
		go install; \
	fi

# run
CMD ["api"]
