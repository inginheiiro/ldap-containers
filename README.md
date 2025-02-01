# OpenLDAP TLS Testing Environment

This repository provides a complete OpenLDAP testing environment with TLS support and a pre-configured organizational structure. It's designed for testing LDAP/AD integration in development environments.

## Features

- OpenLDAP server with TLS/SSL support
- LDAP Account Manager web interface
- Pre-configured organizational structure
- Sample users and groups
- Self-signed certificates for LDAPS
- Docker-based deployment

## Prerequisites

- Linux operating system 
- Docker Engine installed
- Docker Compose installed
- OpenSSL for certificate generation

## Project Structure

```
.
├── README.md
├── docker-compose.yaml
├── generate-certs.sh
├── ldap.conf
└── ldifs/
    └── init.ldif
```

## Quick Start

1. Clone the repository:
```bash
git clone [repository-url]
cd openldap-tls-test
```

2. Generate SSL certificates:
```bash
chmod +x generate-certs.sh
./generate-certs.sh
```

3. Set proper permissions for certificates:
```bash
sudo chown -R 911:911 certs/
```

4. Start the containers:
```bash
docker-compose up -d
```

## Accessing the Environment

### LDAP Account Manager (Web Interface)
- URL: http://localhost:9999
- Login : admin
- Password: kps

### LDAP Connection Details
- LDAP URL: ldap://localhost:389
- LDAPS URL: ldaps://localhost:636
- Base DN: dc=corp,dc=example,dc=com
- Admin DN: cn=admin,dc=corp,dc=example,dc=com
- Admin Password: kps

## Organizational Structure

### Departments
- Operations
  - Infrastructure Team
  - Security Team
- Development
  - Frontend Team
  - Backend Team

### Sample Users

All users have password: `kps`

Infrastructure Team:
- John Smith (jsmith)
- Sarah Wilson (swilson)

Security Team:
- Emma Davis (edavis)
- Michael Brown (mbrown)

Frontend Team:
- Lisa Chen (lchen)
- David Miller (dmiller)

Backend Team:
- James Wilson (jwilson)
- Maria Garcia (mgarcia)

### Groups
- SysAdmins
- SecurityTeam
- FrontendDevs
- BackendDevs
- DevOpsTeam (cross-functional)
- ArchitectureTeam (cross-functional)

## Testing the Setup

### Test LDAPS Connection
```bash
ldapsearch -x -H ldaps://localhost:636 \
  -D "cn=admin,dc=corp,dc=example,dc=com" \
  -w kps \
  -b "dc=corp,dc=example,dc=com"
```

### Test User Authentication
```bash
ldapsearch -x -H ldaps://localhost:636 \
  -D "cn=John Smith,ou=Infrastructure,ou=Operations,dc=corp,dc=example,dc=com" \
  -w kps \
  -b "dc=corp,dc=example,dc=com"
```

## Troubleshooting

### Certificate Issues
If you experience TLS connection issues:
1. Verify certificates are generated correctly in `certs/` directory
2. Check certificate permissions (should be owned by UID 911)
3. Ensure certificates are mounted correctly in containers

### Connection Issues
If you can't connect to LDAP:
1. Check if containers are running: `docker-compose ps`
2. View container logs: `docker-compose logs`
3. Verify ports are accessible: `netstat -tuln | grep -E '389|636'`

## Maintenance

### View Logs
```bash
# View all logs
docker-compose logs

# Follow OpenLDAP logs
docker-compose logs -f openldap

# Follow LDAP Account Manager logs
docker-compose logs -f ldap-ui
```

### Restart Services
```bash
# Restart all services
docker-compose restart

# Restart specific service
docker-compose restart openldap
```

### Clean Up
To remove all containers and volumes:
```bash
docker-compose down -v
```

To remove only certificates:
```bash
rm -rf certs/
```

## Security Considerations

This setup is intended for development and testing purposes only. It includes:
- Self-signed certificates
- Default passwords
- Unencrypted password storage
- Disabled certificate verification

DO NOT USE THIS CONFIGURATION IN PRODUCTION!

## License

This project is licensed under the MIT License - see the LICENSE file for details.
