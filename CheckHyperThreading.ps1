# Script taken from :
# http://jeffwouters.nl/index.php/2016/10/powershell-is-hyperthreading-enabled/
# Putting it here for quick retrieve (and in case the page disappears :) )

# Define variables
$ComputerName = $env:COMPUTERNAME
$LogicalCPU = 0
$PhysicalCPU = 0
$Core = 0

# Get the Processor information from the WMI object
$Proc = [object[]]$(get-WMIObject Win32_Processor -ComputerName $ComputerName)
 
#Perform the calculations
$Core = $Proc.count
$LogicalCPU = $($Proc | measure-object -Property NumberOfLogicalProcessors -sum).Sum
$PhysicalCPU = $($Proc | measure-object -Property NumberOfCores -sum).Sum
#Build the object
$Hash = @{
    LogicalCPU  = $LogicalCPU
    PhysicalCPU = $PhysicalCPU
    CoreNr      = $Core
    HyperThreading = $($LogicalCPU -gt $PhysicalCPU)

}
#Output the object
New-Object -TypeName PSObject -Property $Hash
