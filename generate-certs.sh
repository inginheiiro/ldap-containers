#!/bin/bash
# Create directories
mkdir -p certs
cd certs

# Generate CA private key and certificate
openssl genrsa -out ca.key 4096
openssl req -x509 -new -nodes -key ca.key -sha256 -days 1024 -out ca.crt \
  -subj "/C=US/ST=State/L=City/O=Example Corp/OU=IT/CN=Example Corp CA"

# Generate server private key
openssl genrsa -out server.key 2048

# Create server certificate signing request (CSR)
openssl req -new -key server.key -out server.csr \
  -subj "/C=US/ST=State/L=City/O=Example Corp/OU=IT/CN=openldap"

# Create server certificate configuration
cat > server.ext << EOF
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
subjectAltName = @alt_names

[alt_names]
DNS.1 = openldap
DNS.2 = ldap.corp.example.com
DNS.3 = localhost
IP.1 = 172.20.0.2
IP.2 = 127.0.0.1
EOF

# Generate server certificate
openssl x509 -req -in server.csr -CA ca.crt -CAkey ca.key -CAcreateserial \
  -out server.crt -days 365 -sha256 -extfile server.ext

# Set proper permissions
chmod 644 *.crt *.ext
chmod 600 *.key *.csr

# Clean up
rm server.csr server.ext ca.srl
cd ..
