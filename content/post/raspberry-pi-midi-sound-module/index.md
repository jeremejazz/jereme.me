---
title: "Raspberry Pi as a MIDI Sound Module"
date: 2023-04-07T19:24:38+08:00
draft: true
---

I've used the Raspberry PI to create a portable MIDI sound module. I've been using this to be able to plug it on a MIDI keyboard controller to be able to play music different instruments.

So a MIDI (Musical Instrument Digital Interface) is a protocol that allows electronic musical instruments, computers, and other devices to communicate with each other. I'ts kind of a standard that has been going on since the 80s.

## Components I've Used

### Hardware

- Raspberry Pi 3B+
- MAudio Keystation Mini 32 (MIDI Controller)
- 3.5 inch Touch Screen

## Software

- Raspberry OS (formerly Raspbian)
- FluidSynth

I would recommend the more recent Raspberry Pi 4 at the time of this writing though. It has better performance and more memory. But from what I've tried the 3B+ is also good enough.

## Touchscreen (optional)

I got this from Alibaba. This enables me

In addition I am using a 3.5-inch LCD I've purchased from Alibaba along with the Raspberry PI. The

In the future I might be adding a GUI for enabling FluidSynth, soundfont selection, and since I found out just recently that the current Raspberry OS (as of 2023) contains [PyQT5](https://riverbankcomputing.com/software/pyqt/intro), which is a library that enables bindings with the Qt5 that let's you create user interfaces.
