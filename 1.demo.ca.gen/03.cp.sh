#!/bin/sh

OUT_DIR=./out
CA_OUT_DIR=../_ca

KEY_FILE=ca.gluu.key
PEM_FILE=ca.gluu.pem

cp -f "$OUT_DIR"/"$KEY_FILE" "$CA_OUT_DIR"
cp -f "$OUT_DIR"/"$PEM_FILE" "$CA_OUT_DIR"
