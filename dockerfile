FROM golang:1.22 as base 

WORKDIR /app

# Copy go mod and sum files
COPY go.mod ./

# Download all dependencies
RUN go mod download

# Copy the source code
COPY . .

# Build the application
RUN CGO_ENABLED=0 GOOS=linux go build -o main .

#FINAL  STAGE -Distroless image
FROM gcr.io/distroless/static-debian11

WORKDIR /app

# Copy the binary and static files
COPY --from=base /app/main /app/main
COPY --from=base /app/static /app/static

EXPOSE 8080

CMD ["/app/main"]




