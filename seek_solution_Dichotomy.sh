#!/bin/bash

knot="/home/user03/mffoil03"
airfoil="rae2822"
fixl_original=0.824

tempp=0.0

fixlift=$(echo "scale=9;  $fixl_original * 0.4   " | bc)

function abc(){
  sh prep_cal.sh $knot $airfoil $1
  tempp=$(tail -1 ${airfoil}_$1deg/Cl-${airfoil}-$1deg  | awk  '{print $2}')
  echo "calculated lift value is=$tempp"
  return $?
}


alfa_left=0.0
alfa_right=6.1
echo "alfa_left=$alfa_left"
echo "alfa_right=$alfa_right"

echo "seeking begins"
abc $alfa_left
lift_left=$tempp
echo "lift_left=$lift_left"
echo "calculate once!!!"

abc $alfa_right
lift_right=$tempp
echo "lift_right=$lift_right"
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
    abc $alfa_mid
    lift_mid=$tempp
    echo "lift_mid=$lift_mid"
    echo "calculate once!!!"

    dist=$(echo "scale=9; ($fixlift - $lift_mid) *($fixlift - $lift_mid) " | bc )
    echo "dist=$dist"
    comp=$(echo "scale=9; $dist > 0.000005" | bc )
    echo "juge=$comp"

    while [ $comp -eq 1 ]
    do
	if [ $(echo "scale=9;  $lift_mid > $fixlift" | bc) -eq 1 ]; then
	alfa_right=$alfa_mid
	else
	alfa_left=$alfa_mid
	fi
    	alfa_mid=$(echo "scale=9;  0.5 * $alfa_left + 0.5 * $alfa_right " | bc)
	echo "alfa_left=$alfa_left"
	echo "alfa_mid=$alfa_mid"
	echo "alfa_right=$alfa_right"

    	abc $alfa_mid
	lift_mid=$tempp
	echo "calculate once!!!"
    	dist=$(echo "scale=9; ($fixlift - $lift_mid) *($fixlift - $lift_mid) " | bc )
	echo "dist=$dist"
    	comp=$(echo "scale=9; $dist > 0.000005" | bc )
    	echo "juge=$comp"
    done
   
fi

echo "fini"
echo "alfa_final=$alfa_mid"
echo "lift_final=$lift_mid"

