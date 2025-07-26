#This script to automate the generation of a self-signed SSL certificate using OpenSSL
#!/bin/bash
#Definitions of text colors for better readability
RED='\e[31m'
GREEN='\e[32m'
YELLOW='\e[33m'
BLUE='\e[34m'
CYAN='\e[36m'
RESET='\e[0m' # No Color

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

# echo "Creating openssl.cnf file..."
# # create a directory to store the openssl.cnf file
# mkdir -p ~/openssl_config
# cat <<EOL > ~/openssl_config/openssl.cnf
# [req]
# prompt = no
# distinguished_name = req_distinguished_name
# req_extensions = v3_req

# [req_distinguished_name]
# countryName = $countryName
# stateOrProvinceName = $stateOrProvinceName
# localityName = $localityName
# organizationName = $organizationName
# organizationalUnitName = $organizationalUnitName
# commonName = $commonName
# emailAddress = $emailAddress

# [v3_req]
# subjectAltName = @alt_names

# [alt_names]
# DNS.1 = $dns_name
# EOL

# Creare the v3.ext file in the same directory
cat <<EOL > ~/openssl_config/v3.ext
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment, keyAgreement, keyCertSign
subjectAltName = DNS:mgn.lc, DNS:www.mgn.lc, DNS:www.cockpit.mgm.lc, DNS:cockpit.mgm.lc
EOL

# echo "openssl.cnf file created successfully."
# # generate private key
# openssl genpkey  -out private.key -algorithm RSA 
# echo "Private key generated successfully."

# # gernerate CSR
# openssl req -new -key private.key -out csr.pem -config openssl.cnf
# echo "Certificate Signing Request (CSR) generated successfully."

# #generate self-signed certificate
# openssl x509 -req -in csr.pem -signkey private.key -out certificate.crt -days 3650 -sha256 -extfile v3.ext

#Phase 2 
read -p "$(echo -e ${BLUE} 'Country Name (2 letter code) [EG]: ' ${GREEN})" countryName
countryName=${countryName:-EG}
echo ""
echo ""
read -p "$(echo -e ${BLUE} 'State or Province Name [Cairo]: ' ${GREEN})" stateOrProvinceName
stateOrProvinceName=${stateOrProvinceName:-Cairo}
echo ""
echo ""
read -p "$(echo -e ${BLUE} 'Locality Name [Giza]: ' ${GREEN})" localityName
localityName=${localityName:-Giza}
echo ""
echo ""
read -p "$(echo -e ${BLUE} 'Organization Name [My Company]: ' ${GREEN})" organizationName
organizationName=${organizationName:- CA Certificate Authority Organization BY Saad Elkenawy }
echo ""
echo ""
read -p "$(echo -e ${BLUE} 'Organizational Unit Name [IT]: ' ${GREEN})" organizationalUnitName
organizationalUnitName=${organizationalUnitName:-CA Certificate Authority Unit BY Saad Elkenawy}
echo ""
echo ""
read -p "$(echo -e ${BLUE} 'Common Name (e.g., your server's FQDN) [server.mycompany.com]: ' ${GREEN})" commonName
commonName=${commonName:-CA Certificate Authority BY Saad Elkenawy}
echo ""
echo ""
read -p "$(echo -e ${BLUE} 'Email Address [admin@mycompany.com]: ' ${GREEN})" emailAddress
emailAddress=${emailAddress:-saad_elkenawy@yahoo.com}
echo ""
echo ""
# create a directory to store the openssl output files
echo -e "${YELLOW}Creating output directory for OpenSSL files...${RESET}"
echo ""
echo ""
output_dir=~/openssl_output
mkdir -p ${output_dir}
#Generate CA with PassPharse
# read from user a secure passphrase and save it in a variable name secure_passphrase
read -sp "$(echo -e ${RED} 'Enter a secure passphrase for the CA private key: ' ${GREEN})" secure_passphrase
# export the variable
export secure_passphrase
openssl genrsa -aes256 -out ${output_dir}/ca-key.pem -passout env:secure_passphrase 4096
echo -e "${GREEN}CA private key generated successfully.${RESET}"
echo ""
echo ""
# Generate CA certificate for CA private key with 10 years validity
openssl req -x509 -new -key ${output_dir}/ca-key.pem  -sha256 -days 3650 -out ${output_dir}/ca.pem -passin env:secure_passphrase -subj "/C=$countryName/ST=$stateOrProvinceName/L=$localityName/O=$organizationName/OU=$organizationalUnitName/CN=$commonName/emailAddress=$emailAddress"
echo -e "${GREEN}CA certificate generated successfully.${RESET}"
echo ""
echo ""