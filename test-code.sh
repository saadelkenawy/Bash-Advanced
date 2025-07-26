# Text Colors
RED='\e[31m'
GREEN='\e[32m'
YELLOW='\e[33m'
BLUE='\e[34m'
CYAN='\e[36m'
RESET='\e[0m' # No Color


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
read -p "$(echo -e ${BLUE} 'Common Name (e.g., your server's FQDN) [server.mycompany.com]: )"  commonName
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
# Generate a cert Key for your server 
openssl genrsa -out ${output_dir}/cert-key.pem 4096
echo -e "${GREEN}Server private key generated successfully.${RESET}"
echo ""
echo ""
# Generate a CSR for your server
openssl req -new -sha256 "/CN=S.M.S.K"  -key ${output_dir}/cert-key.pem -out ${output_dir}/cert.csr
echo -e "${GREEN}Certificate Signing Request (CSR) generated successfully.${RESET}"
echo ""
echo ""

#How many DNS names you want to add?
   read -p "How many DNS names do you want to add? " dns_count
   if ! [[ "$dns_count" =~ ^[0-9]+$ ]] || [ "$dns_count" -le 0 ]; then
       echo "Invalid input. Please enter a positive integer."
       exit 1
   fi

   for ((i=1; i<=dns_count; i++)); do
       read -p "Enter DNS name $i: " dns_name
       echo "DNS: $dns_name ," >> openssl.cnf
       count_i = $i
   done
#How many IP-Addrss you want to add?
   read -p "How many IP-Addrss do you want to add? " ip_count
   if ! [[ "$ip_count" =~ ^[0-9]+$ ]] || [ "$ip_count" -le 0 ]; then
       echo "Invalid input. Please enter a positive integer."
       exit 1
   fi

   for ((y=1; y<=ip_count; y++)); do
       read -p "Enter Ip-Address $y: " ip_address
       echo "DNS: $ip_address ," >> openssl.cnf
       count_y = $iy
   done
#cat <<EOL > ${output_dir}/v3.ext
cat <<EOL > v3.ext
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment, keyAgreement, keyCertSign
subjectAltName = 
EOL
# Apply Clean On v3.ext file
sed -i '$s/[.,]$//' v3.ext
echo -e "${GREEN}v3.ext file created successfully.${RESET}"
echo ""
echo "Alternative Names created successfully."