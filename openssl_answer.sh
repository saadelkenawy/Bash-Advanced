#This script to automate the generation of a self-signed SSL certificate using OpenSSL
#!/bin/bash
#Task1: make sure openssl is installed
if ! command -v openssl &> /dev/null; then
    echo "OpenSSL is not installed. Please install it to proceed."
fi 
# ask user to download openssl
echo "kindly confirm with yes to download openssl"
read -p "Do you want to download OpenSSL? (yes/no): " response
if [[ "$response" == "yes" ]]; then
    echo "Downloading OpenSSL..."
    # check if the system is Centos or Rocky Linux or Redhat by grep the /etc/os-release file and show name
   if grep -q -i "centos" /etc/os-release; then
       echo "Detected CentOS."
        sudo yum install openssl -y
   elif grep -q -i "rocky" /etc/os-release; then
       echo "Detected Rocky Linux."
       sudo dnf install openssl -y
   elif grep -q -i "redhat" /etc/os-release; then
       echo "Detected Red Hat."
       sudo dnf install openssl -y
    elif grep -q -i "ubuntu" /etc/os-release; then
       echo "Detected Ubuntu."
       sudo apt-get install openssl -y
   else
       echo "Unsupported operating system."
   fi
# each value in openssl.cnf is defualt value need to ask user for input to change it 
# create a file openssl.cnf 
# Task 2: Get user input for certificate details with default values.
read -p "Country Name (2 letter code) [EG]: " countryName
countryName=${countryName:-EG}

read -p "State or Province Name [Cairo]: " stateOrProvinceName
stateOrProvinceName=${stateOrProvinceName:-Cairo}

read -p "Locality Name [Giza]: " localityName
localityName=${localityName:-Giza}

read -p "Organization Name [My Company]: " organizationName
organizationName=${organizationName:- IT-Solutions}

read -p "Organizational Unit Name [IT]: " organizationalUnitName
organizationalUnitName=${organizationalUnitName:-IT-Department}

read -p "Common Name (e.g., your server's FQDN) [server.mycompany.com]: " commonName
commonName=${commonName:-www.mgm.lc}

read -p "Email Address [admin@mycompany.com]: " emailAddress
emailAddress=${emailAddress:-saad_elkenawy@yahoo.com}


# How many DNS names you want to add?
   read -p "How many DNS names do you want to add? " dns_count
   if ! [[ "$dns_count" =~ ^[0-9]+$ ]] || [ "$dns_count" -le 0 ]; then
       echo "Invalid input. Please enter a positive integer."
       exit 1
   fi

   for ((i=1; i<=dns_count; i++)); do
       read -p "Enter DNS name $i: " dns_name
       echo "DNS.$i = $dns_name" >> openssl.cnf
   done

echo "Creating openssl.cnf file..."
# create a directory to store the openssl.cnf file
mkdir -p ~/openssl_config
cat <<EOL > ~/openssl_config/openssl.cnf
[req]
prompt = no
distinguished_name = req_distinguished_name
req_extensions = v3_req

[req_distinguished_name]
countryName = $countryName
stateOrProvinceName = $stateOrProvinceName
localityName = $localityName
organizationName = $organizationName
organizationalUnitName = $organizationalUnitName
commonName = $commonName
emailAddress = $emailAddress

[v3_req]
subjectAltName = @alt_names

[alt_names]
DNS.1 = $dns_name
EOL

# Creare the v3.ext file in the same directory
cat <<EOL > ~/openssl_config/v3.ext
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment, keyAgreement, keyCertSign
subjectAltName = DNS:mgn.lc, DNS:www.mgn.lc, DNS:www.cockpit.mgm.lc, DNS:cockpit.mgm.lc
EOL

echo "openssl.cnf file created successfully."
# generate private key
openssl genpkey  -out private.key -algorithm RSA 
echo "Private key generated successfully."

# gernerate CSR
openssl req -new -key private.key -out csr.pem -config openssl.cnf
echo "Certificate Signing Request (CSR) generated successfully."

#generate self-signed certificate
openssl x509 -req -in csr.pem -signkey private.key -out certificate.crt -days 3650 -sha256 -extfile v3.ext