#!/bin/bash

# Install extra packages and stress tools
amazon-linux-extras install epel -y
sudo yum install stress -y
sudo yum install iproute -y

echo "Starting CPU stress for 5 minutes..."

# Simulate CPU load
stress --cpu 1 --timeout 400 &
# Simulate memory usage
stress --vm 1 --vm-bytes 100% --timeout 400 &


# Install and run stress-ng for disk and net load
sudo yum install stress-ng -y
# Simulate disk I/O
stress-ng --hdd 1 --hdd-bytes 1G --timeout 400 &
# Add 100ms artificial network delay
sudo tc qdisc add dev eth0 root netem delay 100ms

wait  # Wait for all background jobs to finish

