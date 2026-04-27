# AdullamoT

This repository features the AdullamoT proof of concept code. It belongs to the following paper:

| [Steffen Wendzel](https://www.wendzel.de): *AdullamoT: Using IoT Devices as Relays for Time-decoupled Secret Exchange and Censorship Circumvention*, in Proc. 14th ACM Workshop on Information Hiding and Multimedia Security (ACM IH&MMSec 2026), Florence, Italy, June 17-19, in press. |
|----|

## Dependencies

The code was tested under Linux (Debian and Ubuntu). The following packages are necessary to run the scripts: `urlencode` (part of the `gridsite-clients` package), `curl`,  `nc` plus standard tools (`openssl`, `bash`, `sed`, `awk` etc.).

## How-to

In general, one uses the `xxx_send.sh` script to send secret data to an IoT device, and the `xxx_recv.sh` script to retrieve the data.
Before using these scripts, one needs to configure the IP address of the IoT device using the `PRINTER_IP` variable that can be found at the beginning of every script. For convenience, the smart speaker's IP is referred to with the same variable as the IPs of the printers. Make sure to adjust the `PRINTER_IP` of both, the sender script and the receiver script.

``
PRINTER_IP="192.168.0.1"
``

Now, one can easily send data as follows, where *SECRETMESSAGE* represents the secret message. The following example uses the *HP LaserJet Pro*. First, we need to start the receiver:

```
./hp_recv.sh 
###########
```
Each `#` represents a pull for new information from the IoT device.

Now, since the receiver is waiting for data, we can run the sender script:

```
./hp_send.sh SECRETMESSAGE
Sending chunks of the secret msg ...
#K#sending EOF: done.
```

This first sends *SECRETMESSAGE*, followed by *EOF*. Again, each `#` represents a pull for receiver feedback information, while a `K` represents a received acknowledgement message from the receiver, i.e., the information that the next chunk of data can be sent (if the message is long enough).

Meanwhile the receiver script should output the received data:

```
############# MSG=SECRETMESSAGE
```

Simply hit **CTRL+C** to interrupt the receiver.

## Overview of Supported IoT Devices

| Script | Product Series (Tested Product) |
|----------|----------|
| `hp_send`, `hp_recv`  | HP LaserJet Pro (HP LaserJet Pro M148dw) |
| `hp_M_send`, `hp_M_recv`  | HP LaserJet (HP LaserJet M15w) |
| `brother_send`, `brother_recv`  | Brother HL series (HL-L2375DW) |
| `block_send`, `block_recv`  | BLOCK SB 100, probably also BLOCK SB 50 and 200 (BLOCK SB 100) |

## Notes

#### Fine-tuning Acknowledgement Messages for Printers

As discussed in the paper, resetting *location* settings back to the original values after a message has been received aids covertness. For this reason, one can simply modify a variable in the code that uses the original location string as an *acknowledgement* message. The variable can be found in the `..._shared.sh` files of the printers:

```
ACK_MESSAGE="OK" # replace the "OK" with the string of your choice.
```

#### BLOCK SB 100

**1. Information on the Appearance of Secret Messages:** The error messages caused by `GET` requests of the covert sender (which needs to request such inexistent web pages to trigger the appearance of the error) result in the following messages on port 514 on the BLOCK device:

```
%(Thread2): [ 151855.884631] FSFS   (2): fsfsFlashFileHandleOpen: File 'flash://AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA' not fou
%(Thread2): [ 151855.886162] WFSAPI (2): File not found
````

In that case, the string "`AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA`" is the requested URL that equals the secret message. In order to represent data in an URL compatible format, we utilize `urlencode`.

**2. Spotify-related Spurious Log Messages:** The following messages appear on port 514 from time to time and overwrite our secret messages. These messages relate to the *Spotify* service and limit the storage doration of the secret data.

```
(Thread2): [ 506731.853883] SPOTIFY (2): spotifyTspTaskEntry(): cmd:4 error:0
(Thread2): [ 582271.514119] SPOTIFY (2): spotifyTspTaskEntry(): cmd:-1335047288 error:0
```
(The latter message appears in fewer cases than the former one.)
