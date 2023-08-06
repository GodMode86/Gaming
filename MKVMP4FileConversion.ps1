# Creator: Bang Em
# Version: 2.2 (Remuxes MKV files into MP4)

param (
    [string]$ffmpegPath = "C:\FFMPEG\bin\ffmpeg.exe",
    [string]$inputDir1 = "E:\02-Scene Recordings",
    [string]$inputDir2 = "E:\03-Webcam Recordings",
    [string]$outputDir = "E:\01-Gameplay Editing"
)

# Validate FFmpeg executable path
if (-not (Test-Path $ffmpegPath -PathType Leaf)) {
    Write-Error "FFmpeg executable not found at path: $ffmpegPath"
    return
}

# Validate and create the output directory if it doesn't exist
if (-not (Test-Path $outputDir)) {
    New-Item -ItemType Directory -Path $outputDir | Out-Null
}

# Function to remux MKV file to MP4 format using FFmpeg
function RemuxToMp4($inputFile, $outputFile) {
    $ffmpegArgs = @(
        "-i", $inputFile,
        "-c", "copy",        # Use copy option for remuxing
        $outputFile
    )
    & $ffmpegPath @ffmpegArgs
}

# Get a list of all the MKV files in the input directories
$mkvFiles1 = Get-ChildItem -Path $inputDir1 -Filter "*.mkv" -Force
$mkvFiles2 = Get-ChildItem -Path $inputDir2 -Filter "*.mkv" -Force
$mkvFiles = @($mkvFiles1) + @($mkvFiles2)

# Initialize a counter for successful remuxes
$successCount = 0

# Initialize an array to store error messages
$errors = @()

# Loop through each MKV file and remux to MP4
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
            Write-Warning "Output file $outputFile already exists. Skipping remuxing."
            continue
        }

        # Remux the MKV file into MP4 using FFmpeg
        RemuxToMp4 $inputFile $outputFile

        # Increment the success counter
        $successCount++

        # If verbose mode is enabled, write remuxing details to verbose output
        if ($PSBoundParameters["Verbose"]) {
            Write-Verbose "Remuxed: $inputFile => $outputFile"
        }
    }
    catch {
        # Add the error message to the array
        $errorMessage = "Error remuxing file: $mkvFile`nError: $_"
        Write-Error $errorMessage
        $errors += $errorMessage
    }
}

# Log the remuxing summary
Write-Host "Remuxing completed."
Write-Host "Successful remuxes: $successCount"
Write-Host "Failed remuxes: $($errors.Count)"

# Log any errors encountered
if ($errors.Count -gt 0) {
    Write-Host "Remuxing errors:"
    $errors | ForEach-Object {
        Write-Host $_
    }
}