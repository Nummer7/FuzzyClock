## Geht die Variablen VIERTEL VOR NACH etc. durch 
## und Schaltet mittels deren Inhalt die entsprechenden 
## Leuchtmittel ein und aus.
## Der Inhalt der Variablen wird durch die config.sh bestimmt.
## Diese kann manuell erstellt werden, oder ueber die calibrateConfig.sh
## erstellt werden.

#!/bin/bash

## importiere Variablen (bzw. Script)
source config.sh

## gehe das Array array durch
array=(VIERTEL VOR NACH HALB EINS ZWEI DREI VIER FUENF SECHS SIEBEN ACHT NEUN ZEHN ELF ZWOELF UHR)
for i in "${array[@]}"
do
	## hole den Inhalt der Variablen mit dem derzeitigen Namen i
	var1=${!i}
	##extrahiere Variablenwerte mit sed/Regex
	add=$(echo $var1 | sed -E  's/(.*) {1}(.*)/\1/')
	cha=$(echo $var1 | sed -E  's/(.*) {1}(.*)/\2/')

	## disable Adresse $add
	./I2C_PCA9685_ENABLE.sh $add 0
	## schalte Channel $cha unter Adresse $add frei
	./I2C_PCA9685_SETCHANNEL.sh $add $cha 1
	## enable Adresse $add, zeige an was geaendert wurde
	./I2C_PCA9685_ENABLE.sh $add 1
	## eine Sekunde warten (busy)
	sleep 1
	## disable Adresse $add
	./I2C_PCA9685_ENABLE.sh $add 0
	## reset Channel $cha unter Adresse $add
	./I2C_PCA9685_SETCHANNEL.sh $add $cha 0
done
