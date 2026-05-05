#!/bin/bash
# EC2 Bootstrap Script — runs once on first launch

set -e
exec > >(tee /var/log/user-data.log | logger -t user-data -s 2>/dev/console) 2>&1

echo "=== Starting EC2 bootstrap ==="

# Update packages
yum update -y

# Install dependencies
yum install -y nginx python3 python3-pip aws-cli

# Start and enable nginx
systemctl start nginx
systemctl enable nginx

# Write a simple health-check HTML page
cat > /usr/share/nginx/html/index.html <<EOF
<!DOCTYPE html>
<html>
<head><title>Terraform Multi-AZ Web App</title></head>
<body>
  <h1>🚀 Deployed with Terraform</h1>
  <p>Instance ID: $(curl -s http://169.254.169.254/latest/meta-data/instance-id)</p>
  <p>AZ: $(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone)</p>
  <p>S3 Bucket: ${s3_bucket_name}</p>
</body>
</html>
EOF

# Write app config with environment variables
cat > /etc/app.env <<EOF
S3_BUCKET=${s3_bucket_name}
DB_HOST=${db_endpoint}
EOF

echo "=== Bootstrap complete ==="