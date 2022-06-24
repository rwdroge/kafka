
# This PowerShell script downloads the 1.7 version of librdkafka from NuGet
# and extracts the relevant libraries needed by OpenEdge ABL for the
# Windows 64 bit distribution.

$Url = 'https://www.nuget.org/api/v2/package/librdkafka.redist/1.7.0'

$DownloadFolder = 'librdkafka\archive\'

# Location where the .nupkg file is to be stored once downloaded
$DownloadZipFile = $DownloadFolder + 'librdkafka.redist.1.7.0.nupkg'

# Location where the .dll is to be extracted
$ExtractPath = 'librdkafka\libs\'

# Filter to only extract win-x64 version of the libraries from the nupkg
$Nt64Filter = '*win-x64*'
$DllFilter = '*.dll'

# ensure the download folder exists
$exists = Test-Path -Path $DownloadFolder
if ($exists -eq $false)
{
  $null = New-Item -Path $DownloadFolder -ItemType Directory -Force
}

# ensure the output folder exists
$exists = Test-Path -Path $ExtractPath
if ($exists -eq $false)
{
  $null = New-Item -Path $ExtractPath -ItemType Directory -Force
}

# Only download the librdkafka nupkg if it does not already exist
$exists = Test-Path -Path $DownloadZipFile
if ($exists -eq $false)
{
    # download the librdkafka nupkg to the archive folder
    Invoke-RestMethod -Uri $Url -OutFile $DownloadZipFile
}

# load ZIP methods
Add-Type -AssemblyName System.IO.Compression.FileSystem

# open ZIP archive for reading
$zip = [System.IO.Compression.ZipFile]::OpenRead($DownloadZipFile)

# Extract all .dll files in .nupkg for Windows 64 bit
$zip.Entries | 
  Where-Object { $_.FullName -like $DllFilter } |
  Where-Object { $_.FullName -like $Nt64Filter } |
  ForEach-Object { 
    # extract the selected items from the ZIP archive
    # and copy them to the out folder
    $FileName = $_.Name
    [System.IO.Compression.ZipFileExtensions]::ExtractToFile($_, "$ExtractPath/$FileName", $true)
    }
    
# close ZIP file
$zip.Dispose()