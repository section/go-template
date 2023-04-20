FROM golang:1.20.3-bullseye as build

RUN adduser \
  --disabled-password \
  --gecos "" \
  --home "/nonexistent" \
  --shell "/sbin/nologin" \
  --no-create-home \
  --uid 65532 \
  small-user

WORKDIR /usr/src/app

COPY *.go ./
COPY go.mod ./
COPY static static/

RUN go mod download
RUN go mod verify

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o .

FROM scratch

WORKDIR /usr/src/app

COPY --from=build /usr/share/zoneinfo /usr/share/zoneinfo
COPY --from=build /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=build /etc/passwd /etc/passwd
COPY --from=build /etc/group /etc/group

COPY --from=build /usr/src/app .

USER small-user:small-user

CMD ["./main"]
