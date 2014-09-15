#!/bin/bash

# +-------------------------------------------------------------------------------+
# |                           GeeksOnBoard                                        |
# |                            12.12.2013                                         |
# +-------------------------------------------------------------------------------+
# | Script sends allert about set connection with server via email.               |
# | To work correctly demands either sstp or mail packages.                       |
# | call: if_connected.sh host_name mail_address                                  |
# +-------------------------------------------------------------------------------+


#check if correct number of arguments is given
[ $# -eq 2 ] || { echo "Script: $0. Call: $0 hosta_name mail_address" 1>&2 && exit 1; }

#if ssmtp is installed. If not use mail.
([ -e `whereis ssmtp > /dev/null 2>&1` ] && poczta=(ssmtp $2))  || poczta=(mail $2)

#Sleep if server doesn't response
until `ping -c 1 $1 > /dev/null` ; do sleep 2; done

#connection possible - sending email to user.
echo "To: $2
Subject: connection with $1

Connection with server $1 succesfully set" | $poczta

echo "finished!"

exit 0
