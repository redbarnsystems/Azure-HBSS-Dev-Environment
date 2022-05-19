yum -y update
yum -y install unzip
mkdir guacamole
pushd guacamole
wget -O guacamole-1.4.0.war https://apache.org/dyn/closer.lua/guacamole/1.4.0/binary/guacamole-1.4.0.war?action=download
wget -O guacamole-server-1.4.0.tar.gz https://apache.org/dyn/closer.lua/guacamole/1.4.0/source/guacamole-server-1.4.0.tar.gz?action=download
yum -y install epel-release
yum -y localinstall --nogpgcheck https://download1.rpmfusion.org/free/el/rpmfusion-free-release-7.noarch.rpm
yum -y install cairo-devel libjpeg-turbo-devel libjpeg-devel libpng-devel libtool libuuid-devel uuid-devel ffmpeg-devel freerdp-devel pango-devel libssh2-devel libtelnet-devel libvncserver-devel libwebsockets-devel pulseaudio-libs-devel openssl-devel libvorbis-devel libwebp-devel google-droid-sans-mono-fonts
tar -xvzf guacamole-server-1.4.0.tar.gz
pushd guacamole-server-1.4.0
./configure --with-init-dir=/etc/init.d
make
make install
ldconfig
popd
wget https://github.com/redbarnsystems/Guacamole/archive/refs/heads/master.zip
unzip master.zip
cp -R Guacamole-master/etc/guacamole /etc/
export GUACAMOLE_HOME=/etc/guacamole
service guacd start
systemctl enable guacd
systemctl restart guacd
systemctl status guacd
yum -y install tomcat
cp guacamole-1.4.0.war /var/lib/tomcat/webapps/rag.war
systemctl enable tomcat
systemctl restart tomcat
systemctl status tomcat
systemctl enable firewalld
systemctl start firewalld
firewall-cmd --permanent --add-port=22/tcp
firewall-cmd --permanent --add-port=8080/tcp
firewall-cmd --permanent --add-port=8443/tcp
firewall-cmd --reload