# Bash-Advanced
This Repo Contains a Script to Generate advanced SSL/TLS Certificate on Linux System (RedHat , Centos , Rocky)
Advanced SSL/TLS Certificate Generator for Linux
A powerful and easy-to-use bash script for generating advanced, self-signed SSL/TLS certificates on RHEL-based systems. This tool simplifies the process of creating certificates with Subject Alternative Names (SANs), making it ideal for development environments, internal services, and testing purposes.

Key Features
Subject Alternative Names (SAN): Generate a single certificate that is valid for multiple hostnames, domain names, and IP addresses.

Customizable: Easily configure key length, expiration date, and certificate details.

Automated: Runs non-interactively, making it perfect for use in automated provisioning scripts.

Secure Defaults: Uses strong, modern cryptographic standards by default.

Self-Contained: Relies only on openssl, which is pre-installed on most Linux systems.

Supported Operating Systems
This script is designed and tested for modern RHEL-based distributions:

Red Hat Enterprise Linux (RHEL) 8, 9

CentOS Stream 8, 9

Rocky Linux 8, 9

AlmaLinux 8, 9

Prerequisites
Ensure the openssl package is installed on your system. It is included by default in most installations.

sudo dnf install openssl -y

Usage
Follow these steps to generate a certificate.

1. Clone the Repository

git clone https://github.com/your-username/your-repo-name.git
cd your-repo-name

2. Make the Script Executable

chmod +x generate_cert.sh

3. Run the Script

Execute the script with the required parameters. The script will generate a private key (.key) and a certificate (.crt) file.

./generate_cert.sh [OPTIONS]

Options:

Flag

Description

Required

Example

-d

The primary domain name (Common Name) for the certificate.

Yes

-d myapp.local

-o

The full output path and filename for the generated files (without extension).

Yes

-o /etc/pki/tls/certs/myapp

-a

A comma-separated list of alternative hostnames and/or IP addresses (SANs).

No

-a www.myapp.local,192.168.1.100

-e

The expiration time for the certificate in days.

No (Default: 365)

-e 730

-k

The private key length in bits.

No (Default: 2048)

-k 4096

Example
To generate a 2-year certificate for test.example.com which is also valid for www.test.example.com and the IP address 10.0.0.5, and save the files as test.example.com.key and test.example.com.crt in the current directory:

./generate_cert.sh \
  -d test.example.com \
  -a www.test.example.com,10.0.0.5 \
  -e 730 \
  -o ./test.example.com

This will create the following files:

test.example.com.key (Your private key)

test.example.com.crt (Your public certificate)