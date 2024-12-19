#!/usr/bin/env bash
#
# Copyright 2020 Liu Hongyu (eliuhy@163.com)
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
set -e

DOMAIN="$1"
DAYS="$2"
WORK_DIR="$(mktemp -d)"

if [ -z "$DOMAIN" ]; then
  echo "Domain name needed."
  exit 1
fi

if [ -z "$DAYS" ]; then
  echo "DAYS needed."
  exit 1
fi

echo "Temporary working dir is $WORK_DIR "
echo "Gernerating cert for $DOMAIN ..."

#
# Fix the following error:
# --------------------------
# Cannot write random bytes:
# 139695180550592:error:24070079:random number generator:RAND_write_file:Cannot open file:../crypto/rand/randfile.c:213:Filename=/home/eliu/.rnd
#
[ -f $HOME/.rnd ] || dd if=/dev/urandom of=$HOME/.rnd bs=256 count=1

openssl genrsa -out $WORK_DIR/ca.key 4096

openssl req -x509 -new -nodes -sha512 -days $DAYS \
  -subj "/C=CN/ST=Beijing/L=Beijing/O=example/OU=Personal/CN=$DOMAIN" \
  -key $WORK_DIR/ca.key \
  -out $WORK_DIR/ca.crt

openssl genrsa -out $WORK_DIR/server.key 4096

openssl req -sha512 -new \
  -subj "/C=CN/ST=Beijing/L=Beijing/O=example/OU=Personal/CN=$DOMAIN" \
  -key $WORK_DIR/server.key \
  -out $WORK_DIR/server.csr

cat > $WORK_DIR/v3.ext <<-EOF
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
extendedKeyUsage = serverAuth
subjectAltName = @alt_names

[alt_names]
DNS.1=$DOMAIN
DNS.2=*.$DOMAIN
EOF

openssl x509 -req -sha512 -days $DAYS \
  -extfile $WORK_DIR/v3.ext \
  -CA $WORK_DIR/ca.crt -CAkey $WORK_DIR/ca.key -CAcreateserial \
  -in $WORK_DIR/server.csr \
  -out $WORK_DIR/server.crt

openssl x509 -inform PEM -in $WORK_DIR/server.crt -out $WORK_DIR/$DOMAIN.cert

mkdir -p ./$DOMAIN
cp $WORK_DIR/server.key $WORK_DIR/server.crt ./$DOMAIN

