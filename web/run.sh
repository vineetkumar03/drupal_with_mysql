#!/bin/sh

#echo "164.100.14.58 auths.nic.in" >> /etc/hosts


echo "=> Apache started..."
/usr/sbin/apache2ctl -D FOREGROUND
