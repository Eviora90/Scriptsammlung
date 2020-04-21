#!/bin/bash

# REQUIREMENTS
# apt install sendemail libnet-ssleay-perl libio-socket-ssl-perl

#VARIABLES
#DISK
PLATTE="/dev/sda3"
# THRESHOLD: Warning Mail goes out if treshold is reached:
THRESHOLD=95

# CURRENT: what percentage of the partition is in use
# if $CURRENT bigger than $THRESHOLD a mail will be send
CURRENT=$(df $PLATTE | grep / | awk '{ print $5}' | sed 's/%//g')

#E-MAIL OPTIONS
SERVER="servername.de"
PORT="25"
FROM="mail@contoso.de"
TO="recipient@contoso.de"
SUBJ="Disk Space Low"
MESSAGE="The disk $PLATTE is running low. Currently $CURRENT% are being used"

#yes or no
SSL_ON="yes"
AUTH_ON="yes"

PASSWORD="password"


if [ "$CURRENT" -gt "$THRESHOLD" ];
then

 if [ "$SSL_ON" = "yes" ] && [ "$AUTH_ON" = "yes" ];
 then
 sendemail -o tls=yes -f $FROM -t $TO -xu $FROM -xp $PASSWORD -u "$SUBJ" -s $SERVER:$PORT -m "$MESSAGE" -v
fi

 if [ "$SSL_ON" = "yes" ] && [ "$AUTH_ON" = "no" ];
 then
 sendemail -o tls=yes -f $FROM -t $TO -u "$SUBJ" -s $SERVER:$PORT -m "$MESSAGE" -v
fi

 if [ "$SSL_ON" = "no" ] && [ "$AUTH_ON" = "yes" ];
 then
 sendemail --o tls=no f $FROM -t $TO -xu $FROM -xp $PASSWORD -u "$SUBJ" -s $SERVER:$PORT -m "$MESSAGE" -v
fi

 if [ "$SSL_ON" = "no" ] && [ "$AUTH_ON" = "no" ];
 then
 sendemail -o tls=no -f $FROM -t $TO -u "$SUBJ" -s $SERVER:$PORT -m "$MESSAGE" -v
fi
fi