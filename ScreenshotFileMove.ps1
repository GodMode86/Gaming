#Creator: Sean Berry-Pavaday
#Version 1.0

#Moves screenshots (.png) taken via OBS Studio, to folder on file server.
#====================================================================================================================

Get-ChildItem "E:\01-Gameplay Editing\*.png" | 
         Move-Item -Destination 'E:\06-Screenshots' -force

        