To keep an eye on the performance of our servers (like EC2 instances, physical servers, or Docker containers), we will be using Node Exporter.

Assume **Node Exporter** as a "sensor" running on our server. It will collect source metrics like:

- How much CPU is being used
- How much memory is being consumed
- How full the disk is
- How fast data is coming in and going out over the network

After running **Node Exporter**, it exports the data to **Prometheus** which acts like a central data store. **Prometheus** doesn't only store the data but it also validates the data at certain time-interval (e.g. every 15s) and checks if there's going to be any unusual.
So, if your server’s **CPU usage** goes too high or **memory usage** gets out of hand, **Prometheus** can raise an alert based on the rules you set (like "CPU usage > 85% for 5 minutes").
This is where **Alertmanager** comes in — it ensures you get notified (e.g., via **Slack**) if something goes wrong.
Finally, to make sense of all this data, **Grafana** gives you beautiful dashboards where you can see the **metrics** visually. You can even track trends over time (e.g., CPU usage increasing throughout the day).
In short, **Node Exporter** helps **Prometheus** understand what's happening inside your server, and **Grafana** helps you visualize it all. If things go wrong, **Alertmanager** makes sure you get a notification!

**What You Need**
Before setting everything up, you’ll need:
**Docker** and **Docker Compose** to be installed on your system.
A **Slack workspace** and a valid **Slack Webhook URL** to receive alerts.

**How to Set It Up**
Download the Files: Start by cloning or downloading the project files to your instance or local system.
Customize Your Configuration:Open the alertmanager/alertmanager.yml file and update the **Slack Webhook URL** with your own URL and **Workspace** with your own workspace so that you can receive notifications.
Start the Services:
From your project folder, run the following command to launch the entire monitoring setup:
**docker-compose up -d**
This will start up Prometheus, Grafana, Node Exporter, and Alertmanager in the background.

**Access the Dashboards:**

- Node Exporter: http://localhost:9100
- Prometheus UI: http://localhost:9090
- Grafana UI: http://localhost:3000 (default login: username: admin, password: admin)
- Alertmanager UI: http://localhost:9093
  
**Metrics we will be Monitoring**

Prometheus will collects several key metrics from Node Exporter, including:
- CPU Usage: How much of the CPU your system is using.
- Memory Usage: How much memory is being used on the system.
- Disk Usage: How much of your disk space is filled up.
- Network Traffic: The amount of network traffic coming into your server on the eth0 interface.

**Alerts Setup**
If any of these things go wrong, the system will send an alert:
- High CPU Usage: If CPU usage goes over 85% for more than 5 minutes.
- High Memory Usage: If memory usage goes over 85% for more than 5 minutes.
- High Disk Usage: If disk usage exceeds 85% for more than 5 minutes.
- High Network Traffic: If the network receive rate goes over 100 KB/s.
All alerts will be sent to your specified Slack channel (as configured in alertmanager/alertmanager.yml).


## Load Simulation Script

To load and trigger the alerts, use the `dummy_load.sh` script. This will stress the CPU, memory, disk, and network:

**dummy_load.sh**
#!/bin/bash

# Install extra packages and stress tools
amazon-linux-extras install epel -y
sudo yum install stress iproute stress-ng -y

echo "Starting CPU and memory stress for 5 minutes..."
# Simulate CPU load
stress --cpu 1 --timeout 400 &
# Simulate memory usage
stress --vm 1 --vm-bytes 100% --timeout 400 &
# Simulate disk I/O
stress-ng --hdd 1 --hdd-bytes 1G --timeout 400 &
# Add 100ms artificial network delay
sudo tc qdisc add dev eth0 root netem delay 100ms

wait  # Wait for all background jobs to finish


