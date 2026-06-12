# Generates assets/icon/app_icon.png (1024x1024) - a stylized world map globe
# with a location pin, matching the app's dark purple theme.
# Run from the repo root:  powershell -File scripts\generate_app_icon.ps1

Add-Type -AssemblyName System.Drawing

$size = 1024
$bmp = New-Object System.Drawing.Bitmap($size, $size)
$g = [System.Drawing.Graphics]::FromImage($bmp)
$g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias

function PointsF($coords) {
    [System.Drawing.PointF[]]($coords | ForEach-Object { New-Object System.Drawing.PointF($_[0], $_[1]) })
}

# --- Background: dark purple gradient (app theme) ---
$rect = New-Object System.Drawing.Rectangle(0, 0, $size, $size)
$bgTop = [System.Drawing.Color]::FromArgb(255, 76, 35, 122)
$bgBottom = [System.Drawing.Color]::FromArgb(255, 38, 30, 48)
$bgBrush = New-Object System.Drawing.Drawing2D.LinearGradientBrush($rect, $bgTop, $bgBottom, 65)
$g.FillRectangle($bgBrush, $rect)

# --- Globe (ocean) ---
$cx = 512; $cy = 532; $r = 360
$globePath = New-Object System.Drawing.Drawing2D.GraphicsPath
$globePath.AddEllipse($cx - $r, $cy - $r, 2 * $r, 2 * $r)

$oceanBrush = New-Object System.Drawing.Drawing2D.PathGradientBrush($globePath)
$oceanBrush.CenterColor = [System.Drawing.Color]::FromArgb(255, 72, 154, 234)
$oceanBrush.SurroundColors = [System.Drawing.Color[]]@([System.Drawing.Color]::FromArgb(255, 21, 74, 156))
$oceanBrush.CenterPoint = New-Object System.Drawing.PointF(($cx - 110), ($cy - 130))
$g.FillPath($oceanBrush, $globePath)

# Everything land/grid is clipped to the globe circle
$g.SetClip($globePath)

# --- Continents (stylized) ---
$land = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 86, 184, 96))
$landDark = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(120, 26, 94, 46), 6)

# North America
$na = PointsF @(@(200,330),@(265,265),@(360,238),@(450,262),@(470,318),@(415,352),@(440,412),@(392,452),@(312,438),@(238,398))
$g.FillPolygon($land, $na); $g.DrawPolygon($landDark, $na)
# South America
$sa = PointsF @(@(366,492),@(444,470),@(492,532),@(474,632),@(420,716),@(382,652),@(356,556))
$g.FillPolygon($land, $sa); $g.DrawPolygon($landDark, $sa)
# Europe
$eu = PointsF @(@(556,268),@(648,236),@(742,262),@(726,326),@(644,338),@(576,316))
$g.FillPolygon($land, $eu); $g.DrawPolygon($landDark, $eu)
# Africa
$af = PointsF @(@(566,366),@(688,352),@(756,420),@(722,544),@(648,628),@(594,540),@(556,444))
$g.FillPolygon($land, $af); $g.DrawPolygon($landDark, $af)
# Australia
$au = PointsF @(@(742,628),@(822,606),@(872,662),@(820,716),@(750,692))
$g.FillPolygon($land, $au); $g.DrawPolygon($landDark, $au)

# --- Grid: latitude chords + meridian ellipses ---
$gridPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(95, 255, 255, 255), 5)
foreach ($dy in @(-240, -120, 0, 120, 240)) {
    $half = [Math]::Sqrt($r * $r - $dy * $dy)
    $g.DrawLine($gridPen, ($cx - $half), ($cy + $dy), ($cx + $half), ($cy + $dy))
}
foreach ($w in @(240, 480)) {
    $g.DrawEllipse($gridPen, ($cx - $w / 2), ($cy - $r), $w, (2 * $r))
}
$g.DrawLine($gridPen, $cx, ($cy - $r), $cx, ($cy + $r))

$g.ResetClip()

# --- Globe rim ---
$rimPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(230, 235, 230, 250), 10)
$g.DrawEllipse($rimPen, ($cx - $r), ($cy - $r), (2 * $r), (2 * $r))

# --- Location pin (top right) ---
$pinColor = [System.Drawing.Color]::FromArgb(255, 240, 81, 60)
$pinBrush = New-Object System.Drawing.SolidBrush($pinColor)
$pinOutline = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(255, 255, 255, 255), 12)

$pinPath = New-Object System.Drawing.Drawing2D.GraphicsPath
$pinPath.AddArc(668, 96, 200, 200, 150, 240)   # round head
$pinPath.AddLine(854, 270, 768, 388)           # right edge to tip
$pinPath.AddLine(768, 388, 682, 270)           # tip to left edge
$pinPath.CloseFigure()
$g.FillPath($pinBrush, $pinPath)
$g.DrawPath($pinOutline, $pinPath)

$holeBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 255, 255, 255))
$g.FillEllipse($holeBrush, 728, 156, 80, 80)

# --- Save ---
$outDir = Join-Path $PSScriptRoot "..\assets\icon"
New-Item -ItemType Directory -Force $outDir | Out-Null
$outPath = Join-Path (Resolve-Path $outDir) "app_icon.png"
$bmp.Save($outPath, [System.Drawing.Imaging.ImageFormat]::Png)

$g.Dispose(); $bmp.Dispose()
Write-Host "Icon written to $outPath"
