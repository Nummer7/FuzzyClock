## Dieses Script holt konvertiert die Uhrzeit $1=Stunden $2=Minuten in eine 
## geschriebenes fuzzyges Format: 1:30Uhr = halb Zwei 

#!/bin/bash
min=$2
hour=$1
hour=$((hour%12))
if [ "$hour" = "0" ]; then
  hour=1
fi

toNumbersString=(Eins Zwei Drei Vier Fuenf Sechs Sieben Acht Neun Zehn Elf Zwoelf)
index=$hour

## Unter welchen bedingungen muss welches Wort geschrieben werden
uhr=$((min>=54 || min<=7))
viertel=$(( (min>=8 && min <=22) || (min>=38 && min<=53) ))
halb=$((min>=23 && min<=37))
vornach=$((min<30))
kurz=$(( (min>=4 && min<=7) || (min >=53 && min<=57) ))
vor=0
nach=0

## Die variable die den Text beinhaltet
outout=

if [ "$viertel" = "1" ]; then
  output="$output viertel"
elif [ "$halb" = "1" ]; then
  output="$output halb"
  index=$((index+1))
fi

nicht_halb_uhr=$((halb || uhr))
if [ "$nicht_halb_uhr" = "0" ]; then
  if [ "$vornach" = "1" ]; then
        nach=1
        output="$output nach"
        index=hour
  else
        vor=1
        output="$output vor"
        index=$((hour+1))
  fi
fi

if [ "$((index==13))" = "1" ]; then
  index=1
fi


if [ "$uhr" = "1" ]; then
  if [ "$vornach" = "0" ]; then
        index=$((hour+1))
  fi
  output="$output ${toNumbersString[$index-1]}"
  output="$output Uhr"
else
  output="$output ${toNumbersString[$index-1]}"
fi


echo "$output"
