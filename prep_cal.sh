#!/bin/bash

knot=$1
FOILNAME=$2
alfa=$3


echo "Begins calculating $FOILNAME "
echo "alfa_in_deg=$alfa"
alpha=`echo "scale=8;r=$alfa;r/180.0*3.1415926535898"|bc -l`
echo "alfa_in_rad=$alpha"
SIN=`echo "scale=5;r=$alpha;s(r/2.0)"|bc -l`
echo $SIN
COS=`echo "scale=5;r=$alpha;c(r/3.0)"|bc -l`
echo $COS

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
fluent -cnf=$knot -i cal_anyproc_${FOILNAME}_${alfa}deg.jou -t15 2ddp

ECHO "Ends calculating $FOILNAME "
