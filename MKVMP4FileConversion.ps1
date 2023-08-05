#Creator: Sean Berry-Pavaday
#Version 2.0

#Converts MKV files into MP4 and deletes the original MKV once conversion is complete.
#====================================================================================================================

param (
    [string]$ffmpegPath = "C:\FFMPEG\bin\ffmpeg.exe",
    [string]$inputDir1 = "E:\02-Scene Recordings",
    [string]$inputDir2 = "E:\03-Webcam Recordings",
    [string]$outputDir = "E:\01-Gameplay Editing"
)

# Validate and create the output directory if it doesn't exist
if (-not (Test-Path $outputDir)) {
    New-Item -ItemType Directory -Path $outputDir | Out-Null
}

# Get a list of all the MKV files in the first input directory
$mkvFiles1 = Get-ChildItem -Path $inputDir1 -Filter "*.mkv" -Force

# Get a list of all the MKV files in the second input directory
$mkvFiles2 = Get-ChildItem -Path $inputDir2 -Filter "*.mkv" -Force

# Combine the two lists of MKV files
$mkvFiles = @($mkvFiles1) + @($mkvFiles2)

# Initialize a counter for successful conversions
$successCount = 0

# Initialize an array to store error messages
$errors = @()

# Loop through each MKV file
foreach ($mkvFile in $mkvFiles) {
    try {
        # Get the base file name without the extension
        $baseName = [System.IO.Path]::GetFileNameWithoutExtension($mkvFile)

        # Set the input file path
        $inputFile = $mkvFile.FullName

        # Set the output file path
        $outputFile = "$outputDir\$baseName.mp4"

        # Check if the output file already exists
        if (Test-Path $outputFile) {
            Write-Host "Output file $outputFile already exists. Skipping conversion." -ForegroundColor Yellow
            continue
        }

        # Remux the MKV file into MP4 using FFmpeg
        & $ffmpegPath -i $inputFile -c copy $outputFile

        # Delete the original MKV file
        Remove-Item $inputFile

        # Increment the success counter
        $successCount++
    }
    catch {
        # Add the error message to the array
        $errors += "Error converting file: $mkvFile`nError: $_"
    }
}

# Log the conversion summary
Write-Host "Conversion completed." -ForegroundColor Green
Write-Host "Successful conversions: $successCount"
Write-Host "Failed conversions: $($errors.Count)"

# Log any errors encountered
if ($errors.Count -gt 0) {
    Write-Host "Conversion errors:"
    $errors | ForEach-Object {
        Write-Host $_
    }
}
