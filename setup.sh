#!/bin/sh
. /opt/farm/scripts/init

# TODO: discover the latest available Java version automatically (currently hardcoded)

# http://www.java.com/pl/download/manual.jsp
JAVADIR="jre1.8.0_131"



os=`uname`
arch=`uname -m`
if [ "$os" != "Linux" ]; then
	echo "system $os is not supported, skipping Java setup"
	exit 1
elif [ "$arch" = "x86_64" ]; then
	JAVAFILE="jre-8u131-linux-x64"
	BUNDLEID="220305_d54c1d3a095b4ff2b6607d096fa80163"
elif [ "$arch" = "i586" ] || [ "$arch" = "i686" ]; then
	JAVAFILE="jre-8u131-linux-i586"
	BUNDLEID="220303_d54c1d3a095b4ff2b6607d096fa80163"
else
	echo "architecture $arch is not supported, skipping Java setup"
	exit 1
fi

if [ -d /opt/java ] && [ ! -h /opt/java ]; then
	mv /opt/java /opt/java.disabled
fi

if [ ! -d /opt/$JAVADIR ]; then
	DIR="`pwd`"
	cd /opt
	wget -O $JAVAFILE.tar.gz http://javadl.sun.com/webapps/download/AutoDL?BundleId=$BUNDLEID
	tar xzf $JAVAFILE.tar.gz
	rm -f $JAVAFILE.tar.gz /opt/java
	ln -sf $JAVADIR java
	touch $JAVADIR/.nobackup
	cd "$DIR"
fi

if ! grep -q JAVA_HOME /etc/environment; then
	echo 'JAVA_HOME="/opt/java"' >>/etc/environment
fi

if [ "`which java`" = "" ]; then
	ln -s /opt/java/bin/java /usr/local/bin/java
fi
