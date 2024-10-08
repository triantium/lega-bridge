FROM golang:1.23 as build-stage


WORKDIR /app
COPY go.mod go.sum ./

RUN go mod download

COPY . ./


RUN CGO_ENABLED=0 GOOS=linux go build -o /sfs-bridge

FROM gcr.io/distroless/base-debian12 AS build-release-stage

WORKDIR /

COPY --from=build-stage /sfs-bridge /sfs-bridge

USER nonroot:nonroot
CMD ["/sfs-bridge"]