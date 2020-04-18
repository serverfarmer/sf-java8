#!/bin/sh
. /opt/farm/scripts/init

# TODO: discover the latest available Java version automatically (currently hardcoded)

# Intel: http://www.java.com/pl/download/manual.jsp
# ARM: http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html
JAVAVER="1.8.0_251"



os=`uname`
arch=`uname -m`
if [ "$os" != "Linux" ]; then
	echo "system $os is not supported, skipping Java setup"
	exit 1

elif [ "$arch" = "x86_64" ]; then

	PRODUCT="jre"
	JAVAFILE="jre-8u251-linux-x64"
	URL="https://javadl.oracle.com/webapps/download/AutoDL?BundleId=242050_3d5a2bb8f8d4428bbe94aed7ec7ae784"

elif [ "$arch" = "i586" ] || [ "$arch" = "i686" ]; then

	PRODUCT="jre"
	JAVAFILE="jre-8u251-linux-i586"
	URL="https://javadl.oracle.com/webapps/download/AutoDL?BundleId=242048_3d5a2bb8f8d4428bbe94aed7ec7ae784"

else
	echo "architecture $arch is not supported, skipping Java setup"
	exit 1
fi

if [ -d /opt/java ] && [ ! -h /opt/java ]; then
	mv /opt/java /opt/java.disabled
fi

JAVADIR="${PRODUCT}${JAVAVER}"

if [ ! -d /opt/$JAVADIR ]; then
	DIR="`pwd`"
	cd /opt
	wget -O $JAVAFILE.tar.gz --header="Cookie: oraclelicense=accept-securebackup-cookie" "$URL"
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
