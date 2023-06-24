#Creator: Sean Berry-Pavaday
#Version 1.0

#Moves youtube shorts that are on my studio drive onto my file server (long term storage)
#====================================================================================================================

# Set the source and destination paths
$srcFolder1 = "E:\08-YouTube Short Form Upload"
$dstFolder1 = "R:\09-Footage"


# Get a list of all files in the source folders
$files1 = Get-ChildItem $srcFolder1 -Recurse

# Move the files from the first source folder to the first destination folder
foreach ($file in $files1) {
  Move-Item -Path $file.FullName -Destination $dstFolder1 -Force
}
