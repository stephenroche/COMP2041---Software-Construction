#!/bin/sh


# print HTTP header
# its best to print the header ASAP because 
# debugging is hard if an error stops a valid header being printed

echo Content-type: text/html
echo

# print page content

cat <<eof
<!DOCTYPE html>
<html lang="en">
<head>
<title>Browser IP, Host and User Agent</title>
</head>
<body>
eof



# print all environment variables
# This is interpreted as HTML so we replace some chars by the equivalent HTML entity.
# Note this will not guarantee security in all contexts.

IPaddr=`env|
sed 's/&/\&amp;/;s/</\&lt;/g;s/>/\&gt;/g'|
egrep '^REMOTE_ADDR='|
sed 's/^REMOTE_ADDR=//'`

host=`host $IPaddr|
egrep -o '\S+$'|
sed 's/\.$//'`

browser=`env|
sed 's/&/\&amp;/;s/</\&lt;/g;s/>/\&gt;/g'|
egrep '^HTTP_USER_AGENT='|
sed 's/^HTTP_USER_AGENT=//'`

cat <<eof
Your browser is running at IP address: <b>$IPaddr</b>
<p>
Your browser is running on hostname: <b>$host</b>
<p>
Your browser identifies as: <b>$browser</b>
eof


cat <<eof
</body>
</html>
eof
