#!/bin/sh

if [ -h /opt/java ]; then
	rm -rf /opt/java
fi

if grep -q JAVA_HOME /etc/environment; then
	sed -i -e "/JAVA_HOME/d" /etc/environment
fi

if grep -q JAVA_OPTS /etc/environment; then
	sed -i -e "/JAVA_OPTS/d" /etc/environment
fi
