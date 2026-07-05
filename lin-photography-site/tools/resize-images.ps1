<#
  Photo resize/compress utility.
  To replace photos later, add entries to the $jobs array below
  (source file, output file, max long edge in px, JPEG quality 1-100)
  and run: powershell -ExecutionPolicy Bypass -File tools\resize-images.ps1
#>

Add-Type -AssemblyName System.Drawing

function Resize-Photo {
    param(
        [string]$SrcPath,
        [string]$DestPath,
        [int]$MaxDim,
        [int]$Quality = 82
    )

    if (-not (Test-Path $SrcPath)) {
        Write-Warning "Not found: $SrcPath"
        return
    }

    $srcBytes = [System.IO.File]::ReadAllBytes($SrcPath)
    $ms = New-Object System.IO.MemoryStream(,$srcBytes)
    $img = [System.Drawing.Image]::FromStream($ms)

    # Correct orientation using EXIF tag 0x0112
    $orientationId = 0x0112
    if ($img.PropertyIdList -contains $orientationId) {
        $prop = $img.GetPropertyItem($orientationId)
        $val = [int]$prop.Value[0]
        switch ($val) {
            3 { $img.RotateFlip([System.Drawing.RotateFlipType]::Rotate180FlipNone) }
            6 { $img.RotateFlip([System.Drawing.RotateFlipType]::Rotate90FlipNone) }
            8 { $img.RotateFlip([System.Drawing.RotateFlipType]::Rotate270FlipNone) }
            default { }
        }
    }

    $w = $img.Width
    $h = $img.Height
    $scale = [Math]::Min(1.0, $MaxDim / [Math]::Max($w, $h))
    $newW = [Math]::Max(1, [int]([Math]::Round($w * $scale)))
    $newH = [Math]::Max(1, [int]([Math]::Round($h * $scale)))

    $isPng = [System.IO.Path]::GetExtension($DestPath).ToLower() -eq ".png"
    $pixelFormat = if ($isPng) { [System.Drawing.Imaging.PixelFormat]::Format32bppArgb } else { [System.Drawing.Imaging.PixelFormat]::Format24bppRgb }

    $bmp = New-Object System.Drawing.Bitmap($newW, $newH, $pixelFormat)
    $bmp.SetResolution($img.HorizontalResolution, $img.VerticalResolution)
    $gfx = [System.Drawing.Graphics]::FromImage($bmp)
    $gfx.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $gfx.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
    $gfx.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
    if (-not $isPng) {
        $gfx.Clear([System.Drawing.Color]::White)
    }
    $gfx.DrawImage($img, 0, 0, $newW, $newH)
    $gfx.Dispose()

    $destDir = Split-Path $DestPath -Parent
    if (-not (Test-Path $destDir)) { New-Item -ItemType Directory -Force -Path $destDir | Out-Null }

    if ($isPng) {
        $bmp.Save($DestPath, [System.Drawing.Imaging.ImageFormat]::Png)
    } else {
        $codec = [System.Drawing.Imaging.ImageCodecInfo]::GetImageEncoders() | Where-Object { $_.MimeType -eq 'image/jpeg' }
        $encParams = New-Object System.Drawing.Imaging.EncoderParameters(1)
        $encParams.Param[0] = New-Object System.Drawing.Imaging.EncoderParameter([System.Drawing.Imaging.Encoder]::Quality, [long]$Quality)
        $bmp.Save($DestPath, $codec, $encParams)
    }

    $bmp.Dispose()
    $img.Dispose()
    $ms.Dispose()

    $origKB = [Math]::Round($srcBytes.Length / 1KB)
    $newKB = [Math]::Round((Get-Item $DestPath).Length / 1KB)
    Write-Output "$([System.IO.Path]::GetFileName($DestPath)): ${w}x${h} -> ${newW}x${newH}  ${origKB}KB -> ${newKB}KB"
}

$src = "C:\Users\user\Desktop\りんくんホームページ"
$out = "C:\Users\user\Desktop\lin-photography-site\assets\img"

$jobs = @(
    # Home slideshow, long edge 2400px
    @("$src\ホーム写真\１.jpg", "$out\home-1.jpg", 2400, 80),
    @("$src\ホーム写真\２.jpg", "$out\home-2.jpg", 2400, 80),
    @("$src\ホーム写真\３.JPG", "$out\home-3.jpg", 2400, 80),
    @("$src\ホーム写真\４.JPG", "$out\home-4.jpg", 2400, 80),
    @("$src\ホーム写真\５.JPG", "$out\home-5.jpg", 2400, 80),
    @("$src\ホーム写真\６.JPG", "$out\home-6.jpg", 2400, 80),
    @("$src\ホーム写真\７.jpg", "$out\home-7.jpg", 2400, 80),
    @("$src\ホーム写真\８.JPG", "$out\home-8.jpg", 2400, 80),
    @("$src\ホーム写真\９.jpg", "$out\home-9.jpg", 2400, 80),
    @("$src\ホーム写真\１０.jpg", "$out\home-10.jpg", 2400, 80),
    @("$src\ホーム写真\１１.jpg", "$out\home-11.jpg", 2400, 80),
    @("$src\ホーム写真\１２.jpg", "$out\home-12.jpg", 2400, 80),
    @("$src\ホーム写真\１３.jpg", "$out\home-13.jpg", 2400, 80),
    @("$src\ホーム写真\１４.jpg", "$out\home-14.jpg", 2400, 80),

    # Craft / work-in-progress photos: 1-3 portrait, 4 landscape
    @("$src\手仕事写真\１.jpg", "$out\craft-1.jpg", 1600, 82),
    @("$src\手仕事写真\２.jpg", "$out\craft-2.jpg", 1600, 82),
    @("$src\手仕事写真\３.jpg", "$out\craft-3.jpg", 1600, 82),
    @("$src\手仕事写真\４.JPG", "$out\craft-4.jpg", 1900, 82),

    # Artwork photos
    @("$src\作品写真\１.jpg", "$out\works-1.jpg", 1600, 82),
    @("$src\作品写真\２.JPG", "$out\works-2.jpg", 1600, 82),
    @("$src\作品写真\３.jpg", "$out\works-3.jpg", 1600, 82),
    @("$src\作品写真\４.jpg", "$out\works-4.jpg", 1900, 82),

    # Coming-of-age photos
    @("$src\成人式写真\１.jpg", "$out\seijin-1.jpg", 1600, 82),
    @("$src\成人式写真\２.jpg", "$out\seijin-2.jpg", 1600, 82),
    @("$src\成人式写真\3.jpg", "$out\seijin-3.jpg", 1600, 82),
    @("$src\成人式写真\４.jpg", "$out\seijin-4.jpg", 1900, 82),

    # Landscape photos
    @("$src\風景\１.jpg", "$out\landscape-1.jpg", 1600, 82),
    @("$src\風景\２.jpg", "$out\landscape-2.jpg", 1600, 82),
    @("$src\風景\３.JPG", "$out\landscape-3.jpg", 1600, 82),
    @("$src\風景\４.jpg", "$out\landscape-4.jpg", 1900, 82),

    # Images accompanying the 4 description texts
    @("$src\解説画像\手仕事.jpg", "$out\explain-craft.jpg", 1600, 80),
    @("$src\解説画像\作品写真.jpg", "$out\explain-works.jpg", 1600, 80),
    @("$src\解説画像\成人式写真.jpg", "$out\explain-seijin.jpg", 1600, 80),
    @("$src\解説画像\風景写真.jpg", "$out\explain-landscape.jpg", 1600, 80),

    # Profile photo
    @("$src\本人写真.jpg", "$out\profile.jpg", 1200, 85),

    # WeChat QR code (kept sharp so it stays scannable)
    @("$src\中国のLINE.jpg", "$out\wechat-qr.jpg", 900, 92),

    # Logo (transparent PNG)
    @("$src\ロゴ.PNG", "$out\logo.png", 900, 100)
)

foreach ($j in $jobs) {
    Resize-Photo -SrcPath $j[0] -DestPath $j[1] -MaxDim $j[2] -Quality $j[3]
}

Write-Output "Done."
