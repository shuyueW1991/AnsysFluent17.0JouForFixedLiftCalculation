# AnsysFluent17.9JouAndFixedLiftCal
This repository provides cumulative jou script for Ansys Fluent 17.0 during my work.And how do I calculate aerodynamics under fixed lift.

## prep_1proc_sample.jou
This journal is an example for importing a plot3d mesh, cutting the boudanry conditions, and set the types for them.
The cutting involves the distribution of cores/processes designated by  jog users, so I apply only 1 core for this jou, and  applying any number of cores for the <cal_anyproc_sample.jou> for initialization and calculation.

## cal_anyproc_sample.jou
Initialization and calculation.

## prep_cal.sh
This is the bash file calling the jou files.

## mffoil03
This is the file that has the information of the cores to be called. It is thought to be put at my desktop, which /home/user03/



## ~.xyz
the mesh file of rae2822 benchmark case

