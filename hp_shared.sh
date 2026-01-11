#!/bin/bash
# HP LaserJet Pro M148dw
# Code for shared functions (used by both, CS and CR).

ACK_MESSAGE="OK" # replace this with the original location string

# parameters: printer-ip  csrf  secret_msg
#			  ^^^^=unused
function post_message()
{
	# len( invalidEntryStr=Eingabe+ist+ung%C3%BCltig.&AirPrint_enabled=true&BonjourEnabled=true&cTurnOnAirPrint_string=AirPrint+einschalten&cChangeSettings_string=Einstellungen+%C3%A4ndern&cSuppliesStatus_string=Zubeh%C3%B6rstatus&nameWarningStr=Warnung%3A+Das+%C3%84ndern+dieser+Einstellung+f%C3%BChrt+zu+einem+Verlust+an%0D%0AVerbindungsm%C3%B6glichkeiten+der+angeschlossenen+Clients.&areYouSureStr=M%C3%B6chten+Sie+diese+Einstellung+wirklich+%C3%A4ndern%3F&bonjourPrinterName=HP+LaserJet+Pro+M148dw+%28D13F0F%29+&DeviceLocation=&geoLocation=&apply_button=%C3%9Cbernehmen ) = 562  + len(SECRET_MSG)
	POST_DATA_LEN=$((562+${#3}))
	#echo "POST_DATA_LEN=$POST_DATA_LEN"
	
	echo 'POST /hp/device/info_config_AirPrint.html/config HTTP/1.1
Host: '$1'
User-Agent: Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:146.0) Gecko/20100101 Firefox/146.0
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8
Accept-Language: de,en-US;q=0.7,en;q=0.3
Accept-Encoding: gzip, deflate, br, zstd
Referer: https://'$1'/hp/device/info_config_AirPrint.html?tab=Networking&menu=AirPrintStatus
Content-Type: application/x-www-form-urlencoded
Content-Length: '$POST_DATA_LEN'
Origin: https://'$1'
DNT: 1
Connection: keep-alive
Upgrade-Insecure-Requests: 1
Sec-Fetch-Dest: document
Sec-Fetch-Mode: navigate
Sec-Fetch-Site: same-origin
Sec-Fetch-User: ?1
Sec-GPC: 1
Priority: u=0, i

invalidEntryStr=Eingabe+ist+ung%C3%BCltig.&AirPrint_enabled=true&BonjourEnabled=true&cTurnOnAirPrint_string=AirPrint+einschalten&cChangeSettings_string=Einstellungen+%C3%A4ndern&cSuppliesStatus_string=Zubeh%C3%B6rstatus&nameWarningStr=Warnung%3A+Das+%C3%84ndern+dieser+Einstellung+f%C3%BChrt+zu+einem+Verlust+an%0D%0AVerbindungsm%C3%B6glichkeiten+der+angeschlossenen+Clients.&areYouSureStr=M%C3%B6chten+Sie+diese+Einstellung+wirklich+%C3%A4ndern%3F&bonjourPrinterName=HP+LaserJet+Pro+M148dw+%28D13F0F%29+&DeviceLocation='$3'&geoLocation=&apply_button=%C3%9Cbernehmen


' | openssl s_client -connect ${1}:443 > /dev/null 2>&1
}

