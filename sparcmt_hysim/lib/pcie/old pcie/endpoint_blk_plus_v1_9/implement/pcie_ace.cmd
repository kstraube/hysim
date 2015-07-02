setMode -acecf
addCollection -name "config"
addDesign -version 6 -name "rev6"
addDeviceChain -index 0
setCurrentDesign -version 6
setCurrentDeviceChain -index 0
addDevice -p 1 -file "./results/routed.bit"
generate -active config
quit