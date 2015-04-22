#!/bin/bash
sudo /usr/sbin/dmidecode  | grep -A3 'System Information' >> ~/_$HOSTNAME-info.txt
/tms6/scripts/version.sh >> ~/_$HOSTNAME-info.txt
/bin/rpm -qa --last | grep tms >> ~/$HOSTNAME-info.txt
/usr/bin/wget --output-document=/home/tms6/$HOSTNAME-snapshot.html -q http://localhost/tms-cgi-bin/snapshot.cgi
/bin/tar -pczf ~/$HOSTNAME-tracelogs.tar.gz /tms6/log/trace/tracelog.*

###FTP
/usr/bin/expect << EOFFF
        set timeout 600
        spawn ftp 207.13.72.21
        expect "Name (207.13.72.21:tms6): "
        send "thoyt\r"
        expect "Password:"
        send "Xqsdeybtf13\r"
        expect "ftp>"
        send "bin\r"
        expect "ftp>"
        send "hash\r"
        expect "ftp>"
        send "put ~/$HOSTNAME-snapshot.html $HOSTNAME-snapshot.html\r"
        expect "ftp>"
        send "put ~/$HOSTNAME-info.txt $HOSTNAME-info.txt\r"
        expect "ftp>"
        send "put ~/$HOSTNAME-tracelogs.tar.gz $HOSTNAME-tracelogs.tar.gz\r"
        expect "ftp>"
        send "bye"
EOFFF

rm ~/$HOSTNAME-snapshot.html
rm ~/$HOSTNAME-info.txt
rm ~/$HOSTNAME-tracelogs.tar.gz

###SCP
#/usr/bin/expect << EOFFF
#       spawn scp ~/snapshot-$HOSTNAME.html ~/INFO_$HOSTNAME  "thoyt\@207.13.72.21:~"
#       expect {
#          -re ".*es.*o.*" {
#             exp_send "yes\r"
#             exp_continue
#          }
#          -re ".*sword.*" {
#             exp_send "Xqsdeybtf13\r"
#          }
#       }
#       interact
#EOFFF

