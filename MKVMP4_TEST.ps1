# Creator: Bang Em
# Version 2.5

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

# Function to execute FFmpeg command with improved settings
function ConvertToMp4($inputFile, $outputFile) {
    $videoBitrate = "150000k"   # Set the video bitrate (adjust as needed)
    $audioBitrate = "320k"    # Set the audio bitrate (adjust as needed)
    $preset = "medium"        # Set the preset (options: ultrafast, superfast, veryfast, faster, fast, medium, slow, slower, veryslow)

    $ffmpegArgs = @(
        "-i", $inputFile,
        "-c:v", "h264_nvenc", # Use NVIDIA GPU-accelerated codec (if available)
        "-b:v", $videoBitrate,
        "-minrate", $videoBitrate,
        "-maxrate", $videoBitrate,
        "-bufsize", "150000k",   # Buffer size for CBR
        "-preset", $preset,
        "-c:a", "aac",
        "-b:a", $audioBitrate,
        "-strict", "experimental",
        $outputFile
    )
    & $ffmpegPath @ffmpegArgs
}

# Get a list of all the MKV files in the input directories
$mkvFiles1 = Get-ChildItem -Path $inputDir1 -Filter "*.mkv" -Force
$mkvFiles2 = Get-ChildItem -Path $inputDir2 -Filter "*.mkv" -Force
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
            Write-Warning "Output file $outputFile already exists. Skipping conversion."
            continue
        }

        # Remux the MKV file into MP4 using FFmpeg
        ConvertToMp4 $inputFile $outputFile

        # Delete the original MKV file
        #Remove-Item $inputFile -Force

        # Increment the success counter
        $successCount++

        # If verbose mode is enabled, write conversion details to verbose output
        if ($PSBoundParameters["Verbose"]) {
            Write-Verbose "Converted: $inputFile => $outputFile"
        }
    }
    catch {
        # Add the error message to the array
        $errorMessage = "Error converting file: $mkvFile`nError: $_"
        Write-Error $errorMessage
        $errors += $errorMessage
    }
}

# Log the conversion summary
Write-Host "Conversion completed."
Write-Host "Successful conversions: $successCount"
Write-Host "Failed conversions: $($errors.Count)"

# Log any errors encountered
if ($errors.Count -gt 0) {
    Write-Host "Conversion errors:"
    $errors | ForEach-Object {
        Write-Host $_
    }
}