## Intro
A collection of drivers, docs and tools to work with "AVR JTAG ICE Version 2.0"

![Alt text](images/programmer-image.jpg?raw=true "AVR JTAG ICE Version 2.0")

This is a little device to program & debug AVR chips that have JTAG support, called 
"AVR JTAG ICE Version 2.0". Whether it can program AVR chips via ISP remains a mistery still,
but theoretically should be possible with a firmware change.

Protocols suppotred:
- JTAG
- UPDI (firmware needs to be changed - [GUIDE](https://github.com/ElTangas/jtag2updi/tree/master/tools/avrjtagicev2))


## Design

- CH340T USB to TTL IC
- ATMEL MEGA 16
- HC 245


# Installation Guide
- https://www.electrodragon.com/w/AVR_USB_JTAG_ICE_Programmer


# Tools
- [AVR Prog](AvrProg/AvrProg.exe?raw=true)
- [JTAGICE command line programmer (v 1.2 Mar)](JTAGICE/jtagice.exe?raw=true)
- [AVR AOSP python programmer](https://github.com/cbalint13/avr-aosp) : this can be use to upload custom firmwares

## Drivers 
Official driver page : http://www.wch.cn/download/ch341ser_exe.html