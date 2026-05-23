# Base image
FROM ubuntu:latest

# Set working directory
WORKDIR /app

# Copy files from host to container
COPY app.txt /app/

# Run command during build
RUN apt-get update && apt-get install -y curl

# Document port
EXPOSE 8080

# Default command
CMD ["cat", "app.txt"]