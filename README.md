1. Overview

This note desribes how to checkout and build and run openvpn with openqkdnetwork/liboqs/openssl triple key exchange.

2. Checkout & build code

Assume the home directory is /home/b43s

2.1 mkdir qkd-test && cd qkd-test

2.2 checkout qkd-network

git clone https://github.com/Open-QKD-Network/qkd-net.git

cd qkd-net

git checkout disable-spring-auth

Please refer https://github.com/Open-QKD-Network for how to build & run openqkd-network

2.3 checkout liboqs

cd qkd-test

git clone https://github.com/Open-QKD-Network/liboqs.git

cd liboqs

git checkout openqkd

2.4 checkout openssl

cd ../

git clone https://github.com/Open-QKD-Network/openssl.git

cd openssl

git checkout openqkd

2.5 build liboqs

cd ../liboqs

mkdir build

cd build

cmake -GNinja -DCMAKE_INSTALL_PREFIX=../../openssl/oqs ..

ninja

ninja install

2.6 build openssl

cd ../../openssl

#Build openssl with shared library

./Configure shared linux-x86_64 --debug --prefix=/home/b43s/qkd-test/openssl-install/openssl --openssldir=/home/b43s/qkd-test/openssl-install/ssl -lm

make

make install

2.7 checkout openvpn

cd ../

git clone https://github.com/Open-QKD-Network/openvpn

cd openvpn

git checkout pqcrypto

./build-openqkd.sh

3. Run

3.1 Run qkd-network

3.1.1 cd ../qkd-net

3.1.2 cd kms

3.1.3 ./script/run

3.2 Run openvpn

#change to root
sudo -s

cd qkd-test

export LD_LIBRARY_PATH=/home/b43s/qkd-test/openssl-install/openssl/lib/

#make sure the openvpn use openssl in above directory

root@ASUS-B43S:~/qkd-test# ldd stage-openqkd/usr/local/openvpn/sbin/openvpn  | grep ssl
	libssl.so.1.1 => /home/b43s/qkd-test/openssl-install/openssl/lib/libssl.so.1.1 (0x00007fb356b70000)
	libcrypto.so.1.1 => /home/b43s/qkd-test/openssl-install/openssl/lib/libcrypto.so.1.1 (0x00007fb355b03000)

#make sure server.conf/client.conf use openquantumsafe/openqkd key exchange

tls-version-min 1.3
ecdh-curve p384_oqkd_saber

#On server machine
./stage-openqkd/usr/local/openvpn/sbin/openvpn --config ./openssl/openqkd/openvpn-config/server-config/server.conf 

#On client machine
./stage-openqkd/usr/local/openvpn/sbin/openvpn --config ./openssl/openqkd/openvpn-config/client-config/client.conf

