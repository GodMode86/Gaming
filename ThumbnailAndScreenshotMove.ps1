#Creator: Sean Berry-Pavaday
#Version 1.0

#Moves screenshots (.png) taken via OBS Studio, to folder on file server.
#====================================================================================================================

# Set the source and destination paths
$srcFolder1 = "E:\05-Thumbnails"
$srcFolder2 = "E:\06-Screenshots"
$dstFolder1 = "R:\04-Thumbnails"
$dstFolder2 = "R:\07-Screenshots"

# Get a list of all files in the source folders
$files1 = Get-ChildItem $srcFolder1 -Recurse
$files2 = Get-ChildItem $srcFolder2 -Recurse

# Move the files from the first source folder to the first destination folder
foreach ($file in $files1) {
  Move-Item -Path $file.FullName -Destination $dstFolder1 -Force
}

# Move the files from the second source folder to the second destination folder
foreach ($file in $files2) {
  Move-Item -Path $file.FullName -Destination $dstFolder2 -Force
}
