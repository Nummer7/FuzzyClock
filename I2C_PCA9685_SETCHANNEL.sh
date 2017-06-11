## low-level schalte Channel $2 ein/aus wenn $3
## die Werte die hineingeschrieben werden ergeben sich aus dem Datenblatt.
## Auch der Channel der beschrieben werden muss wird 
## ueber eine kleine Rechnung herangezogen

#!/bin/bash
## channel "berechnen"
channel=$((6+$2*4))
if [ $3 -eq 1 ]; then
	## Channel auf vollstandig EIN setzen
	i2cset -y 1 $1 $channel 0x0000 w
	i2cset -y 1 $1 $channel 0xff13 w
else
	## Channel auf vollstandig AUS setzen
	i2cset -y 1 $1 $channel 0x0010 w
	i2cset -y 1 $1 $channel 0x0000 w
fi
