#!/bin/bash
cat ~/openvpn/*.ovpn | grep "remote " | cut -d " " -f 2 | cut -d "." -f 1 | cut -d "-" -f 2-