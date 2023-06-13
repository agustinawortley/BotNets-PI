
#!/bin/bash

sudo systemctl start suricata.service
sudo systemctl start elasticsearch.service
sudo systemctl start kibana.service
sudo systemctl start filebit.service
