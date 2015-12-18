#!/bin/bash
. /opt/farm/scripts/init
. /opt/farm/scripts/functions.install


# TODO: discover the latest available Java version automatically (currently hardcoded)
# TODO: discover system and hardware architecture (currently it works only on Linux-x64)

# http://www.java.com/pl/download/manual.jsp
JAVADIR="jre1.8.0_66"
JAVAFILE="jre-8u66-linux-x64"
BUNDLEID="111741"


if [ ! -d /opt/$JAVADIR ]; then
	DIR="`pwd`"
	cd /opt
	wget -O $JAVAFILE.tar.gz http://javadl.sun.com/webapps/download/AutoDL?BundleId=$BUNDLEID
	tar xzf $JAVAFILE.tar.gz
	rm -f $JAVAFILE.tar.gz
	cd "$DIR"
fi

if [ ! -d /opt/java ]; then
	ln -sf /opt/$JAVADIR /opt/java
fi

if ! grep -q /opt/java/bin /etc/environment; then
	echo 'PATH="$PATH:/opt/java/bin"' >>/etc/environment
	echo 'JAVA_HOME="/opt/java"' >>/etc/environment
	echo 'JAVA_OPTS="-Djava.net.preferIPv4Stack=true -Djava.net.preferIPv4Addresses=true"' >>/etc/environment
fi
