
$ openssl genrsa -out ./rootca.key 4096

$ openssl req -new -sha256 -x509 -days 1826 -key rootca.key -out rootca.crt

-----
Enter pass phrase for rootca.key:
You are about to be asked to enter information that will be incorporated
into your certificate request.
What you are about to enter is what is called a Distinguished Name or a DN.
There are quite a few fields but you can leave some blank
For some fields there will be a default value,
If you enter '.', the field will be left blank.
-----
Country Name (2 letter code) [AU]:US
State or Province Name (full name) [Some-State]:TX
Locality Name (eg, city) []:Austin
Organization Name (eg, company) [Internet Widgits Pty Ltd]:Gluu, Inc.
Organizational Unit Name (eg, section) []:Gluu CA
Common Name (e.g. server FQDN or YOUR name) []:Gluu Root CA
Email Address []:
----------------------

$ touch ./root-ca.conf

-----

[ ca ]
default_ca = gluuca

[ crl_ext ]
issuerAltName=issuer:copy
authorityKeyIdentifier=keyid:always

[ gluuca ]
dir = ./
new_certs_dir = $dir
unique_subject = no
certificate = $dir/rootca.crt
database = $dir/certindex
private_key = $dir/rootca.key
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
keyUsage = critical,any
subjectKeyIdentifier = hash
authorityKeyIdentifier = keyid:always,issuer
keyUsage = digitalSignature,cRLSign,keyCertSign
extendedKeyUsage = serverAuth
crlDistributionPoints = @crl_section
subjectAltName  = @alt_names
authorityInfoAccess = @ocsp_section

[alt_names]
DNS.0 = Gluu Intermidiate CA 1
DNS.1 = Gluu CA Intermidiate 1

[crl_section]
URI.0 = http://pki.gluu.org/GluuRoot.crl
URI.1 = http://pki.backup.com/GluuRoot.crl

[ocsp_section]
caIssuers;URI.0 = http://pki.gluu.org/GluuRoot.crt
caIssuers;URI.1 = http://pki.backup.com/GluuRoot.crt
OCSP;URI.0 = http://pki.gluu.org/ocsp/
OCSP;URI.1 = http://pki.backup.com/ocsp/

----------------------
$ touch certindex
$ echo 1000 > certserial
$ echo 1000 > crlnumber
----------------------
--------------------------------------------------------------------------------------------

$ openssl genrsa -out ./intermediate1.key 4096

$ openssl req -new -sha256 -key intermediate1.key -out intermediate1.csr

-----
You are about to be asked to enter information that will be incorporated
into your certificate request.
What you are about to enter is what is called a Distinguished Name or a DN.
There are quite a few fields but you can leave some blank
For some fields there will be a default value,
If you enter '.', the field will be left blank.
-----
Country Name (2 letter code) [AU]:US
State or Province Name (full name) [Some-State]:TX
Locality Name (eg, city) []:Austin
Organization Name (eg, company) [Internet Widgits Pty Ltd]:Gluu, Inc.
Organizational Unit Name (eg, section) []:Gluu CA
Common Name (e.g. server FQDN or YOUR name) []:Gluu Intermediate CA
Email Address []:
-----

challenge password:
    Gluu_1234567890$

--------------------------------------------------------------------------------------------

$ openssl ca -batch -config root-ca.conf -notext -in intermediate1.csr -out intermediate1.crt

$ openssl ca -config root-ca.conf -gencrl -keyfile rootca.key -cert rootca.crt -out rootca.crl.pem

$ openssl crl -inform PEM -in rootca.crl.pem -outform DER -out rootca.crl

$ mkdir intermediate1
$ cd ./intermediate1

$ mv ../intermediate1.* ./

$ touch certindex
$ echo 1000 > certserial
$ echo 1000 > crlnumber

----------------------

$ touch ./intermediate-ca.conf

-----

[ ca ]
default_ca = gluuca

[ crl_ext ]
issuerAltName=issuer:copy
authorityKeyIdentifier=keyid:always

[ gluuca ]
dir = ./
new_certs_dir = $dir
unique_subject = no
certificate = $dir/intermediate1.crt
database = $dir/certindex
private_key = $dir/intermediate1.key
serial = $dir/certserial
default_days = 365
default_md = sha1
policy = gluuca_policy
x509_extensions = gluuca_extensions
crlnumber = $dir/crlnumber
default_crl_days = 365

[ gluuca_policy ]
commonName = supplied
stateOrProvinceName = supplied
countryName = optional
emailAddress = optional
organizationName = supplied
organizationalUnitName = optional

[ gluuca_extensions ]
basicConstraints = critical,CA:FALSE
keyUsage = critical,any
subjectKeyIdentifier = hash
authorityKeyIdentifier = keyid:always,issuer
keyUsage = digitalSignature, nonRepudiation, keyEncipherment
extendedKeyUsage = clientAuth
crlDistributionPoints = @crl_section
subjectAltName  = @alt_names
authorityInfoAccess = @ocsp_section

[alt_names]
DNS.0 = example.com
DNS.1 = example.org

[crl_section]
URI.0 = http://pki.gluu.org/GluuIntermidiate1.crl
URI.1 = http://pki.backup.com/GluuIntermidiate1.crl

[ocsp_section]
caIssuers;URI.0 = http://pki.gluu.org/GluuIntermediate1.crt
caIssuers;URI.1 = http://pki.backup.com/GluuIntermediate1.crt
OCSP;URI.0 = http://pki.gluu.org/ocsp/
OCSP;URI.1 = http://pki.backup.com/ocsp/

----------------------

$ openssl ca -config intermediate-ca.conf -gencrl -keyfile intermediate1.key -cert intermediate1.crt -out intermediate1.crl.pem

$ openssl crl -inform PEM -in intermediate1.crl.pem -outform DER -out intermediate1.crl

revoke (optional usage):
$ openssl ca -config ../root-ca.conf -revoke intermediate1.crt -keyfile ../rootca.key -cert ../rootca.crt

$ mkdir enduser-certs

$ openssl genrsa -out enduser-certs/user-gluu.org.key 4096

$ openssl req -new -sha256 -key enduser-certs/user-gluu.org.key -out enduser-certs/user-gluu.org.csr

-----

You are about to be asked to enter information that will be incorporated
into your certificate request.
What you are about to enter is what is called a Distinguished Name or a DN.
There are quite a few fields but you can leave some blank
For some fields there will be a default value,
If you enter '.', the field will be left blank.
-----
Country Name (2 letter code) [XX]:US
State or Province Name (full name) []:TX
Locality Name (eg, city) [Default City]:Austin
Organization Name (eg, company) [Default Company Ltd]:Gluu, Inc
Organizational Unit Name (eg, section) []:Gluu User
Common Name (eg, your name or your server's hostname) []:Local Gluu User
Email Address []:

Please enter the following 'extra' attributes
to be sent with your certificate request
A challenge password []:
An optional company name []:

----------------------

$ openssl ca -batch -config intermediate-ca.conf -notext -in enduser-certs/user-gluu.org.csr -out enduser-certs/user-gluu.org.crt

$ openssl ca -config intermediate-ca.conf -gencrl -keyfile enduser-certs/user-gluu.org.key -cert enduser-certs/user-gluu.org.crt -out enduser-certs/user-gluu.org.crl.pem

$ openssl crl -inform PEM -in intermediate1.crl.pem -outform DER -out intermediate1.crl

revoke (optional usage):
$ openssl ca -config intermediate-ca.conf -revoke enduser-certs/user-gluu.org.crt -keyfile intermediate1.key -cert intermediate1.crt

$ cat ../rootca.crt intermediate1.crt > enduser-certs/user-gluu.org.chain

$ openssl verify -CAfile enduser-certs/user-gluu.org.chain enduser-certs/user-gluu.org.crt

----------------------

-    $ cat ../rootca.crl.pem intermediate1.crl.pem > enduser-certs/user-gluu.org.crl.chain

    $ cat ../rootca.crt intermediate1.crt intermediate1.crl.pem enduser-certs/user-gluu.org.crl.pem > enduser-certs/user-gluu.org.crl.chain

    $ cat ../rootca.crt intermediate1.crt intermediate1.crl.pem > enduser-certs/user-gluu.org.crl.chain
    
    $ cat ../rootca.crt intermediate1.crt ../rootca.crl.pem intermediate1.crl.pem > enduser-certs/user-gluu.org.crl.chain
    
-    $ cat ../rootca.crt intermediate1.crt ../rootca.crl.pem > enduser-certs/user-gluu.org.crl.chain

-    $ cat ../rootca.crt intermediate1.crt ../rootca.crl.pem > enduser-certs/user-gluu.org.crl.chain
    
----------------------    

$ openssl verify -crl_check -CAfile enduser-certs/user-gluu.org.crl.chain enduser-certs/user-gluu.org.crt

$ openssl pkcs12 -export -out enduser-certs/user-gluu.org.p12 -inkey enduser-certs/user-gluu.org.key -in enduser-certs/user-gluu.org.crt -certfile enduser-certs/user-gluu.org.chain

--------------------------------------------------------------------------------------------
