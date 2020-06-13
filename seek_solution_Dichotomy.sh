#!/bin/bash

knot="/home/user03/mffoil"
airfoil="rae2822"
fixl_original=0.824

tempp=0.0

fixlift=$(echo "scale=9;  $fixl_original * 1.0   " | bc)

function abc(){
  sh prep_cal.sh $knot $airfoil $1
  tempp=$(tail -1 ${airfoil}_$1deg/Cl-${airfoil}-$1deg  | awk  '{print $2}')
  echo "calculated lift value is=$tempp"
  return $?
} 


alfa_left=1
alfa_right=7
echo "alfa_left=$alfa_left"
echo "alfa_right=$alfa_right"


abc $alfa_left
lift_left=$tempp
lift_left=$(echo "$lift_left"| awk '{printf("%.6f",$0)}')
echo "lift_left=$lift_left"


abc $alfa_right
lift_right=$tempp
lift_right=$(echo "$lift_right"| awk '{printf("%.6f",$0)}')
echo "lift_right=$lift_right"


if [ $(awk -v  num1=$lift_left -v num2=$fixlift  'BEGIN{print(num1>num2)?"1":"0"}') -eq 1 ]; then
    echo "wrong!the left initial value is taken too big"
elif [ $(awk -v  num1=$lift_right -v num2=$fixlift  'BEGIN{print(num1<num2)?"1":"0"}') -eq 1 ]; then
    echo "wrong!the  right initial value is taken too small"
else
    echo "normal, continue"
    weight=$(echo "scale=9;  ($fixlift - $lift_left)/($lift_right - $lift_left) " | bc)
    alfa_mid=$(echo "scale=9;  (1.0 - $weight) * $alfa_left + $weight * $alfa_right " | bc)
    abc $alfa_mid
    lift_mid=$tempp
    lift_mid=$(echo "$lift_mid"| awk '{printf("%.6f",$0)}')
    echo "lift_mid=$lift_mid"
   

    dist=$(echo "scale=9; ($fixlift - $lift_mid) *($fixlift - $lift_mid) " | bc )
    echo "dist=$dist"
    comp=$(echo "scale=9; $dist > 0.000025" | bc )
    echo "comp=$comp"

    while [ $comp -eq 1 ]
    do
	if [ $(echo "scale=9;  $lift_mid > $fixlift" | bc) -eq 1 ]; then
	alfa_right=$alfa_mid
	else
	alfa_left=$alfa_mid
	fi
        weight=$(echo "scale=9;  ($fixlift - $lift_left)/($lift_right - $lift_left) " | bc)
        alfa_mid=$(echo "scale=9;  (1.0 - $weight) * $alfa_left + $weight * $alfa_right " | bc)
    	#alfa_mid=$(echo "scale=9;  0.5 * $alfa_left + 0.5 * $alfa_right " | bc)
	echo "alfa_left=$alfa_left"
	echo "alfa_mid=$alfa_mid"
	echo "alfa_right=$alfa_right"

    	abc $alfa_mid
	lift_mid=$tempp

	lift_mid=$(echo "$lift_mid"| awk '{printf("%.9f",$0)}')
    	dist=$(echo "scale=9; ($fixlift - $lift_mid) *($fixlift - $lift_mid) " | bc )
	echo "dist=$dist"
    	comp=$(echo "scale=9; $dist > 0.000025" | bc )
    	echo "comp=$comp"
    done
fi


echo "alfa_final=$alfa_mid"
echo "lift_final=$lift_mid"
press=$(tail -1 ${airfoil}_${alfa_mid}deg/result_total_drag_force_${airfoil}_${alfa_mid}deg  | awk  '{print $2}')
CDpress=$(tail -1 ${airfoil}_${alfa_mid}deg/result_total_drag_force_${airfoil}_${alfa_mid}deg  | awk  '{print $5}')
total=$(tail -1 ${airfoil}_${alfa_mid}deg/result_total_drag_force_${airfoil}_${alfa_mid}deg  | awk  '{print $4}')
CDtotal=$(tail -1 ${airfoil}_${alfa_mid}deg/result_total_drag_force_${airfoil}_${alfa_mid}deg  | awk  '{print $7}')

lamlen=$(tail -1 ${airfoil}_${alfa_mid}deg/result_gamma1_${airfoil}_${alfa_mid}deg_transition  | awk  '{print $2}')

moment=$(tail -1 ${airfoil}_${alfa_mid}deg/result_total_moment_${airfoil}_${alfa_mid}deg  | awk  '{print $4}')
CM=$(tail -1 ${airfoil}_${alfa_mid}deg/result_total_moment_${airfoil}_${alfa_mid}deg  | awk  '{print $7}')

echo "Lift $lift_mid" > ${airfoil}_${alfa_mid}deg_lift_press_lam_etc
echo "PreesureDrag $press" >> ${airfoil}_${alfa_mid}deg_lift_press_lam_etc
echo "LaminarLength $lamlen" >> ${airfoil}_${alfa_mid}deg_lift_press_lam_etc
echo "Totaldrag $total" >> ${airfoil}_${alfa_mid}deg_lift_press_lam_etc
echo "Moment $moment" >> ${airfoil}_${alfa_mid}deg_lift_press_lam_etc
echo "Coef de pressuredrag $CDpress" >> ${airfoil}_${alfa_mid}deg_lift_press_lam_etc
echo "Coef de totaldrag $CDtotal" >> ${airfoil}_${alfa_mid}deg_lift_press_lam_etc
echo "Coef de moments $CM" >> ${airfoil}_${alfa_mid}deg_lift_press_lam_etc

echo -e "time consumed: $SECONDS  seconds TOTALLY."


