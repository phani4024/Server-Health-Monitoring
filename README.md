We'll be employing Node Exporter to keep a close watch on how our servers (be they EC2 instances, physical machines, or Docker containers) are doing.

Think of **Node Exporter** as a kind of "sensor" that's installed on our server. Its job is to gather essential performance data, such as:

*   The current CPU utilization
*   The amount of memory in use
*   The disk's remaining capacity
*   The speed of data transfer across the network

**Behind the Scenes of Server Monitoring:**

- After running **Node Exporter**, it exports the data to **Prometheus** which acts like a central data store. 
- **Prometheus** doesn't only store the data but it also validates the data at certain time-interval (e.g. every 15s) and checks if there's going to be any unusual.
- So, if your server’s **CPU usage** goes too high or **memory usage** gets out of hand, **Prometheus** can raise an alert based on the rules you set (like "CPU usage > 85% for 5 minutes").
- This is where **Alertmanager** comes in — it ensures you get notified (e.g., via **Slack**) if something goes wrong.
- Lastly, to understand all this data, **Grafana** offers you attractive dashboards where you can view the **metrics** visually.
- You can even monitor trends over time (for instance, CPU usage rising throughout the day).

- In brief, **Node Exporter** helps **Prometheus** to understand what is happening inside your server, and **Grafana** helps you visualizing it all. If things go wrong, **Alertmanager** ensures you receive a notification!

**What You Need**

- Before you start:
- Docker and Docker Compose has to be installed on your system.
- A Slack workspace and a valid Slack Webhook URL to receive alerts.

**How to Set It Up**
- Download the Files: Clone or download the project files to your instance or local system.
- Customize Your Configuration:Open the alertmanager/alertmanager.yml file and update the Slack Webhook URL with your own URL and Workspace with your own workspace so you can receive notifications.

- Start the Services:

- From your project folder, run the following command to spin up the entire monitoring setup:

**docker-compose up -d**


- This will start Prometheus, Grafana, Node Exporter, and Alertmanager in the background.

**Access the Dashboards:**

![image](https://github.com/user-attachments/assets/47b92b5d-23d8-417b-bfb2-8f1929da6e9e)

Metrics we will be Monitoring

Prometheus will collect the following metrics from Node Exporter:

- CPU Usage: How much of the CPU your system is using.

- Memory Usage: How much memory is being used on the system.

- Disk Usage: How much of your disk space is filled up.

- Network Traffic: The amount of network traffic coming into your server on the eth0 interface.

  **Load Simulation Script**

To load and trigger the alerts, use the dummy_load.sh script. This will stress the CPU, memory, disk, and network.

**Alerts**

If any of these things go wrong, the system will alert:

- High CPU Usage: If CPU usage goes over 85% for more than 5 minutes.

- High Memory Usage: If memory usage goes over 85% for more than 5 minutes.

- High Disk Usage: If disk usage exceeds 85% for more than 5 minutes.

- High Network Traffic: If the network receive rate goes over 100 KB/s.

All alerts will be sent to your specified Slack channel (as configured in alertmanager/alertmanager.yml).

**🌪️ When your CPU hits the fan, you’ll hear about it — in Slack, with style.**

Feel free to fork, modify, and expand this setup for more production-grade observability — including container metrics, uptime monitoring, and log aggregation
