#!/bin/sh

OUT_DIR=./out

OUT_CLN_DIR=../_in

CLN_KEY_FILE=cln.gluu.key
CLN_CSR_FILE=cln.gluu.csr

cp -f 	"$OUT_DIR"/"$CLN_KEY_FILE"  	"$OUT_CLN_DIR"
cp -f 	"$OUT_DIR"/"$CLN_CSR_FILE"  	"$OUT_CLN_DIR"
