# Prometheus & Grafana Infrastructure on AWS using Terraform

This Terraform project provisions an EC2 instance on AWS and installs Prometheus, Grafana, and the Prometheus Blackbox Exporter using a shell script. It is ideal for quickly deploying monitoring tools in a sandbox or demo environment.

---

## Terraform Files and Descriptions

### `c1-versions.tf`
```hcl
terraform {
  required_version = "~> 1.7.3"  # Ensures compatibility with Terraform 1.7.x

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"  # Use latest AWS provider v5 or above
    }
  }
}

provider "aws" {
  region = var.aws_region  # AWS region is passed as a variable
}
````

> Reference: [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest)

---

### `c2-ec2instance.tf`

```hcl
resource "aws_instance" "myec3" {
  ami           = "ami-0866a3c8686eaeeba"         # Ubuntu-based AMI
  instance_type = var.ec2_instance_type           # EC2 type as input
  user_data     = file("${path.module}/monitoring.sh")  # Run this script on startup
  key_name      = var.ec2_keypair                 # EC2 key pair name

  root_block_device {
    volume_size = 20                              # 20 GB volume
    volume_type = "gp2"
  }

  tags = {
    "Name" = "Prometheus-Grafana-Server"
  }
}
```

> Reference: [AWS EC2 Instance Resource](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance)

---

### `c3-outputs.tf`

```hcl
output "ec2_instance_ip" {
  description = "EC2 instance public IP"
  value       = aws_instance.myec3.public_ip
}

output "ec2_public_dns" {
  description = "EC2 public DNS"
  value       = aws_instance.myec3.public_dns
}
```

These outputs are helpful for accessing the monitoring tools after deployment.

---

### `c4-variables.tf`

```hcl
variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "ec2_instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.medium"
}

variable "ec2_keypair" {
  description = "EC2 key pair name"
  type        = string
  default     = "sample-key"
}
```

> Reference: [Terraform Variables Documentation](https://developer.hashicorp.com/terraform/language/values/variables)

---

## `monitoring.sh`

This is a shell script that installs Prometheus, Grafana, and Blackbox Exporter on your EC2 instance at boot.

```bash
#!/bin/bash

# Update packages
sudo apt update

# Install Prometheus
wget https://github.com/prometheus/prometheus/releases/download/v2.53.2/prometheus-2.53.2.linux-amd64.tar.gz
tar -xvf prometheus-2.53.2.linux-amd64.tar.gz
rm prometheus-2.53.2.linux-amd64.tar.gz
cd prometheus-2.53.2.linux-amd64/
./prometheus &

# Install Grafana
sudo apt-get install -y apt-transport-https software-properties-common wget
sudo mkdir -p /etc/apt/keyrings/
wget -q -O - https://apt.grafana.com/gpg.key | gpg --dearmor | sudo tee /etc/apt/keyrings/grafana.gpg > /dev/null
echo "deb [signed-by=/etc/apt/keyrings/grafana.gpg] https://apt.grafana.com stable main" | sudo tee /etc/apt/sources.list.d/grafana.list
echo "deb [signed-by=/etc/apt/keyrings/grafana.gpg] https://apt.grafana.com beta main" | sudo tee /etc/apt/sources.list.d/grafana.list
sudo apt-get update
sudo apt-get install grafana -y
sudo /bin/systemctl start grafana-server

# Install Blackbox Exporter
wget https://github.com/prometheus/blackbox_exporter/releases/download/v0.25.0/blackbox_exporter-0.25.0.linux-amd64.tar.gz
tar -xvf blackbox_exporter-0.25.0.linux-amd64.tar.gz
rm blackbox_exporter-0.25.0.linux-amd64.tar.gz
cd blackbox_exporter-0.25.0.linux-amd64/
./blackbox_exporter &
```

> References:
>
> * [Prometheus Official Site](https://prometheus.io/docs/introduction/overview/)
> * [Grafana Documentation](https://grafana.com/docs/grafana/latest/)
> * [Blackbox Exporter](https://github.com/prometheus/blackbox_exporter)

---

## Access Instructions

After applying the Terraform configuration, access the services via:

* **Prometheus:** `http://<ec2_public_dns>:9090`
* **Grafana:** `http://<ec2_public_dns>:3000`
* **Blackbox Exporter:** `http://<ec2_public_dns>:9115/probe`

You can find the `ec2_public_dns` in the Terraform output after apply.

---

## Security Group Notes

Before accessing the monitoring tools, make sure the EC2 instance's security group allows inbound access on the following ports:

| Port | Purpose                 |
| ---- | ----------------------- |
| 22   | SSH (for server access) |
| 3000 | Grafana web UI          |
| 9090 | Prometheus web UI       |
| 9115 | Blackbox Exporter       |

**Important Security Notes:**

* For testing, you may allow access from `0.0.0.0/0`, but this is not secure.
* In production, restrict access to known IPs (e.g., your office or home IP).
* You can configure these rules using the AWS Console or via Terraform Security Group resources.

> Reference: [AWS Security Groups Documentation](https://docs.aws.amazon.com/vpc/latest/userguide/VPC_SecurityGroups.html)

---

## Prerequisites

* Terraform v1.7.3 or later
* AWS CLI installed and configured
* A valid AWS key pair created
* An AWS account with sufficient EC2 permissions

---

## Clean Up

To destroy all resources and avoid charges:

```bash
terraform destroy
```

---

