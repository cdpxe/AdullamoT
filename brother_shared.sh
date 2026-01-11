#!/bin/bash
# Brother HL-L2375DW series
# Code for shared functions (used by both, CS and CR).

ACK_MESSAGE="OK" # replace this with the original location string

# retrieve a current CSRF token
# this function also replaces tmp_$$, which does contain the recv'd message!
function get_csrf_token()
{
	GET http://${PRINTER_IP}/general/contact.html | sed -n '/.*CSRFToken\"\ value=\"/,$p' | head -5 > /tmp/tmp_$$
	#now parse tmp_$$ file to get the token
	CSRF=`cat /tmp/tmp_$$ | sed 's/.*CSRFToken\"\ value=\"//' | sed 's/\"\/><\/div><div\ class.*//' | tr '\r\n' ' ' | sed 's/\ //g'`
	# make sure to use URL encoding like %3D instead of = etc.
	CSRF=`urlencode $CSRF`
	echo $CSRF
}

# parameters: printer-ip  csrf  secret_msg
function post_message()
{
	#pageid=320&CSRFToken=&B109=Max+Mustermann&B10a= + len(CSRF) + len(SECRET_MSG)
	POST_DATA_LEN=$((49+${#2}+${#3}))
	#echo "POST_DATA_LEN=$POST_DATA_LEN"
	echo 'POST /general/contact.html HTTP/1.1
Host: '$1'
User-Agent: Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:146.0) Gecko/20100101 Firefox/146.0
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8
Accept-Language: de,en-US;q=0.7,en;q=0.3
Accept-Encoding: gzip, deflate
Referer: http://'$1'/general/contact.html
Content-Type: application/x-www-form-urlencoded
Content-Length: '$POST_DATA_LEN'
Origin: http://'$1'
DNT: 1
Connection: keep-alive
Upgrade-Insecure-Requests: 1
Sec-GPC: 1
Priority: u=0, i

pageid=320&CSRFToken='$2'&B109=Max+Mustermann&B10a='$3'


' | nc $PRINTER_IP 80 > /dev/null
}

