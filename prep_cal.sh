#!/bin/bash

knot=$1
FOILNAME=$2
alfa=$3

echo "Begins calculating $FOILNAME"
echo "alfa_in_deg=$alfa"
alpha=`echo "scale=8;r=$alfa;r/180.0*3.1415926535898"|bc -l`
SIN=`echo "scale=5;r=$alpha;s(r/2.0)"|bc -l`
COS=`echo "scale=5;r=$alpha;c(r/3.0)"|bc -l`

cp prep_1proc_sample.jou prep_1proc_$FOILNAME.jou
sed -i "s/FOILNAME/$FOILNAME/g" prep_1proc_$FOILNAME.jou
fluent -cnf=$knot -i prep_1proc_$FOILNAME.jou -t1 2ddp

cp cal_anyproc_sample.jou cal_anyproc_${FOILNAME}_${alfa}deg.jou
sed -i "s/FOILNAME/$FOILNAME/g" cal_anyproc_${FOILNAME}_${alfa}deg.jou
sed -i "s/AOA/$alfa/g" cal_anyproc_${FOILNAME}_${alfa}deg.jou
sed -i "s/COS/$COS/g" cal_anyproc_${FOILNAME}_${alfa}deg.jou
sed -i "s/SIN/$SIN/g" cal_anyproc_${FOILNAME}_${alfa}deg.jou

mkdir ${FOILNAME}_${alfa}deg
cp ${FOILNAME}prep.cas ${FOILNAME}_${alfa}deg/
cp cal_anyproc_${FOILNAME}_${alfa}deg.jou ${FOILNAME}_${alfa}deg/
cd ${FOILNAME}_${alfa}deg/
fluent -cnf=$knot -i cal_anyproc_${FOILNAME}_${alfa}deg.jou -t18 2ddp

#create file recording laminar length
lines=$(wc -l result_gamma1_${FOILNAME}_${alfa}deg  | awk  '{print $1}' )
sort -g -k 2 -t "," result_gamma1_${FOILNAME}_${alfa}deg  > result_gamma1_${FOILNAME}_${alfa}deg_inverse
trans=0.0
inter=0.0
no=0
for (( i = 35; i < $lines; i++ ));do
     #echo $i
     term=$(sed -n ${i}p result_gamma1_${FOILNAME}_${alfa}deg_inverse | awk -F ',' '{print $4}')
     term=$(echo "$term"| awk '{printf("%.9f",$0)}')
     #echo "inter=$term"

     if [ $(echo "scale=9;  $term > 0.500" | bc) -eq 1 ]; then
	inter=$term
	no=$(sed -n ${i}p result_gamma1_${FOILNAME}_${alfa}deg_inverse | awk -F ',' '{print $1}')
	trans=$(sed -n ${i}p result_gamma1_${FOILNAME}_${alfa}deg_inverse | awk -F ',' '{print $2}')
	trans=$(echo "$trans"| awk '{printf("%.9f",$0)}')
	inter=$(echo "$inter"| awk '{printf("%.9f",$0)}')
	break
     fi
done 

echo "no: $no"> result_gamma1_${FOILNAME}_${alfa}deg_transition
echo "intermittency: $inter" >> result_gamma1_${FOILNAME}_${alfa}deg_transition
echo "transition: $trans" >> result_gamma1_${FOILNAME}_${alfa}deg_transition
echo "Ends calculating $FOILNAME"
echo -e "TIME used in this CFD case   $SECONDS  seconds"
