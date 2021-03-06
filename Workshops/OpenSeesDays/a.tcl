# create the model builder
model Basic -ndm 1 -ndf 1

# create 2 nodes
node 1 0
node 2 0

# fix node 1
fix 1 1

# create material
set Fy 60.0
set E 30000.0
set b 0.1
uniaxialMaterial Steel01 1 $Fy $E $b

# create element
element zeroLength 1 1 2 -mat 1 -dir 1

# create time series and load pattern
timeSeries Linear 1
set P 100.0
pattern Plain 1 1 {
   load 2 $P
}

# create an analysis
constraints Plain
numberer RCM
test NormDispIncr 1.0e-12 6 0
algorithm Newton
system ProfileSPD
integrator LoadControl 0.1
analysis Static

# perform the analysis
analyze 10

# Output
print node 2

set exact [expr $Fy/$E + ($P-$Fy)/($b*$E)]
set res [lindex [nodeDisp 2] 0]
if {$exact == $res} {
    puts "Exact ($exact) EQUALS Result ($res)"
} else {
    puts "Exact ($exact) IS NOT EQUAL TO Result ($res)"
}