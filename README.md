# AnsysFluent17.0JouForFixedLiftCal
This repository provides .jou scripts in  Ansys Fluent 17.0 for obtaining aerodynamic performance (lift force, transition position,etc.) under fixed lift.

## prep_1proc_sample.jou
This journal is an example for importing a plot3d mesh, cutting the boudanry conditions, and set the types for them.
The cutting involves the distribution of cores/processes designated by  jog users, so I apply only 1 core for this jou, and  applying any number of cores for the <cal_anyproc_sample.jou> for initialization and calculation.

## cal_anyproc_sample.jou
Initialization and calculation.

## prep_cal.sh
This is the bash file calling the jou files. They do the CFD work and some raw post-processing.

## mffoil03
This is the file that has the information of the cores to be called. It is thought to be put at my desktop, which /home/user03/
The content of it is simply a line: ibcn03:20

## seek_solution_Dichotomy.sh
This file dominates the process of find the corresponding angle of attack to the fixed lift.

## seek_solution_Dichotomy_test.sh
this file tests the bash scripts for dichotomy.

## seek_solution_steptrying.s
This file illustrates the necessity of dicotomy.

## ~.xyz
the mesh file of rae2822 benchmark case

## thought on convergence criterion
### physially...
For lift fixed at 0.8234 (of course it has to be multiplied with the reference length 0.4 due to the ignorance of my refernece value setting in fluent panel), it has four effective digits.
Its toleranceis 4e-4 (w.r.t. absolute perspective).
The amplitude for the calculated  CFD result for the current mesh pattern is appr. 8e-4.
In order to contain the correct answer even when it is at its phase that is most far from the fixed lift value,  
the error should be the sum of the above two.
Since the practical error is in squared form, the dist in the code should be 1.44e-10 less than before stopping iteration.
Let us make it 5e-8 !

### digital accuracy...
for initial values, the effective digits we want for the angle is 4, for example.
For dichotomy, in order to get 3 times 1000 accuracy, we need to fold the piece in two for  12 times, because 2^12 > 3000
