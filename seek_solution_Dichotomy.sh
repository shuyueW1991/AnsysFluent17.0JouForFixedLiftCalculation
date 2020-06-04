#!/bin/bash

knot="/home/user03/mffoil03"
airfoil="rae2822"
fixl_original=0.824


fixlift=$(echo "scale=9;  $fixl_original * 0.4   " | bc)

function abc(){
  sh prep_cal.sh $knot $airfoil $1
  echo $(tail -1 ${airfoil}_$1deg/Cl-${airfoil}-$1deg  | awk  '{print $2}')
}


alfa_left=0.0
alfa_right=6.0


echo "seeking begins"
lift_left=$(abc $alfa_left)
echo "calculate once!!!"
lift_right=$(abc $alfa_right)
echo "calculate once!!!"

if [ $(echo "scale=9;  $lift_left > $fixlift " | bc) -eq 1 ]; then
    echo "wrong!"
    break
elif [ $(echo "scale=9;  $lift_right < $fixlift" | bc) -eq 1 ]; then
    echo "wrong!"
    break
else
    echo "normal"
    alfa_mid=$(echo "scale=9;  0.5 * $alfa_left + 0.5 * $alfa_right " | bc)
    lift_mid=$(abc $alfa_mid)
    echo "calculate once!!!"

    while [ $(echo "scale=9; ($fixlift - $lift_mid) *($fixlift - $lift_mid) > 0.000005" | bc ) -eq 1 ]
    do
	if [ $(echo "scale=9;  $lift_mid > $fixlift" | bc) -eq 1 ]; then
	alfa_right=$alfa_mid
	else
	alfa_left=$alfa_mid
	fi
    	alfa_mid=$(echo "scale=9;  0.5 * $alfa_left + 0.5 * $alfa_right " | bc)
    	lift_mid=$(abc $alfa_mid)
	echo "calculate once!!!"


    done
   

fi

echo "fini"
echo "alfa_final=$alfa_mid"
echo "lift_final=$lift_mid"

