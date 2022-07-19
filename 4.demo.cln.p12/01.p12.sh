#!/bin/sh

CLN_IN_DIR=../_in
CLN_OUT_DIR=../_out

KEY_FILE=cln.gluu.key
CSR_FILE=cln.gluu.csr
CERT_FILE=cln.gluu.cert
CERT12_FILE=cln.gluu.p12

P12_PASSWORD='1234567890$'

openssl pkcs12 -export -in "$CLN_OUT_DIR"/"$CERT_FILE" -inkey "$CLN_IN_DIR"/"$KEY_FILE" -passout pass:"$P12_PASSWORD" -out "$CLN_OUT_DIR"/"$CERT12_FILE"

