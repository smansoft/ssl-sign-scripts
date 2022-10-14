# ssl-sign-scripts

Scripts and Configuration files:

- **1.demo.ca.gen**       - configuration files and scripts for generation **Root CA**;
- **2.demo.cln.gen**      - configuration files and scripts for generation **client private key** and **client certificate request**;
- **3.demo.cln.sign**     - configuration files and scripts for signing the client certificate request by **Root CA key**;
- **4.demo.cln.p12**      - scripts for creating **pkcs12** file/container, that contains client private key and client certificate; 

Output of **Scripts and Configuration files** section: 

- **_ca**       - contains **Root CA** - **Private Key** and **Certificate** - after generating (using **1.demo.ca.gen**);
- **_in**       - contains **Client Private Key** and **Client Certificate Reques**;
- **_out**      - contains **Client Signed Certificate**, **Certificate Chain**, output **pkcs12** file/container; 

**_Readme.md** files, configuration files, generated private keys and certificates.
**_Readme.md** files contain suite of necessary commands and content of configuration files: 

- **_2_certs_tree.ecdsa**       - 2 Certs Tree: **Root CA** - **Client Cert**, using ECDSA (curve **secp384r1**) is used;
- **_2_certs_tree.rsa**         - 2 Certs Tree: **Root CA** - **Client Cert**, using RSA (key length **4096**) is used; 
- **_3_certs_tree.ecdsa**       - 3 Certs Tree: **Root CA** - **Intermediate CA** - **Client Cert**, using ECDSA (curve **secp384r1**) is used;
- **_3_certs_tree.rsa**         - 3 Certs Tree: **Root CA** - **Intermediate CA** - **Client Cert**, using RSA (key length **4096**) is used; 

**_Readme.md** files, configuration files, generated private keys and certificates, that used tuned **OCSP** section.
**_Readme.md** files contain suite of necessary commands and content of configuration files.
Also **OCSP** keys and certificates are generated and signed (for **OCSP** server): 

- **_ocsp._1_certs_tree.ecdsa**         - 1 Certs (Self-Signed Certs) Tree: **Root CA** - **Client Cert**, using ECDSA (curve **secp384r1**) is used;
- **_ocsp._2_certs_tree.ecdsa**         - 2 Certs Tree: **Root CA** - **Client Cert**, using ECDSA (curve **secp384r1**) is used;
- **_ocsp._3_certs_tree.ecdsa**         - 3 Certs Tree: **Root CA** - **Intermediate CA** - **Client Cert**, using ECDSA (curve **secp384r1**) is used; 

Additional configuration files, private keys and certificates, generated, using documentation from **cert** script of oxAuth: (**oxAuth/Server/integrations/cert/**): 

- **_oxAuth_cert.rsa**   - 3 Certs Tree: **Root CA** - **Intermediate CA** - **Client Cert**, generated, using documentation from **cert** script of oxAuth: (**oxAuth/Server/integrations/cert/**).
