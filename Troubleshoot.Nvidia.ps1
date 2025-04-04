### --- https://enterprise-support.nvidia.com/s/article/GPU-Utilization-using-NVSMI

### --- GPU UTILIZATION USING NVSMI
nvidia-smi -q -d utilization
Nvidia-smi encodersessions
dxdiag
$nvlog="c:\Users\Public\Documents\NvidiaLogging\Log.NVDisplay.Container.exe.log"
$nvlog=c:\"Program Files"\"NVIDIA Corporation"\NVSMI\nvidia-smi.exe -q
$nvlog | select-string "licen"


Get-CimInstance -class Win32_VideoController  |select Driverversion


### ---https://enterprise-support.nvidia.com/s/article/How-to-guide-Using-nvidia-smi-on-host-to-monitor-GPU-behavior-with-vGPU-and-outputting-to-csv-format
./nvidia-smi --query-gpu=timestamp,name,pci.bus_id,driver_version,pstate,pcie.link.gen.max,pcie.link.gen.current,temperature.gpu,utilization.gpu,utilization.memory,memory.total,memory.free,memory.used --format=csv -l 1 

### --- https://webglsamples.org/aquarium/aquarium.html
