## Dieses Script erstellt eine Datei namens "config.sh" 
## in der Variablen wie VIERTEL ACHT etc. vorkommen, die
## die Channelnummer und die Adresse der Relaiskarte enthalten.

#!/bin/bash

## Loesche channels.sh
rm channels.sh
## fuege Umgebung hinzu
echo "#!/bin/bash" >> config.sh

## erst alles ausschalten
./I2C_PCA9685_ENABLE.sh 0x70 0
./I2C_PCA9685_SETCHANNEL.sh 61 0

## array gefuellt mit allen Adressen, der Relaiskarten 
## (sind Verdrahten also nur bedingt aenderbar)
array=(0x67 0x6b 0x6e)

## gehe die Karten durch
for i in "${array[@]}"
do
	## probiere Channel 8 bis 16 aus
	for channelNum in `seq 8 16`
	do
	curchannel="$i $channelNum"
	echo $curchannel

	## Channel testweise einschalten
	./I2C_PCA9685_ENABLE.sh $i 0
	./I2C_PCA9685_SETCHANNEL.sh $curchannel 1
	./I2C_PCA9685_ENABLE.sh $i 1

	## Ausgeben damit der USER sieht welcher Channel gerade Leuchtet
	echo "'$curchannel' ist:"
	
	## Warte auf Usereingabe
	read -t 2 -n 1 inp
	if [ -n "$inp" ]; then
		## aha!, da leuchtet was! Namen Tippen, z.B. VIERTEL etc wenn Viertel aufleuchtet
		read -p ">" inp
		## Wird zur config hinzugefuegt
		echo "$inp abgespeichert"
		echo "$inp='$curchannel'" >> config.sh
		echo "${inp}Add=$i" >> config.sh
		echo "${inp}Channel=$channelNum" >> config.sh
	fi
	
	## alles ausschalten
	./I2C_PCA9685_ENABLE.sh $i 0
	./I2C_PCA9685_SETCHANNEL.sh $curchannel 0
	
	## Variable leeren
	inp=
	done
done

