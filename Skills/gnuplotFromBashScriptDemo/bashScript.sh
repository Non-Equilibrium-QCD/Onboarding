### This bash script creates a plot script to be executed by gnuplot and then executes it ###

#making sure there's no old version to clash what's going to be put into the plot script
rm gnuplotScript.plot

#setting different constants needed for the plot, these parameters are the same for all data files
gamma=0.1
mSqr=-4.811
T=1.0


#defining the different point types for different system sizes N
pointType[32]=2
pointType[48]=3
pointType[64]=4
pointType[96]=5
pointType[128]=6
pointType[256]=7


#List of parameters J and N for which data will be plotted
J[1]=0.5
N[1]=32	
J[2]=0.5
N[2]=64
J[3]=0.2
N[3]=32
J[4]=0.2
N[4]=64
J[5]=0.05
N[5]=64
J[6]=0.05
N[6]=128
J[7]=0.02
N[7]=64
J[8]=0.02
N[8]=128
J[9]=0.005
N[9]=64
J[10]=0.005
N[10]=128
J[11]=0.002
N[11]=64
J[12]=0.002
N[12]=128
J[13]=0.0005
N[13]=64
J[14]=0.0005
N[14]=128
J[15]=0.0005
N[15]=256
J[16]=0.001
N[16]=64	
J[17]=0.001
N[17]=128
J[18]=0.0002
N[18]=128
J[19]=0.0002
N[19]=256
J[20]=0.0001
N[20]=128
J[21]=0.0001
N[21]=256

paramListStart=1
paramListEnd=21

#some setup for the plot, labels, name and type of the output file, etc	
echo "reset " >> gnuplotScript.plot
echo "set encoding utf8" >> gnuplotScript.plot
echo "set autoscale" >> gnuplotScript.plot
echo "set auto" >> gnuplotScript.plot
echo "set key horizontal outside t c" >> gnuplotScript.plot
echo "set term png font 'arial,20' nocrop enhanced size 1200,800" >> gnuplotScript.plot
echo "set xlabel 't/a_s'" >> gnuplotScript.plot
echo "set pointsize 1.5" >> gnuplotScript.plot
echo "set output 'plots/rhoPiLogx.png'" >> gnuplotScript.plot
echo "set log x" >> gnuplotScript.plot
echo "set xr [0.1:1000]" >> gnuplotScript.plot


#color scale
# start value for H
##PURPLE## echo "h1 = 270/360.0" >> gnuplotScript.plot
echo "h2 = 0/360.0" >> gnuplotScript.plot
# end value for H
##PURPLE## echo "h2 = 300/360.0" >> gnuplotScript.plot
echo "h1 = 270/360.0" >> gnuplotScript.plot
# creating the palette by specifying H,S,V
echo "set palette model HSV functions (1-gray)*(h2-h1)+h1,1,0.68" >> gnuplotScript.plot
#echo "unset cbtics" >> gnuplotScript.plot
echo "set logscale cb" >> gnuplotScript.plot

#some labels in the plot
echo "set label 7 at screen 0.2,0.8 'Model G'  font 'Arial,30'" >> gnuplotScript.plot
echo "set label 2 at screen 0.92,0.92 'J'" >> gnuplotScript.plot
echo "set label 8 at screen 0.2,0.9 'ρ_π'  font 'Arial,30'" >> gnuplotScript.plot

### HERE THE ACTUAL PLOTTING BEGINS ###

#invisible plot, start of the plot command	
echo -n "p 1/0 notitle ," >> gnuplotScript.plot

#invisible plots, to show which point type corresponds to which system size N
for N in 32 64 128 256
do
	echo -n " '+' u 1:(1/0) pt ${pointType[${N}]} lc 0 t 'N=${N}' ," >> gnuplotScript.plot
done

#plotting the actual data
for paramSet in $(seq ${paramListStart} ${paramListEnd})
do	
	N=${N[${paramSet}]}
	J=${J[${paramSet}]}
	
	echo -n " 'dataFiles/RhoAvgN${N}g${gamma}mSqr${mSqr}J${J}T${T}' every 5 u 1:((\$4 + \$6 + \$8)/3.0):(sqrt(\$5**2+\$7**2+\$9**2)/ 3.0):(${J}) w ye pt ${pointType[${N}]} lc palette notitle, " >> gnuplotScript.plot			
done 	

#invisible plot to not have a trailing "," in the plot command	
echo "1/0 notitle" >> gnuplotScript.plot

#run the plot script and then remove it
gnuplot gnuplotScript.plot
rm gnuplotScript.plot