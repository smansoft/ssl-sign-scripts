
-----------------------------------------------------------------

$ touch ./root-ca.conf

-----------------------------------------------------------------

RANDFILE               = $ENV::HOME/.rnd

[ req ]

distinguished_name     = req_distinguished_name
attributes             = req_attributes
prompt                 = no

[ req_distinguished_name ]
 
C                      = US
ST                     = TX
L                      = Austin
O                      = Gluu, Inc
OU                     = Gluu CA RSA
CN                     = Gluu.CA.RSA
emailAddress           = support@gluu.org

[ req_attributes ]

[ ca ]
default_ca = gluuca

[ crl_ext ]
nsComment="OpenSSL Generated Certificate"
nsCertType=objCA,emailCA,sslCA

issuerAltName=issuer:copy
authorityKeyIdentifier=keyid
subjectKeyIdentifier=hash

[ gluuca ]
dir = ./
new_certs_dir = $dir
unique_subject = no
certificate = $dir/rootca.crt
database = $dir/certindex
private_key = $dir/rootca.key
serial = $dir/certserial
default_days = 730
default_md = sha384
policy = gluuca_policy
x509_extensions = gluuca_extensions
crlnumber = $dir/crlnumber
default_crl_days = 730

[ gluuca_policy ]
commonName = supplied
stateOrProvinceName = supplied
countryName = optional
emailAddress = optional
organizationName = supplied
organizationalUnitName = optional

[ gluuca_extensions ]
basicConstraints = critical,CA:TRUE,pathlen:0
subjectKeyIdentifier = hash
authorityKeyIdentifier = keyid,issuer
keyUsage = digitalSignature,nonRepudiation,keyEncipherment,dataEncipherment,keyAgreement,keyCertSign,cRLSign
extendedKeyUsage = clientAuth,serverAuth
crlDistributionPoints = @crl_section
subjectAltName  = @alt_names
authorityInfoAccess = @ocsp_section

[ v3_req ]
basicConstraints = critical,CA:TRUE,pathlen:0
keyUsage = digitalSignature,nonRepudiation,keyEncipherment,dataEncipherment,keyAgreement,keyCertSign,cRLSign

[ v3_ca ]
subjectKeyIdentifier=hash
basicConstraints = critical,CA:TRUE,pathlen:0
authorityKeyIdentifier=keyid,issuer

[alt_names]
DNS.0 = Gluu Root RSA CA
DNS.1 = Gluu Root CA RSA

[crl_section]
URI.0 = http://pki.gluu.org/GluuRoot.crl
URI.1 = http://pki.backup.com/GluuRoot.crl

[ocsp_section]
caIssuers;URI.0 = http://pki.gluu.org/GluuRoot.crt
caIssuers;URI.1 = http://pki.backup.com/GluuRoot.crt
OCSP;URI.0 = http://pki.gluu.org/ocsp/
OCSP;URI.1 = http://pki.backup.com/ocsp/

-----------------------------------------------------------------

$ openssl genrsa -out ./rootca.key 4096

$ openssl pkey -inform PEM -in ./rootca.key -text -noout

$ openssl req -config ./root-ca.conf -new -sha256 -x509 -days 1826 -key rootca.key -out rootca.crt
or
$ openssl req -config ./root-ca.conf -new -sha256 -x509 -days 1826 -text -key rootca.key -out rootca.crt

$ openssl x509 -in ./rootca.crt -text
    
-----------------------------------------------------------------

$ touch certindex
$ echo 1000 > certserial
$ echo 1000 > crlnumber

-----------------------------------------------------------------

$ openssl ca -config ./root-ca.conf -gencrl -keyfile rootca.key -cert rootca.crt -out rootca.crl.pem

-----------------------------------------------------------------

$ touch ./user-gluu.ogr.conf 

-----------------------------------------------------------------

RANDFILE               = $ENV::HOME/.rnd

[ req ]

default_keyfile        = cln.pem
distinguished_name     = req_distinguished_name
attributes             = req_attributes
prompt                 = no

[ req_distinguished_name ]
C                      = US
ST                     = Texas
L                      = Austin
O                      = Gluu, Inc
OU                     = Gluu Client RSA
CN                     = Gluu.Cln.RSA
emailAddress           = client@gluu.org

[req_attributes]

[ ca ]
default_ca = gluuca

[ crl_ext ]
nsComment="OpenSSL Generated Certificate"
nsCertType=client

issuerAltName=issuer:copy
authorityKeyIdentifier=keyid
subjectKeyIdentifier=hash

[ gluuca ]
dir = ./
new_certs_dir = $dir
unique_subject = no
certificate = $dir/user-gluu.org.crt
database = $dir/certindex
private_key = $dir/user-gluu.org.key
serial = $dir/certserial
default_days = 730
default_md = sha384
policy = gluuca_policy
x509_extensions = gluuca_extensions
crlnumber = $dir/crlnumber
default_crl_days = 730

[ gluuca_policy ]
commonName = supplied
stateOrProvinceName = supplied
countryName = optional
emailAddress = optional
organizationName = supplied
organizationalUnitName = optional

[ gluuca_extensions ]
basicConstraints = critical,CA:FALSE
subjectKeyIdentifier = hash
authorityKeyIdentifier = keyid,issuer
keyUsage = digitalSignature,nonRepudiation,keyEncipherment,dataEncipherment,keyAgreement,keyCertSign,cRLSign
extendedKeyUsage = clientAuth
crlDistributionPoints = @crl_section
subjectAltName  = @alt_names
authorityInfoAccess = @ocsp_section

[ v3_req ]
basicConstraints = critical,CA:FALSE
keyUsage = digitalSignature,nonRepudiation,keyEncipherment,dataEncipherment,keyAgreement,keyCertSign,cRLSign

[ v3_ca ]
subjectKeyIdentifier=hash
authorityKeyIdentifier=keyid,issuer
basicConstraints = critical,CA:FALSE

[alt_names]
DNS.0 = Gluu RSA Client
DNS.1 = Gluu Client RSA

[crl_section]
URI.0 = http://pki.gluu.org/GluuClient.crl
URI.1 = http://pki.backup.com/GluuClient.crl

[ocsp_section]
caIssuers;URI.0 = http://pki.gluu.org/GluuClient.crt
caIssuers;URI.1 = http://pki.backup.com/GluuClient.crt
OCSP;URI.0 = http://pki.gluu.org/ocsp/
OCSP;URI.1 = http://pki.backup.com/ocsp/

-----------------------------------------------------------------

$ openssl genrsa -out ./user-gluu.org.key 4096

$ openssl pkey -inform PEM -in ./user-gluu.org.key -text -noout

$ openssl req -config ./user-gluu.org.conf -new -sha256 -key ./user-gluu.org.key -out ./user-gluu.org.csr

$ openssl req -in ./user-gluu.org.csr -text -noout

$ openssl ca -batch -config ./user-gluu.org.conf -days 1826 -notext -keyfile ./rootca.key -cert ./rootca.crt -in ./user-gluu.org.csr -out ./user-gluu.org.crt

$ openssl x509 -in ./user-gluu.org.crt -text

$ cat ./rootca.crt > ./user-gluu.org.chain

$ openssl pkcs12 -export -out ./user-gluu.org.p12 -inkey ./user-gluu.org.key -in ./user-gluu.org.crt -certfile ./user-gluu.org.chain

-----------------------------------------------------------------
