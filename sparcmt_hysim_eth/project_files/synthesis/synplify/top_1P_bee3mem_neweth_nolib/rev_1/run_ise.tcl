#########################
###  DEFINE VARIABLES ###
#########################
set DesignName	"cpu_top"
set FamilyName	"VIRTEX5"
set DeviceName	"XC5VLX110T"
set PackageName	"FF1136"
set SpeedGrade	"-1"
set TopModule	"fpga_top"
set EdifFile	"cpu_top.edf"
if {![file exists $DesignName.ise]} {

project new $DesignName.ise

project set family $FamilyName
project set device $DeviceName
project set package $PackageName
project set speed $SpeedGrade

xfile add $EdifFile
if {[file exists synplicity.ucf]} {
    xfile add synplicity.ucf
}

project set "Netlist Translation Type" "Timestamp"
project set "Other NGDBuild Command Line Options" "-verbose"
project set "Generate Detailed MAP Report" TRUE

project close
}


file delete -force $DesignName\_xdb

project open $DesignName.ise

process run "Implement Design" -force rerun_all

project close

