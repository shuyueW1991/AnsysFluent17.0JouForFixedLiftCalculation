#!/bin/bash

function abc(){
  res=$(echo "scale=9;1.0 - ($1 - 1.0) * ($1 - 1) "| bc)
  echo $res
}

alfa=0.50
step=0.10
lift=$(abc $alfa)
echo "calculate once!!!"

while [ $(echo "scale=9; (0.9 - $lift) > 0.001" | bc ) -eq 1 ]
do
    echo "round begins"
    echo "alfa=$alfa"
    echo "step=$step"
    
    alfa_tent=$(echo "scale=9; $alfa + $step" | bc)
    echo "alfatent=$alfa_tent"
    lift_tent=$(abc $alfa_tent)
    echo "lifttent=$lift_tent"
    echo "calculate once!!!"


    while [ $(echo "$lift_tent > 0.9" | bc) -eq 1 ]
    do
        echo "surpassed"
	if [ $(echo "scale=6; ( $lift_tent - 0.9) < 0.001" | bc) -eq 1 ]; then
    	alfa=$alfa_tent 
	lift=$lift_tent
	break
	else
	step=$(echo "scale=6;$step / 2.0" | bc)
    	echo "step=$step"
    	alfa_tent=$(echo "scale=9; $alfa + $step" | bc) 
	echo "alfatent=$alfa_tent"
	lift_tent=$(abc $alfa_tent)
	echo "lifttent=$lift_tent"
        echo "calculate once!!!"
	fi
    done
    alfa=$alfa_tent 
    lift=$lift_tent
done
echo $alfa
echo $lift
