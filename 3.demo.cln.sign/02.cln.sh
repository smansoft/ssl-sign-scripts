#!/bin/sh

OUT_DIR=./out
CA_IN_DIR=../_ca
CLN_IN_DIR=../_in

CONF_FILE=./cnfs/openssl.cln.cnf

CSR_FILE=cln.gluu.csr
CERT_FILE=cln.gluu.cert

CA_KEY_FILE=ca.gluu.key
CA_PEM_FILE=ca.gluu.pem

SIGN_DAYS=1825

openssl ca -batch -config "$CONF_FILE" -days "$SIGN_DAYS" -keyfile "$CA_IN_DIR"/"$CA_KEY_FILE" -cert "$CA_IN_DIR"/"$CA_PEM_FILE" -in "$CLN_IN_DIR"/"$CSR_FILE" -out "$OUT_DIR"/"$CERT_FILE"

echo '---------------------------------------------------------------------'
echo 'CLN Certificate'
echo '---------------------------------------------------------------------'
openssl x509 -noout -text -in "$OUT_DIR"/"$CERT_FILE"
echo '---------------------------------------------------------------------'

