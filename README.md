# AdullamoT

This repository features the AdullamoT proof of concept code.

## Requirements

The code was tested under Linux (Debian and Ubuntu). The following packages are necessary to run the different scripts: `urlencode` (part of the `gridsite-clients` package), `curl`, plus standard tools (`openssl`, `bash`, `sed`, `awk` etc.).

## How-to

In general, one uses the `xxx_send.sh` script to send data to an IoT device, and the `xxx_recv.sh` script to retrieve the data.
However, before using these scripts, one needs to configure the IP address of the IoT device using the following variable that can be found in every script. For convenience, the smart speaker's IP is referred to with the same variable. Make sure to adjust both, the sender and the receiver script for a tool.

``
PRINTER_IP="192.168.0.1"
``

Now, one can easily send data as follows, where *SECRETMESSAGE* represents the secret message. The following example uses the *HP DeskJet Pro*:

```
./hp_send.sh SECRETMESSAGE
Sending chunks of the secret msg ...
sending EOF: done.
```

Receiving the message works as follows:

```
./hp_recv.sh
```

## Overview of Supported IoT Devices

...


## Notes

#### BLOCK SB 100

**1. Information on the Appearance of Secret Messages:** The caused 404 error messages caused by `GET` requests of the covert sender result in the following messages on port 514 on the BLOCK device:

```
%(Thread2): [ 151855.884631] FSFS   (2): fsfsFlashFileHandleOpen: File 'flash://AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA' not fou
%(Thread2): [ 151855.886162] WFSAPI (2): File not found
````

In that case, the string "`AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA`" is the requested URL that equals the secret message. In order to represent data in an URL compatible format, we utilize `urlencode`.

**2. Spotify-related Spurious Log Messages:** The following messages appear on port 514 from time to time and overwrite our secret messages. These messages relate to the *Spotify* service and limit the storage doration of the secret data.

```
(Thread2): [ 506731.853883] SPOTIFY (2): spotifyTspTaskEntry(): cmd:4 error:0
```
