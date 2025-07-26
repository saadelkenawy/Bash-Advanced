# Text Colors
RED='\e[31m'
GREEN='\e[32m'
YELLOW='\e[33m'
BLUE='\e[34m'
CYAN='\e[36m'
RESET='\e[0m' # No Color


#Phase 2 
read -p "Country Name (2 letter code) [EG]: " countryName
countryName=${countryName:-EG}
echo ""
echo ""
read -p "State or Province Name [Cairo]: " stateOrProvinceName
stateOrProvinceName=${stateOrProvinceName:-Cairo}
echo ""
echo ""
read -p "Locality Name [Giza]: " localityName
localityName=${localityName:-Giza}
echo ""
echo ""
read -p "Organization Name [My Company]: " organizationName
organizationName=${organizationName:- CA Certificate Authority Organization BY Saad Elkenawy }
echo ""
echo ""
read -p "Organizational Unit Name [IT]: " organizationalUnitName
organizationalUnitName=${organizationalUnitName:-CA Certificate Authority Unit BY Saad Elkenawy}
echo ""
echo ""
read -p "Common Name (e.g., your server's FQDN) [server.mycompany.com]: " commonName
commonName=${commonName:-CA Certificate Authority BY Saad Elkenawy}
echo ""
echo ""
read -p "Email Address [admin@mycompany.com]: " emailAddress
emailAddress=${emailAddress:-saad_elkenawy@yahoo.com}
echo ""
echo ""
# create a directory to store the openssl output files
echo "Creating output directory for OpenSSL files..."
echo ""
echo ""
output_dir=~/openssl_output
mkdir -p ${output_dir}
#Generate CA with PassPharse
# read from user a secure passphrase and save it in a variable name secure_passphrase
read -sp "Enter a secure passphrase for the CA private key: " secure_passphrase
# export the variable  
export secure_passphrase
openssl genrsa -aes256 -out ${output_dir}/ca-key.pem -passout env:secure_passphrase 4096
echo "CA private key generated successfully."
echo ""
echo ""
# Generate CA certificate for CA private key with 10 years validity
openssl req -x509 -new -key ${output_dir}/ca-key.pem  -sha256 -days 3650 -out ${output_dir}/ca.pem -passin env:secure_passphrase -subj "/C=$countryName/ST=$stateOrProvinceName/L=$localityName/O=$organizationName/OU=$organizationalUnitName/CN=$commonName/emailAddress=$emailAddress"
echo "CA certificate generated successfully."
echo ""
echo ""
