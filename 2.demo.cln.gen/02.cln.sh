#!/bin/sh

OUT_DIR=./out
CONF_FILE=./cnfs/openssl.cln.cnf

KEY_FILE=cln.gluu.key
CSR_FILE=cln.gluu.csr

openssl genrsa -out "$OUT_DIR"/"$KEY_FILE" 2048

echo '---------------------------------------------------------------------'
echo 'CLN Key File'
echo '---------------------------------------------------------------------'
openssl rsa -noout -text -in "$OUT_DIR"/"$KEY_FILE"
echo '---------------------------------------------------------------------'

openssl req -config "$CONF_FILE" -new -nodes -key "$OUT_DIR"/"$KEY_FILE" -out "$OUT_DIR"/"$CSR_FILE"

echo '---------------------------------------------------------------------'
echo 'CLN Certificate Request File'
echo '---------------------------------------------------------------------'
openssl req -noout -text -in "$OUT_DIR"/"$CSR_FILE"

openssl req -text -noout -verify -in "$OUT_DIR"/"$CSR_FILE"

