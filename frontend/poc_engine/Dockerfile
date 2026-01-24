# Multi-stage build for Flutter web app
FROM ubuntu:22.04 AS builder

# Install dependencies
RUN apt-get update && apt-get install -y \
    curl \
    git \
    unzip \
    xz-utils \
    zip \
    libglu1-mesa \
    && rm -rf /var/lib/apt/lists/*

# Install Flutter
ENV FLUTTER_HOME=/opt/flutter
ENV PATH=$FLUTTER_HOME/bin:$PATH

RUN git clone https://github.com/flutter/flutter.git -b stable $FLUTTER_HOME && \
    flutter doctor -v && \
    flutter config --enable-web

# Set working directory
WORKDIR /app

# Copy pubspec files
COPY pubspec.yaml pubspec.lock ./

# Get dependencies
RUN flutter pub get

# Copy the entire app
COPY . .

# Build web app
RUN flutter build web --release --web-renderer canvaskit

# Production stage - Nginx
FROM nginx:alpine

# Copy built web app to nginx
COPY --from=builder /app/build/web /usr/share/nginx/html

# Copy custom nginx configuration if needed
# COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
