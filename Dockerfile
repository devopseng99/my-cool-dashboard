FROM docker.io/library/golang:1.22-alpine AS builder
WORKDIR /app
COPY go.mod ./
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -ldflags="-s -w" -o /cool-dashboard .

FROM docker.io/library/alpine:3.20
RUN apk --no-cache add ca-certificates && \
    addgroup -g 1000 -S appgroup && \
    adduser -u 1000 -S appuser -G appgroup
USER appuser
COPY --from=builder /cool-dashboard /cool-dashboard
EXPOSE 8080
ENTRYPOINT ["/cool-dashboard"]
