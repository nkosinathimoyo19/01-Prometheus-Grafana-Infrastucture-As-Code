# Prometheus & Grafana Infrastructure on AWS using Terraform

This Terraform project provisions an EC2 instance on AWS and automatically installs Prometheus, Grafana, and Blackbox Exporter using a bootstrap script.

---

## Usage

### 1. Clone the repository
```bash
git clone https://github.com/nkosinathimoyo19/01-Prometheus-Grafana-Infrastucture-As-Code.git
cd 01-Prometheus-Grafana-Infrastucture-As-Code
````

### 2. Initialize Terraform

```bash
terraform init
```

### 3. Format and validate

```bash
terraform fmt
terraform validate
```

### 4. Plan infrastructure deployment

```bash
terraform plan
```

### 5. Apply the configuration

```bash
terraform apply
```

---

## Project Structure

| File                | Description                                                            |
| ------------------- | ---------------------------------------------------------------------- |
| `c1-versions.tf`    | Terraform version and AWS provider configuration                       |
| `c2-ec2instance.tf` | EC2 instance resource definition                                       |
| `c3-outputs.tf`     | Output values (EC2 public IP and DNS)                                  |
| `c4-variables.tf`   | Input variables for region, instance type, and key pair                |
| `monitoring.sh`     | User data script to install Prometheus, Grafana, and Blackbox Exporter |

---

## What Gets Deployed

* One EC2 instance (Ubuntu-based)

  * Instance type: Default `t2.medium`
  * Region: Default `us-east-1`
  * Volume size: 20GB
* Installed software:

  * Prometheus
  * Grafana
  * Blackbox Exporter

---

## Variables

| Variable Name       | Description               | Default        |
| ------------------- | ------------------------- | -------------- |
| `aws_region`        | AWS region to deploy into | `"us-east-1"`  |
| `ec2_instance_type` | EC2 instance type         | `"t2.medium"`  |
| `ec2_keypair`       | AWS EC2 key pair name     | `"sample-key"` |

### Example `terraform.tfvars`

```hcl
aws_region        = "us-east-1"
ec2_instance_type = "t2.micro"
ec2_keypair       = "your-key-name"
```

---

## Outputs

After applying the configuration, Terraform will display:

* EC2 Public IP
* EC2 Public DNS

You can use the DNS or IP to access:

* Prometheus: `http://<public_dns>:9090`
* Grafana: `http://<public_dns>:3000`
* Blackbox Exporter: `http://<public_dns>:9115/probe`

---

## Prerequisites

* Terraform CLI version >= 1.7.3
* AWS account with programmatic access
* AWS CLI installed and configured (`aws configure`)
* A valid EC2 key pair already created in the chosen region

---

## Clean Up

To destroy all resources created by this configuration:

```bash
terraform destroy
```

---

## Resources

* Terraform AWS Provider: [https://registry.terraform.io/providers/hashicorp/aws/latest/docs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
* Prometheus: [https://prometheus.io/docs/introduction/overview/](https://prometheus.io/docs/introduction/overview/)
* Grafana: [https://grafana.com/docs/](https://grafana.com/docs/)
* Blackbox Exporter: [https://github.com/prometheus/blackbox\_exporter](https://github.com/prometheus/blackbox_exporter)

---

