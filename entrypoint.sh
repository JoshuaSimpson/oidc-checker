#!/bin/bash
url=$1

# if url contains '.well-known/openid-configuration', curl the url and get jwks_uri
if [[ $url == *".well-known/openid-configuration"* ]]; then
  echo "url contains .well-known/openid-configuration"
  jwks_uri=$(curl -s $url | jq -r '.jwks_uri')
  host=$(echo $jwks_uri | awk -F/ '{print $3}')

  openssl s_client -servername $host -showcerts -connect $host:443 < /dev/null 2>/dev/null | sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' | sed "0,/-END CERTIFICATE-/d" > certificate.crt
  thumbprint=$(openssl x509 -in certificate.crt -fingerprint -noout | cut -f2 -d'=' | tr -d ':' | tr '[:upper:]' '[:lower:]')
  echo 'Thumbprint: ' $thumbprint
  exit 1
else 
  echo "url does not contain .well-known/openid-configuration"
  url=$(echo $url | awk -F/ '{print $3}')
  openssl s_client -servername $url -showcerts -connect $url:443 < /dev/null 2>/dev/null | sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' | sed "0,/-END CERTIFICATE-/d" > certificate.crt
  thumbprint=$(openssl x509 -in certificate.crt -fingerprint -noout | cut -f2 -d'=' | tr -d ':' | tr '[:upper:]' '[:lower:]')
  echo 'Thumbprint: ' $thumbprint
  exit 1
fi