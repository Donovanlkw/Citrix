### --- last reboot time / Regirstion --- ###
 $x = get-brokerdesktop -ostype *201*
 $x |select LastDeregistrationReason, LastDeregistrationTime, MachineName, ostype
