#!/bin/sh
. /opt/farm/scripts/init

# TODO: discover the latest available Java version automatically (currently hardcoded)

# Intel: http://www.java.com/pl/download/manual.jsp
# ARM: http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html
JAVAVER="1.8.0_221"



os=`uname`
arch=`uname -m`
if [ "$os" != "Linux" ]; then
	echo "system $os is not supported, skipping Java setup"
	exit 1

elif [ "$arch" = "x86_64" ]; then

	PRODUCT="jre"
	JAVAFILE="jre-8u221-linux-x64"
	URL="https://javadl.oracle.com/webapps/download/AutoDL?BundleId=239848_230deb18db3e4014bb8e3e8324f81b43"

elif [ "$arch" = "i586" ] || [ "$arch" = "i686" ]; then

	PRODUCT="jre"
	JAVAFILE="jre-8u221-linux-i586"
	URL="https://javadl.oracle.com/webapps/download/AutoDL?BundleId=239846_230deb18db3e4014bb8e3e8324f81b43"

# as of 2019-04-18, all releases (even earlier than 2019-04-15) require logging in, probably due to new Java 8 license
#elif [ "$arch" = "armv7l" ]; then
#
#	PRODUCT="jdk"
#	JAVAFILE="jdk-8u221-linux-arm32-vfp-hflt"
#	URL="https://download.oracle.com/otn/java/jdk/8u221-b11/230deb18db3e4014bb8e3e8324f81b43/jdk-8u221-linux-arm32-vfp-hflt.tar.gz"

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

# On Raspbian, this directory is provided by outdated package oracle-java8-jdk,
# which however can't be simply uninstalled due to complicated dependencies.
if [ "$arch" = "armv7l" ] && [ -d /usr/lib/jvm/jdk-8-oracle-arm32-vfp-hflt ]; then
	rm -rf /usr/lib/jvm/jdk-8-oracle-arm32-vfp-hflt
	ln -s /opt/java /usr/lib/jvm/jdk-8-oracle-arm32-vfp-hflt
fi

if [ "`which java`" = "" ]; then
	ln -s /opt/java/bin/java /usr/local/bin/java
fi
