#!/bin/sh

OUT_DIR=./out
CONF_FILE=./cnfs/openssl.ca.cnf
KEY_FILE=./ca.gluu.key
PEM_FILE=./ca.gluu.pem

#openssl ecparam -name prime256v1 -genkey -noout -out "$OUT_DIR"/"$KEY_FILE"
openssl genrsa -out "$OUT_DIR"/"$KEY_FILE" 2048

echo '---------------------------------------------------------------------'
echo 'CA Key File'
echo '---------------------------------------------------------------------'
#openssl ec -noout -text -in "$OUT_DIR"/"$KEY_FILE"
openssl rsa -noout -text -in "$OUT_DIR"/"$KEY_FILE"
echo '---------------------------------------------------------------------'

openssl req -new -nodes -config "$CONF_FILE" -x509 -key "$OUT_DIR"/"$KEY_FILE" -days 1825 -out "$OUT_DIR"/"$PEM_FILE" -outform pem

echo '---------------------------------------------------------------------'
echo 'CA Certificate'
echo '---------------------------------------------------------------------'
openssl x509 -noout -text -in "$OUT_DIR"/"$PEM_FILE"
echo '---------------------------------------------------------------------'
