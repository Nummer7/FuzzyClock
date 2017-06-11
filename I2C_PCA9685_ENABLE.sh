## low-level gib Adresse $1 frei wenn $2 1 ansonsten nicht.

#!/bin/bash
if [ $2 -eq 1 ]; then
  i2cset -y 1 $1 0x00 0x01
else
  i2cset -y 1 $1 0x00 0x11
fi
