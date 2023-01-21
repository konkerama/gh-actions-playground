#!/bin/bash
sudo yum update -y  
sudo yum install -y docker
sudo yum install -y jq
sudo systemctl enable docker
sudo systemctl start docker

# docker run -p 5000:5000 -d --restart unless-stopped konkerama/sample-python-container:${commit_id}


docker run  -d \
            -p 8080:8080 \
            --restart unless-stopped \
            --env ENV=${env} \
            --log-driver=awslogs \
            --log-opt awslogs-region=eu-west-1 \
            --log-opt awslogs-group=${log_group} \
            --log-opt awslogs-multiline-pattern='^(INFO|DEBUG|WARN|ERROR|CRITICAL)' \
            konkerama/sample-python-container:${commit_id} 
