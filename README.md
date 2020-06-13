# AnsysFluent17.0JouForFixedLiftCal
This repository provides .jou scripts in  Ansys Fluent 17.0 for obtaining aerodynamic performance (lift force, transition position,etc.) under fixed lift.

## prep_1proc_sample.jou
This journal is an example for importing a plot3d mesh, cutting the boudanry conditions, and set the types for them.
The cutting involves the distribution of cores/processes designated by  jog users, so I apply only 1 core for this jou, and  applying any number of cores for the <cal_anyproc_sample.jou> for initialization and calculation.

## cal_anyproc_sample.jou
Initialization and calculation.
The convergence criterion of lift and drag coefficient is a realative ratio. Therefore, the absolute deviation is varified due to different angles of attack. The number now is a product of compromise.

## prep_cal.sh
This is the bash file calling the jou files. They do the CFD work and some raw post-processing.

## mffoil03
This is the file that has the information of the cores to be called. It is thought to be put at my desktop, which /home/user03/
The content of it is simply a line: ibcn03:20

## seek_solution_Dichotomy.sh
This file dominates the process of find the corresponding angle of attack to the fixed lift.
The dichotomy is modified with weights since before separation, the Cl-alpha curve should be monotonically increasing with angle of attack.

## seek_solution_Dichotomy_test.sh
this file tests the bash scripts for dichotomy.

## seek_solution_steptrying.s
This file illustrates the necessity of dicotomy.

## ~.xyz
the mesh file of rae2822 benchmark case

## thought on convergence criterion
For lift fixed at 0.824, it has three effective digits.
Its toleranceis 5e-4 (w.r.t. absolute perspective).
Since the practical error is in squared form, the dist in the code should be 2.5e-07 less than before stopping iteration.

 
