pushd /usr/share/tomcat
openssl genrsa -out ca.key 2048
openssl req \
    -new -x509 \
    -days 365 \
    -key ca.key \
    -subj "/C=UK/ST=Bristol/L=Bristol/O=HBSS/CN=HBSS Root CA" \
    -out ca.crt

openssl req \
    -newkey rsa:2048 \
    -nodes \
    -keyout server.key \
    -subj "/C=UK/ST=Bristol/L=Bristol/O=HBSS/CN=hbss.pntwre.com" \
    -out server.csr

openssl x509 \
    -req \
    -extfile <(printf "subjectAltName=DNS:hbss.pntwre.com,IP:51.142.101.64") \
    -days 365 \
    -in server.csr \
    -CA ca.crt \
    -CAkey ca.key \
    -CAcreateserial \
    -out server.crt

    openssl pkcs12 -export \
        -in server.crt \
        -inkey server.key \
        -out server.p12 \
        -name "server" \
        -passout pass:Secret.123

chmod +r sslserver.p12

popd


#certbox stuff
openssl pkcs12 -export -inkey privkey.pem -in chain.pem -CAfile letsencryptauthorityx1.pem -out cert.p12
openssl pkcs12 -export -in /etc/letsencrypt/live/hbss.pntwre.com/fullchain.pem -inkey /etc/letsencrypt/live/hbss.pntwre.com/privkey.pem -out server.p12 -name "server" -passout pass:Secret.123