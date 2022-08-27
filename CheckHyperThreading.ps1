# Script closely based on :
# http://jeffwouters.nl/index.php/2016/10/powershell-is-hyperthreading-enabled/
# Adding multiple computers and Foreach loop, as well as progress bar
# Adding example to add computer names from file, and from GEt-ExchangeServer (if so, need to run from Exchange Management Shell)

# Define variables
$ComputerNames = "E2016-01", "E2016-02"
# To query from computers list in file:
#           $ComputerNames = Get-Content C:\scripts\ComputerNames.txt
# To query from Exchange computers !need to run the script from an Exchange Management Console! :
#          $ComputerNames = $(Get-ExchangeServer | Foreach {$_.Name})

$Counter = 0
$Collection = @()
Foreach ($ComputerName in $ComputerNames){
    $Counter++
    Write-Progress -Activity "Querying computers with WMI" -Status "Querying $ComputerName" -Id 1 -PercentComplete $($Counter/($ComputerNames.Count)*100)
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
        ComputerName = $ComputerName
        LogicalCPU  = $LogicalCPU
        PhysicalCPU = $PhysicalCPU
        CoreNr      = $Core
        HyperThreading = $($LogicalCPU -gt $PhysicalCPU)

    }
    #Output the object
    $Collection += New-Object -TypeName PSObject -Property $Hash
}

$Collection | ft ComputerName, LogicalCPU, PysicalCPU, HyperThreading, CoreNr
