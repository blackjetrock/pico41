This project has been superseded by Tulip
=========================================

It is recommeded that the Tulip project is used instead of this one. It can be found here:

https://github.com/mjakuipers/TULIP-DevBoard

It has more features, by far. The only feature that it doesn't have is the key pressing, but it does have many more ways to enter programs...

Pico41
======

This is a PCB that can be attached to an HP41C (using wires soldered to the processor PCB of the HP41C) that allows:

* The HP41C bus to be examined and traced
* Data to be placed on the bus
* Keys on the keyboard to be pressed
* viewing of the display on an OLED display on the PCB

You can see what is happening on the bus just like a logic analyser. The tracing (and other interaction) is through the USB of the Pico.
You can emulate modules by putting appropriate words on the bus. Currently I have emulated a MATH module. Bank switched modules aren't supported, nor are RAM modules, but that is just a matter of code that I haven't done yet.
You can press keys on the keyboard, so can enter programs by pressing the appropriate keys. I have a script that converts program in text form and embeds the keypresses into the Pico program such that they can be played back in PRGM mode. Once entered like this the program can be SST'd automatically and checked against a listing that is also embedded in the Pio program.

RP Pico on HP41C bus, showing an emulated MATH module where one word has been altered:

![IMAG3808](https://github.com/blackjetrock/pico41/assets/31587992/99990ba1-36e3-475d-b32e-8eb049ce69e9)

To Do
=====

It should be possible to emulate the display controller and use this Pico setup as a replacement for the display controller. For example a broken display controller should be replaceable by this program.
RAM should also be emulatable with more code.
Module code could be changed over USB rather than being embedded in the Pico code as it is now.


More Information
================

* https://youtu.be/KFQwrbWywjY
* https://youtu.be/kRxo2ekzvyg

This is a work in progress
==========================
