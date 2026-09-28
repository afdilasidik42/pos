Add-Type -AssemblyName System.Drawing

$images = Get-ChildItem 'd:\job\pos\assets\KOPI\*.png' | Sort-Object Name
$dict = [ordered]@{}
$encoder = [System.Drawing.Imaging.ImageCodecInfo]::GetImageEncoders() | Where-Object { $_.FormatDescription -eq 'JPEG' }
$encoderParams = New-Object System.Drawing.Imaging.EncoderParameters(1)
$encoderParams.Param[0] = New-Object System.Drawing.Imaging.EncoderParameter([System.Drawing.Imaging.Encoder]::Quality, [long]78)

$index = 1
foreach ($f in $images) {
    $img = [System.Drawing.Image]::FromFile($f.FullName)
    $targetSize = 480
    $bmp = New-Object System.Drawing.Bitmap($targetSize, $targetSize)
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
    $g.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
    $g.DrawImage($img, 0, 0, $targetSize, $targetSize)
    
    $ms = New-Object System.IO.MemoryStream
    $bmp.Save($ms, $encoder, $encoderParams)
    $bytes = $ms.ToArray()
    $b64 = [Convert]::ToBase64String($bytes)
    $dict["img$index"] = "data:image/jpeg;base64,$b64"
    Write-Output ("Processed img$index : " + [math]::Round($bytes.Length/1024, 1) + " KB")
    
    $ms.Dispose()
    $bmp.Dispose()
    $g.Dispose()
    $img.Dispose()
    $index++
}

$dict | ConvertTo-Json -Compress | Set-Content -Encoding UTF8 'd:\job\pos\assets_base64.json'
Write-Output "Successfully generated assets_base64.json"
