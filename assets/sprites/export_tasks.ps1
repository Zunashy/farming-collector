Add-Type -AssemblyName System.Drawing
Copy-Item -LiteralPath 'C:\Users\Zunashy\.codex\generated_images\01a18f56-8bf7-79a0-9ea5-7a7a1e9a99e5\exec-116e9228-223a-4d51-be5d-637467436d2c.png' -Destination 'assets/sprites/sources/task_rest.png'
$src=[System.Drawing.Image]::FromFile('C:\Users\Zunashy\.codex\generated_images\01a18f56-8bf7-79a0-9ea5-7a7a1e9a99e5\exec-116e9228-223a-4d51-be5d-637467436d2c.png')
$dst=New-Object System.Drawing.Bitmap(24,24)
$g=[System.Drawing.Graphics]::FromImage($dst)
$g.InterpolationMode='NearestNeighbor'
$g.PixelOffsetMode='Half'
$g.DrawImage($src,(New-Object System.Drawing.Rectangle(0,0,24,24)),0,0,$src.Width,$src.Height,[System.Drawing.GraphicsUnit]::Pixel)
$dst.Save((Join-Path (Get-Location) 'assets/sprites/task_rest.png'),[System.Drawing.Imaging.ImageFormat]::Png)
$g.Dispose(); $dst.Dispose(); $src.Dispose()
Copy-Item -LiteralPath 'C:\Users\Zunashy\.codex\generated_images\01a18f56-8bf7-79a0-9ea5-7a7a1e9a99e5\exec-0a883dbf-f655-45ba-a0ce-c4336a83d403.png' -Destination 'assets/sprites/sources/task_plant.png'
$src=[System.Drawing.Image]::FromFile('C:\Users\Zunashy\.codex\generated_images\01a18f56-8bf7-79a0-9ea5-7a7a1e9a99e5\exec-0a883dbf-f655-45ba-a0ce-c4336a83d403.png')
$dst=New-Object System.Drawing.Bitmap(24,24)
$g=[System.Drawing.Graphics]::FromImage($dst)
$g.InterpolationMode='NearestNeighbor'
$g.PixelOffsetMode='Half'
$g.DrawImage($src,(New-Object System.Drawing.Rectangle(0,0,24,24)),0,0,$src.Width,$src.Height,[System.Drawing.GraphicsUnit]::Pixel)
$dst.Save((Join-Path (Get-Location) 'assets/sprites/task_plant.png'),[System.Drawing.Imaging.ImageFormat]::Png)
$g.Dispose(); $dst.Dispose(); $src.Dispose()
Copy-Item -LiteralPath 'C:\Users\Zunashy\.codex\generated_images\01a18f56-8bf7-79a0-9ea5-7a7a1e9a99e5\exec-fbde0787-1911-4ddc-9d84-ceaaa1c344f9.png' -Destination 'assets/sprites/sources/task_water.png'
$src=[System.Drawing.Image]::FromFile('C:\Users\Zunashy\.codex\generated_images\01a18f56-8bf7-79a0-9ea5-7a7a1e9a99e5\exec-fbde0787-1911-4ddc-9d84-ceaaa1c344f9.png')
$dst=New-Object System.Drawing.Bitmap(24,24)
$g=[System.Drawing.Graphics]::FromImage($dst)
$g.InterpolationMode='NearestNeighbor'
$g.PixelOffsetMode='Half'
$g.DrawImage($src,(New-Object System.Drawing.Rectangle(0,0,24,24)),0,0,$src.Width,$src.Height,[System.Drawing.GraphicsUnit]::Pixel)
$dst.Save((Join-Path (Get-Location) 'assets/sprites/task_water.png'),[System.Drawing.Imaging.ImageFormat]::Png)
$g.Dispose(); $dst.Dispose(); $src.Dispose()
Copy-Item -LiteralPath 'C:\Users\Zunashy\.codex\generated_images\01a18f56-8bf7-79a0-9ea5-7a7a1e9a99e5\exec-6bdf314b-898b-4c11-801c-af272dfcefa6.png' -Destination 'assets/sprites/sources/task_harvest.png'
$src=[System.Drawing.Image]::FromFile('C:\Users\Zunashy\.codex\generated_images\01a18f56-8bf7-79a0-9ea5-7a7a1e9a99e5\exec-6bdf314b-898b-4c11-801c-af272dfcefa6.png')
$dst=New-Object System.Drawing.Bitmap(24,24)
$g=[System.Drawing.Graphics]::FromImage($dst)
$g.InterpolationMode='NearestNeighbor'
$g.PixelOffsetMode='Half'
$g.DrawImage($src,(New-Object System.Drawing.Rectangle(0,0,24,24)),0,0,$src.Width,$src.Height,[System.Drawing.GraphicsUnit]::Pixel)
$dst.Save((Join-Path (Get-Location) 'assets/sprites/task_harvest.png'),[System.Drawing.Imaging.ImageFormat]::Png)
$g.Dispose(); $dst.Dispose(); $src.Dispose()
Copy-Item -LiteralPath 'C:\Users\Zunashy\.codex\generated_images\01a18f56-8bf7-79a0-9ea5-7a7a1e9a99e5\exec-019033e5-7075-483a-9e86-8cc0812df085.png' -Destination 'assets/sprites/sources/task_sell.png'
$src=[System.Drawing.Image]::FromFile('C:\Users\Zunashy\.codex\generated_images\01a18f56-8bf7-79a0-9ea5-7a7a1e9a99e5\exec-019033e5-7075-483a-9e86-8cc0812df085.png')
$dst=New-Object System.Drawing.Bitmap(24,24)
$g=[System.Drawing.Graphics]::FromImage($dst)
$g.InterpolationMode='NearestNeighbor'
$g.PixelOffsetMode='Half'
$g.DrawImage($src,(New-Object System.Drawing.Rectangle(0,0,24,24)),0,0,$src.Width,$src.Height,[System.Drawing.GraphicsUnit]::Pixel)
$dst.Save((Join-Path (Get-Location) 'assets/sprites/task_sell.png'),[System.Drawing.Imaging.ImageFormat]::Png)
$g.Dispose(); $dst.Dispose(); $src.Dispose()
$b=New-Object System.Drawing.Bitmap(600,150)
$g=[System.Drawing.Graphics]::FromImage($b)
$g.Clear([System.Drawing.Color]::FromArgb(55,60,55))
$g.InterpolationMode='NearestNeighbor'
$i=0
$im=[System.Drawing.Image]::FromFile((Join-Path (Get-Location) 'assets/sprites/task_rest.png'))
$g.DrawImage($im,($i*120+12),8,96,96)
$g.DrawString('task_rest',(New-Object System.Drawing.Font('Arial',10)),[System.Drawing.Brushes]::White,($i*120+5),120)
$im.Dispose(); $i++
$im=[System.Drawing.Image]::FromFile((Join-Path (Get-Location) 'assets/sprites/task_plant.png'))
$g.DrawImage($im,($i*120+12),8,96,96)
$g.DrawString('task_plant',(New-Object System.Drawing.Font('Arial',10)),[System.Drawing.Brushes]::White,($i*120+5),120)
$im.Dispose(); $i++
$im=[System.Drawing.Image]::FromFile((Join-Path (Get-Location) 'assets/sprites/task_water.png'))
$g.DrawImage($im,($i*120+12),8,96,96)
$g.DrawString('task_water',(New-Object System.Drawing.Font('Arial',10)),[System.Drawing.Brushes]::White,($i*120+5),120)
$im.Dispose(); $i++
$im=[System.Drawing.Image]::FromFile((Join-Path (Get-Location) 'assets/sprites/task_harvest.png'))
$g.DrawImage($im,($i*120+12),8,96,96)
$g.DrawString('task_harvest',(New-Object System.Drawing.Font('Arial',10)),[System.Drawing.Brushes]::White,($i*120+5),120)
$im.Dispose(); $i++
$im=[System.Drawing.Image]::FromFile((Join-Path (Get-Location) 'assets/sprites/task_sell.png'))
$g.DrawImage($im,($i*120+12),8,96,96)
$g.DrawString('task_sell',(New-Object System.Drawing.Font('Arial',10)),[System.Drawing.Brushes]::White,($i*120+5),120)
$im.Dispose(); $i++
$b.Save((Join-Path (Get-Location) 'assets/sprites/tasks_preview.png'))
$g.Dispose(); $b.Dispose()

