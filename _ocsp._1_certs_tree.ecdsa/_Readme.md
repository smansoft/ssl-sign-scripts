
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
