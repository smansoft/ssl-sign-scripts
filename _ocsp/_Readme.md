
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
OU                     = Gluu CA ECDSA
CN                     = Gluu.CA.ECDSA
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
basicConstraints = critical,CA:TRUE,pathlen:1
subjectKeyIdentifier = hash
authorityKeyIdentifier = keyid,issuer
keyUsage = digitalSignature,nonRepudiation,keyEncipherment,dataEncipherment,keyAgreement,keyCertSign,cRLSign
extendedKeyUsage = clientAuth,serverAuth
crlDistributionPoints = @crl_section
subjectAltName  = @alt_names
authorityInfoAccess = @ocsp_section

[ v3_req ]
basicConstraints = critical,CA:TRUE,pathlen:1
keyUsage = digitalSignature,nonRepudiation,keyEncipherment,dataEncipherment,keyAgreement,keyCertSign,cRLSign

[ v3_ca ]
subjectKeyIdentifier=hash
basicConstraints = critical,CA:TRUE,pathlen:1
authorityKeyIdentifier=keyid,issuer

[ alt_names ]
DNS.0 = Gluu Root ECDSA CA
DNS.1 = Gluu Root CA ECDSA

[ crl_section ]
URI.0 = http://pki.gluu.org/GluuRoot.crl
URI.1 = http://pki.backup.com/GluuRoot.crl

[ ocsp_section ]
caIssuers;URI.0 = http://pki.gluu.org/GluuRoot.crt
caIssuers;URI.1 = http://pki.backup.com/GluuRoot.crt
OCSP;URI.0 = http://pki.gluu.org/ocsp/
OCSP;URI.1 = http://pki.backup.com/ocsp/

-----------------------------------------------------------------

# $ openssl genrsa -out ./rootca.key 4096

# secp384r1 : NIST/SECG curve over a 384 bit prime field
# secp521r1 : NIST/SECG curve over a 521 bit prime field
# prime256v1: X9.62/SECG curve over a 256 bit prime field

$ openssl ecparam -name secp384r1 -genkey -noout -out ./rootca.key

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

$ touch ./intermediate-ca.conf

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
OU                     = Gluu Intermediate ECDSA
CN                     = Gluu.Intermediate.ECDSA
emailAddress           = support@gluu.org

[ req_attributes ]

[ ca ]
default_ca = gluuca

[ crl_ext ]
issuerAltName=issuer:copy
authorityKeyIdentifier=keyid

[ gluuca ]
dir = ./
new_certs_dir = $dir
unique_subject = no
certificate = $dir/intermediate1.crt
database = $dir/certindex
private_key = $dir/intermediate1.key
serial = $dir/certserial
default_days = 730
default_md = sha1
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
keyUsage = digitalSignature,nonRepudiation,keyEncipherment,dataEncipherment,keyAgreement,keyCertSign,cRLSign
authorityKeyIdentifier=keyid,issuer

[ v3_intermediate_ca ]
subjectKeyIdentifier=hash
basicConstraints = critical,CA:TRUE,pathlen:0
keyUsage = digitalSignature,nonRepudiation,keyEncipherment,dataEncipherment,keyAgreement,keyCertSign,cRLSign
authorityKeyIdentifier=keyid,issuer

[ alt_names ]
DNS.0 = Gluu Intermediate ECDSA CA
DNS.1 = Gluu Intermediate CA ECDSA

[ crl_section ]
URI.0 = http://pki.gluu.org/GluuIntermidiate1.crl
URI.1 = http://pki.backup.com/GluuIntermidiate1.crl

[ ocsp_section ]
caIssuers;URI.0 = http://pki.gluu.org/GluuIntermediate1.crt
caIssuers;URI.1 = http://pki.backup.com/GluuIntermediate1.crt
OCSP;URI.0 = http://pki.gluu.org/ocsp/
OCSP;URI.1 = http://pki.backup.com/ocsp/

-----------------------------------------------------------------

# $ openssl genrsa -out ./intermediate1.key 4096

# secp384r1 : NIST/SECG curve over a 384 bit prime field
# secp521r1 : NIST/SECG curve over a 521 bit prime field
# prime256v1: X9.62/SECG curve over a 256 bit prime field

$ openssl ecparam -name secp384r1 -genkey -noout -out ./intermediate1.key

$ openssl pkey -inform PEM -in ./intermediate1.key -text -noout

$ openssl req -config ./intermediate-ca.conf -new -sha256 -key intermediate1.key -out intermediate1.csr

$ openssl req -in ./intermediate1.csr -text -noout

$ openssl ca -batch -config ./intermediate-ca.conf -days 1826 -notext -keyfile ./rootca.key -cert ./rootca.crt -in ./intermediate1.csr -out ./intermediate1.crt

$ openssl x509 -in ./intermediate1.crt -text

-----------------------------------------------------------------

$ touch ./user-gluu.org.conf 

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
OU                     = Gluu Client ECDSA
CN                     = Gluu.Cln.ECDSA
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

[ alt_names ]
DNS.0 = Gluu ECDSA Client
DNS.1 = Gluu Client ECDSA

[ crl_section ]
URI.0 = http://pki.gluu.org/GluuClient.crl
URI.1 = http://pki.backup.com/GluuClient.crl

[ ocsp_section ]
caIssuers;URI.0 = http://pki.gluu.org/GluuClient.crt
caIssuers;URI.1 = http://pki.backup.com/GluuClient.crt
OCSP;URI.0 = http://pki.gluu.org/ocsp/
OCSP;URI.1 = http://pki.backup.com/ocsp/

-----------------------------------------------------------------

# $ openssl genrsa -out ./user-gluu.org.key 4096

# secp384r1 : NIST/SECG curve over a 384 bit prime field
# secp521r1 : NIST/SECG curve over a 521 bit prime field
# prime256v1: X9.62/SECG curve over a 256 bit prime field

$ openssl ecparam -name secp384r1 -genkey -noout -out ./user-gluu.org.key

$ openssl pkey -inform PEM -in ./user-gluu.org.key -text -noout

$ openssl req -config ./user-gluu.org.conf -new -sha256 -key ./user-gluu.org.key -out ./user-gluu.org.csr

$ openssl req -in ./user-gluu.org.csr -text -noout

$ openssl ca -batch -config ./user-gluu.org.conf -days 1826 -notext -keyfile ./intermediate1.key -cert ./intermediate1.crt -in ./user-gluu.org.csr -out ./user-gluu.org.crt

$ openssl x509 -in ./user-gluu.org.crt -text

$ cat ./rootca.crt ./intermediate1.crt > ./user-gluu.org.chain

$ openssl pkcs12 -export -out ./user-gluu.org.p12 -inkey ./user-gluu.org.key -in ./user-gluu.org.crt -certfile ./user-gluu.org.chain

-----------------------------------------------------------------

# $ openssl genrsa -out ./ocsp.key 4096

# secp384r1 : NIST/SECG curve over a 384 bit prime field
# secp521r1 : NIST/SECG curve over a 521 bit prime field
# prime256v1: X9.62/SECG curve over a 256 bit prime field

$ openssl ecparam -name secp384r1 -genkey -noout -out ./ocsp.key

$ openssl pkey -inform PEM -in ./ocsp.key -text -noout

$ openssl req -config ./ocsp.conf -new -sha256 -key ./ocsp.key -out ./ocsp.csr

$ openssl req -in ./ocsp.csr -text -noout

$ openssl ca -batch -config ./ocsp.conf -days 1826 -notext -keyfile ./intermediate1.key -cert ./intermediate1.crt -in ./ocsp.csr -out ./ocsp.crt

$ openssl x509 -in ./ocsp.crt -text

$ cat ./rootca.crt ./intermediate1.crt > ./ocsp.chain

-----------------------------------------------------------------

openssl ocsp -index ./certindex -port 8080 -rsigner ./ocsp.crt -rkey ./ocsp.key -CA ./ocsp.chain -text -out log.txt
                                                                                                                   
-----------------------------------------------------------------
