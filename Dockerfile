# compile and run Go script in a lightweight container
FROM golang:1.12.7-alpine3.10 AS build
# support CGO and SSL
RUN apk --no-cache add gcc g++ make
RUN apk add git
WORKDIR /go/src/app
COPY . .
RUN go get github.com/gorilla/mux
RUN GOOS=linux go build -ldflags="-s -w" -o ./bin/test ./main.go

#  take from the first one the Go executable only avoiding all artifacts from the precedent building
FROM alpine:3.10
RUN apk --no-cache add ca-certificates
WORKDIR /usr/bin
COPY --from=build /go/src/app/bin /go/bin
EXPOSE 8080
ENTRYPOINT /go/bin/test --port 8080