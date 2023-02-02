echo "root=$FROM" > /etc/ssmtp/ssmtp.conf
echo "mailhub=$MAIL" >> /etc/ssmtp/ssmtp.conf
echo "FromLineOverride=YES" >> /etc/ssmtp/ssmtp.conf
echo "UseTLS=false" >> /etc/ssmtp/ssmtp.conf
echo "Debug=YES" >> /etc/ssmtp/ssmtp.conf
echo -e "From: $FROM\nTo: $TO\nSubject: $SUBJECT\n\nthis is the body" | (cat - && uuencode docker-logo.png docker-logo.png) | ssmtp $TO
