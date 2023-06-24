#Creator: Sean Berry-Pavaday
#Version 1.0

#Moves .mp4 files which are bigger than 6GB but under 100GB and moves them into the Gameplay To Be Edited folder on Redroom fileshare.
#====================================================================================================================

Get-ChildItem "E:\01-Gameplay Editing\*.mp4" | 
        Where-Object { $_.Length -gt 6000000KB -and $_.Length -lt 100000000KB} |
        Move-Item -Destination "R:\09-Footage\Gameplay To Be Edited" -force

        