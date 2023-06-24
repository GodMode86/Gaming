# Set the source and destination folders
$sourceFolder1 = "E:\02-Scene Recordings"
$sourceFolder2 = "E:\03-Webcam Recordings"
$sourceFolder3 = "E:\01-Gameplay Editing"
$destinationFolder = "E:\01-Gameplay Editing\Clips"

# Get all files in the source folders that are smaller than 3GB and larger than 10MB
$files = (Get-ChildItem $sourceFolder1 -Recurse -File) + (Get-ChildItem $sourceFolder2 -Recurse -File) + (Get-ChildItem $sourceFolder3 -File) | Where-Object {$_.Length -gt 10MB -and $_.Length -lt 3GB}

# Loop through the files and move them to the destination folder
foreach ($file in $files)
 {
   #convert the file from .mkv to .mp4 and delete the original files once completed.
  $destinationFile = Join-Path $destinationFolder ($file.Name -replace ".mkv",".mp4")
  C:\FFMPEG\bin\ffmpeg.exe -i $file.FullName -c:a aac -c:v libx264 -q:v 0 -preset ultrafast $destinationFile
  Remove-Item $file.FullName
}







