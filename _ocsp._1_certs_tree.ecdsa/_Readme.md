
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
basicConstraints = critical,CA:TRUE,pathlen:0
subjectKeyIdentifier = hash
authorityKeyIdentifier = keyid,issuer
keyUsage = digitalSignature,nonRepudiation,keyEncipherment,dataEncipherment,keyAgreement,keyCertSign,cRLSign
extendedKeyUsage = clientAuth
subjectAltName  = @alt_names
authorityInfoAccess = @ocsp_section

[ v3_req ]
basicConstraints = critical,CA:TRUE,pathlen:0
keyUsage = digitalSignature,nonRepudiation,keyEncipherment,dataEncipherment,keyAgreement,keyCertSign,cRLSign

[ v3_ca ]
basicConstraints = critical,CA:TRUE,pathlen:0
subjectKeyIdentifier=hash
authorityKeyIdentifier=keyid,issuer

[ alt_names ]
DNS.0 = Gluu ECDSA Client
DNS.1 = Gluu Client ECDSA

[ ocsp_section ]
caIssuers;URI.0 = http://ocsp.smansoft.net/gluu.chain
OCSP;URI.0 = http://ocsp.smansoft.net:8080

-----------------------------------------------------------------

$ touch certindex
$ echo 1000 > certserial
$ echo 1000 > crlnumber

#$ openssl genrsa -out ./user-gluu.org.key 4096

# secp384r1 : NIST/SECG curve over a 384 bit prime field
# secp521r1 : NIST/SECG curve over a 521 bit prime field
# prime256v1: X9.62/SECG curve over a 256 bit prime field

$ openssl ecparam -name secp384r1 -genkey -noout -out ./user-gluu.org.key

$ openssl pkey -inform PEM -in ./user-gluu.org.key -text -noout

# $ openssl req -config ./user-gluu.org.conf -new -sha256 -set_serial 4000 -key ./user-gluu.org.key -out ./user-gluu.org.csr

# $ openssl ca -batch -selfsignh -config ./user-gluu.org.conf -days 1826 -notext -keyfile ./user-gluu.org.key -in ./user-gluu.org.csr -out ./user-gluu.org.crt

$ openssl req -config ./user-gluu.org.conf -new -sha256 -x509 -set_serial 4000 -days 1826 -key ./user-gluu.org.key -out ./user-gluu.org.crt

$ openssl x509 -in ./user-gluu.org.crt -text

$ openssl x509 -noout -serial -in ./user-gluu.org.crt -text

$ openssl x509 -noout -subject -in ./user-gluu.org.crt -text

$ openssl pkcs12 -export -out ./user-gluu.org.p12 -inkey ./user-gluu.org.key -in ./user-gluu.org.crt -certfile ./user-gluu.org.crt

$ cat ./user-gluu.org.crt > ./user-gluu.org.chain

-----------------------------------------------------------------

$ touch ./ocsp.conf

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
OU                     = Gluu OCSP ECDSA
CN                     = Gluu.OCSP.ECDSA
emailAddress           = ocsp@gluu.org

[ req_attributes ]

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
certificate = $dir/ocsp.crt
database = $dir/certindex
private_key = $dir/ocsp.key
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
extendedKeyUsage = clientAuth
subjectAltName  = @alt_names
authorityInfoAccess = @ocsp_section

[ v3_req ]
basicConstraints = critical,CA:TRUE,pathlen:0
keyUsage = digitalSignature,nonRepudiation,keyEncipherment,dataEncipherment,keyAgreement,keyCertSign,cRLSign

[ v3_ca ]
basicConstraints = critical,CA:TRUE,pathlen:0
subjectKeyIdentifier=hash
authorityKeyIdentifier=keyid,issuer

[ alt_names ]
DNS.0 = Gluu ECDSA OCSP
DNS.1 = Gluu OCSP ECDSA

[ ocsp_section ]
caIssuers;URI.0 = http://ocsp.smansoft.net/gluu.chain
OCSP;URI.0 = http://ocsp.smansoft.net:8080

-----------------------------------------------------------------

# $ openssl genrsa -out ./ocsp.key 4096

# secp384r1 : NIST/SECG curve over a 384 bit prime field
# secp521r1 : NIST/SECG curve over a 521 bit prime field
# prime256v1: X9.62/SECG curve over a 256 bit prime field

$ openssl ecparam -name secp384r1 -genkey -noout -out ./ocsp.key

$ openssl pkey -inform PEM -in ./ocsp.key -text -noout

# $ openssl req -config ./ocsp.conf -new -sha256 -set_serial 4000 -key ./ocsp.key -out ./ocsp.csr

# $ openssl ca -batch -selfsignh -config ./ocsp.conf -days 1826 -notext -keyfile ./ocsp.key -in ./user-gluu.org.csr -out ./user-gluu.org.crt

$ openssl req -config ./ocsp.conf -new -sha256 -x509 -set_serial 4000 -days 1826 -key ./ocsp.key -out ./ocsp.crt

$ openssl x509 -in ./ocsp.crt -text

$ openssl x509 -noout -serial -in ./ocsp.crt -text

$ openssl x509 -noout -subject -in ./ocsp.crt -text

$ openssl pkcs12 -export -out ./ocsp.p12 -inkey ./ocsp.key -in ./ocsp.crt -certfile ./ocsp.crt

$ cat ./ocsp.crt > ./ocsp.chain

-----------------------------------------------------------------

$ openssl ocsp -index ./certindex -port 8080 -rsigner ./ocsp.crt -rkey ./ocsp.key -CA ./ocsp.chain -text -out log.txt

$ openssl ocsp -index ./certindex -port 8080 -rsigner ./ocsp.crt -rkey ./ocsp.key -CA ./ocsp.chain -CAfile ./ocsp.chain -text -out log.txt

-----------------------------------------------------------------
