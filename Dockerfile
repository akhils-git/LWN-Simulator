# Use an official Go runtime as a base image
FROM golang:1.19-alpine AS builder

# Set the current working directory inside the container
WORKDIR /app

# Copy the Go source code into the container
COPY . .

# Install necessary dependencies (if any)
RUN go mod tidy

# Build the Go application
RUN go build -o /bin/lwnsimulator .

# Use a smaller image to run the compiled application
FROM alpine:latest

# Set the working directory in the new image
WORKDIR /app

# Copy the compiled binary from the builder image
COPY --from=builder /bin/lwnsimulator /bin/lwnsimulator

# Copy the config.json file
COPY bin/config.json /app/config.json

# Expose ports (optional, adjust as needed)
EXPOSE 8000
EXPOSE 8001

# Command to run the application
CMD ["/bin/lwnsimulator", "-config", "/app/config.json"]
