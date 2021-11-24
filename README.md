[![EN](https://user-images.githubusercontent.com/9499881/33184537-7be87e86-d096-11e7-89bb-f3286f752bc6.png)](https://github.com/r57zone/UPnP/blob/master/README.md) 
[![RU](https://user-images.githubusercontent.com/9499881/27683795-5b0fbac6-5cd8-11e7-929c-057833e01fb1.png)](https://github.com/r57zone/UPnP/blob/master/README.RU.md) 
# UPnP 
Application for ports forwarding on router with UPnP.

## Screenshots
![](https://user-images.githubusercontent.com/9499881/34568307-cba427dc-f17e-11e7-975c-dec1fcdef29e.PNG)

## Setup
For auto forwarding port at startup, need to add a shortcut in startup with startup parameters.<br>
<br>**Example of adding a TCP port:**
>"C:\Program Files\UPnP\UPnP.exe" -add -i 8080 -e 80 -ip 192.168.0.100 -n "webserver (TCP)"

Where "nginx (TCP)" is the name, "8080" is the internal port, and "80" is the external one. For UDP add "-udp" parameter.
<br><br>**Example of removing a TCP port:**

>"C:\Program Files\UPnP\UPnP.exe" -rem -e 80

For UDP add "-udp" parameter.

## Download
>Version for Windows 7, 8.1, 10.<br>
**[Download](https://github.com/r57zone/UPnP/releases)**

## Feedback
`r57zone[at]gmail.com`