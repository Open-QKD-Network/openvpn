#!/bin/sh

set -x
autoreconf -i -f -v
./configure --prefix=/usr/local/openvpn --enable-debug OPENSSL_CFLAGS="-I/home/b43s/qkd-work/openssl-install/openssl/include" OPENSSL_LIBS="-L/home/b43s/qkd-work/openssl-install/openssl/lib -Wl,-rpath=/usr/local/openvpn/lib  -lssl -lcrypto -lopenqkd -lcurl -ljson-c"
make clean
make
make DESTDIR=/home/b43s/qkd-work/stage-openqkd install
