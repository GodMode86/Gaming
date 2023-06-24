# Set the source folders to scan
$srcFolders = @("E:\01-Gameplay Editing", "E:\02-Scene Recordings", "E:\03-Webcam Recordings")

# Set the destination folder
$dstFolder = "E:\01-Gameplay Editing\Clips"

# Set the minimum and maximum file sizes
$minSize = 10MB
$maxSize = 3GB

# Iterate through the source folders
foreach ($srcFolder in $srcFolders) {
    # Get all the .mkv files in the source folder
    $files = Get-ChildItem -Path $srcFolder -Include "*.mkv" -File
    
    # Iterate through the files
    foreach ($file in $files) {
        # Check if the file size is between the minimum and maximum sizes
        if (($file.Length -gt $minSize) -and ($file.Length -lt $maxSize)) {
            # Move the file to the destination folder
            Move-Item -Path $file.FullName -Destination $dstFolder
            
            # Get the new path of the file
            $newFile = Join-Path -Path $dstFolder -ChildPath $file.Name
            
            # Convert the file from .mkv to .mp4
            Start-Process -FilePath "C:\Program Files\FFMPEG\bin\ffmpeg.exe" -ArgumentList "-i $newFile -c:v libx264 -c:a aac -strict -2 $newFile.mp4" -NoNewWindow -Wait
            
            # Delete the original file
            Remove-Item -Path $newFile -Force
        }
    }
}
