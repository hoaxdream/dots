#!/usr/bin/env python
# Copyright (C) 2006 by Johannes Zellner, <johannes@zellner.org>
# modified by mac@calmar.ws to fit my output needs
# modified by crncosta@carloscosta.org to fit my output needs

import sys
import os

def echo(msg):
    os.system('echo -n "' + str(msg) + '"')

def out(n):
    os.system("tput setab " + str(n) + "; echo -n " + ("\"% 6d\"" % n))
    os.system("tput setab 0")

# normal colors 1 - 16
os.system("tput setaf 16")
for n in range(8):
    out(n)
echo("\n")
for n in range(8, 16):
    out(n)

echo("\n")
echo("\n")

def out(n):
    os.system("tput setab " + str(n) + "; echo -n " + ("\"% 4d\"" % n))
    os.system("tput setab 0")
    
y=16
while y < 231:
    for z in range(0,12):
        out(y)
        y += 1

    echo("\n")


echo("\n")

for n in range(232, 256):
    out(n)
    if n == 243:
        echo("\n")

echo("\n")
os.system("tput setaf 7")
os.system("tput setab 0")

input("Press enter to exit ;)")
