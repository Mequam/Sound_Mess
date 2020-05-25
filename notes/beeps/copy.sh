#!/bin/bash
#this script copies each file inside of the beep folder to the main folder for usage in the game while on a unix system with bash
for i in $(ls); do cp $i ../$(echo $(echo $i | tr '_' ' ' | awk '{print $1}').wav) ; done
