# AdullamoT

This repository features the AdullamoT proof of concept code.

## Requirements

The code was tested under Linux (Debian and Ubuntu). The following packages are necessary to run the different scripts: `urlencode` (part of the `gridsite-clients` package), `curl`, plus standard tools (`openssl`, `bash`, `sed`, `awk` etc.).

## How-to


## Notes

#### BLOCK SB 100

**1. Information on the Appearance of Secret Messages:** The caused 404 error messages caused by `GET` requests of the covert sender result in the following messages on port 514 on the BLOCK device:

```
%(Thread2): [ 151855.884631] FSFS   (2): fsfsFlashFileHandleOpen: File 'flash://AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA' not fou
%(Thread2): [ 151855.886162] WFSAPI (2): File not found
````

In that case, the string "`AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA`" is the requested URL that equals the secret message. In order to represent data in an URL compatible format, we utilize `urlencode`.

**2. Spotify-related Errors:** The following messages appear on port 514 from time to time and overwrite our secret messages. These messages relate to the *Spotify* service. 

```
(Thread2): [ 506731.853883] SPOTIFY (2): spotifyTspTaskEntry(): cmd:4 error:0
```
