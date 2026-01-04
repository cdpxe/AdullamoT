#!/bin/bash
#BLOCK SB 100
# Code for shared functions (used by both, CS and CR).

# parameters: printer-ip  csrf  secret_msg
#			  ^^^^=unused
function post_message()
{
	GET "http://"$1"/"$3 >/dev/null
}


