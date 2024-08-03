FROM golang:1.22 as base 

WORKDIR /the/workdir/path

COPY go.mod .

RUN go mod download 

COPY . .

RUN go build -o main .

#FINAL  STAGE -Distroless image
FROM gcr.io/Distroless

COPY --from=base /app/main /

COPY --from=base /app/static/ ./static

EXPOSE 8080

CMD [ "./main" ]





