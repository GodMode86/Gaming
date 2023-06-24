$path = "E:\test"

$ffmpeg = "C:\Program Files\FFMPEG\bin\ffmpeg.exe"

# Get all .mkv, .mp4, and .mov files in the specified path and its subfolders
$items = Get-ChildItem $path -Recurse | Where-Object { !$_.PSIsContainer -and $_.Extension -in '.mkv', '.mp4', '.mov', '.webm' }

# Loop through each file and reduce its size
foreach ($item in $items) {
    # Reduce the file size
    ffmpeg -i $item.FullName -vcodec h264 -acodec aac -strict -2 "$($item.FullName).new"

    # Delete the original file
    Remove-Item $item.FullName -Force

    # Rename the compressed file
    Rename-Item "$($item.FullName).new" $item.FullName
}
