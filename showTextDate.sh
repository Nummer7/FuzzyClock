## Dieses Script besorgt sich die Uhrzeit und fuettert dateToText.sh damit.
## Die String-Uhrzeit wird dann ins Uppercase formatiert und in einem Array 
## den Leerzeichen nach aufgesplitet und je nach vorkommen ein geschaltet.
## z.B. ist es 2:30=halb Drei => HALB DREI => es wird nach den Variablen HALB 
## und DREI gesucht die schon durch config.sh definiert sind und die richtigen Adressen
## beinhalten. Diese werden benutzt um die jeweiligen Channel einzuschalten.

#!/bin/bash

while true; do
	## Uhrzeit besorgen
	d=$(date +"%H %M")
	echo $d
	
	## Variablen importieren (script einbinden)
	source config.sh
	
	## Uhrzeit in String umwandeln
	datetext=$(./dateToText.sh $d)
	echo $datetext

	##String to UPPER
	datetext="$(echo $datetext | tr '[:lower:]' '[:upper:]')"

	##alles ausschalten
	./I2C_PCA9685_ENABLE.sh 0x70 0
	./I2C_PCA9685_SETCHANNEL.sh 0x70 61 0

	echo "$datetext"
	## den String an den Leerzeichen aufsplitten
	for i in $(echo $datetext | tr " " "\n"); do
		## Variableninhalt zu passendem Text heraussuchen
		var1=${!i}
		add=$(echo $var1 | sed -E  's/(.*) {1}(.*)/\1/')
		cha=$(echo $var1 | sed -E  's/(.*) {1}(.*)/\2/')

		## und einschalten
		./I2C_PCA9685_SETCHANNEL.sh $add $cha 1
	done
	
	## und wenn alle eingeschaltet wurden, dann freigeben
	./I2C_PCA9685_ENABLE.sh 0x70 1
	##kurz warten 
	sleep 300
	##nochmal alles ausschalten und von vorne
	./I2C_PCA9685_ENABLE.sh 0x70 0
	./I2C_PCA9685_SETCHANNEL.sh 0x70 61 0
done
