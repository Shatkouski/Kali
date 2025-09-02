# Use official Kali Linux image as base
FROM kalilinux/kali-rolling:latest

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONUNBUFFERED=1

# Update package lists and install essential packages
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y \
    python3 \
    python3-pip \
    sudo \
    curl \
    wget \
    git \
    vim \
    nano \
    && rm -rf /var/lib/apt/lists/*

# Create a non-root user for security
RUN useradd -m -s /bin/bash kali && \
    echo "kali:kali" | chpasswd && \
    usermod -aG sudo kali && \
    echo "kali ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Set working directory
WORKDIR /home/kali

# Copy the setup script
COPY start_setting /home/kali/start_setting

# Make the script executable
RUN chmod +x /home/kali/start_setting

# Create a directory for wordlists and tools
RUN mkdir -p /usr/share/wordlists && \
    chown -R kali:kali /usr/share/wordlists

# Switch to non-root user
USER root

# Set the default command to run the setup script
CMD ["python3", "/home/kali/start_setting"]
