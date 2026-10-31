Add-Type -AssemblyName System.Drawing
Copy-Item -LiteralPath 'C:\Users\Zunashy\.codex\generated_images\01a18f56-8bf7-79a0-9ea5-7a7a1e9a99e5\exec-694cb613-e2e5-4acb-ba50-6922b8599c41.png' -Destination 'assets/sprites/sources/flowers_white.png'
$src=[System.Drawing.Image]::FromFile('C:\Users\Zunashy\.codex\generated_images\01a18f56-8bf7-79a0-9ea5-7a7a1e9a99e5\exec-694cb613-e2e5-4acb-ba50-6922b8599c41.png')
$dst=New-Object System.Drawing.Bitmap(32,32)
$g=[System.Drawing.Graphics]::FromImage($dst)
$g.InterpolationMode='NearestNeighbor'
$g.PixelOffsetMode='Half'
$g.DrawImage($src,(New-Object System.Drawing.Rectangle(0,0,32,32)),0,0,$src.Width,$src.Height,[System.Drawing.GraphicsUnit]::Pixel)
$dst.Save((Join-Path (Get-Location) 'assets/sprites/flowers_white.png'),[System.Drawing.Imaging.ImageFormat]::Png)
$g.Dispose(); $dst.Dispose(); $src.Dispose()
Copy-Item -LiteralPath 'C:\Users\Zunashy\.codex\generated_images\01a18f56-8bf7-79a0-9ea5-7a7a1e9a99e5\exec-a41fd882-9f1d-4fab-9d87-fff02383d5e5.png' -Destination 'assets/sprites/sources/flowers_mixed.png'
$src=[System.Drawing.Image]::FromFile('C:\Users\Zunashy\.codex\generated_images\01a18f56-8bf7-79a0-9ea5-7a7a1e9a99e5\exec-a41fd882-9f1d-4fab-9d87-fff02383d5e5.png')
$dst=New-Object System.Drawing.Bitmap(32,32)
$g=[System.Drawing.Graphics]::FromImage($dst)
$g.InterpolationMode='NearestNeighbor'
$g.PixelOffsetMode='Half'
$g.DrawImage($src,(New-Object System.Drawing.Rectangle(0,0,32,32)),0,0,$src.Width,$src.Height,[System.Drawing.GraphicsUnit]::Pixel)
$dst.Save((Join-Path (Get-Location) 'assets/sprites/flowers_mixed.png'),[System.Drawing.Imaging.ImageFormat]::Png)
$g.Dispose(); $dst.Dispose(); $src.Dispose()
Copy-Item -LiteralPath 'C:\Users\Zunashy\.codex\generated_images\01a18f56-8bf7-79a0-9ea5-7a7a1e9a99e5\exec-618a04f0-a36d-449d-9fe8-adf719707f64.png' -Destination 'assets/sprites/sources/dirt_plain.png'
$src=[System.Drawing.Image]::FromFile('C:\Users\Zunashy\.codex\generated_images\01a18f56-8bf7-79a0-9ea5-7a7a1e9a99e5\exec-618a04f0-a36d-449d-9fe8-adf719707f64.png')
$dst=New-Object System.Drawing.Bitmap(32,32)
$g=[System.Drawing.Graphics]::FromImage($dst)
$g.InterpolationMode='NearestNeighbor'
$g.PixelOffsetMode='Half'
$g.DrawImage($src,(New-Object System.Drawing.Rectangle(0,0,32,32)),0,0,$src.Width,$src.Height,[System.Drawing.GraphicsUnit]::Pixel)
$dst.Save((Join-Path (Get-Location) 'assets/sprites/dirt_plain.png'),[System.Drawing.Imaging.ImageFormat]::Png)
$g.Dispose(); $dst.Dispose(); $src.Dispose()
Copy-Item -LiteralPath 'C:\Users\Zunashy\.codex\generated_images\01a18f56-8bf7-79a0-9ea5-7a7a1e9a99e5\exec-4517a7ec-22b7-491c-86a3-aa009b426ff3.png' -Destination 'assets/sprites/sources/dirt_pebbles.png'
$src=[System.Drawing.Image]::FromFile('C:\Users\Zunashy\.codex\generated_images\01a18f56-8bf7-79a0-9ea5-7a7a1e9a99e5\exec-4517a7ec-22b7-491c-86a3-aa009b426ff3.png')
$dst=New-Object System.Drawing.Bitmap(32,32)
$g=[System.Drawing.Graphics]::FromImage($dst)
$g.InterpolationMode='NearestNeighbor'
$g.PixelOffsetMode='Half'
$g.DrawImage($src,(New-Object System.Drawing.Rectangle(0,0,32,32)),0,0,$src.Width,$src.Height,[System.Drawing.GraphicsUnit]::Pixel)
$dst.Save((Join-Path (Get-Location) 'assets/sprites/dirt_pebbles.png'),[System.Drawing.Imaging.ImageFormat]::Png)
$g.Dispose(); $dst.Dispose(); $src.Dispose()
Copy-Item -LiteralPath 'C:\Users\Zunashy\.codex\generated_images\01a18f56-8bf7-79a0-9ea5-7a7a1e9a99e5\exec-10e9e490-78b7-4cc6-8560-9cf0c2bb19b7.png' -Destination 'assets/sprites/sources/fence_horizontal.png'
$src=[System.Drawing.Image]::FromFile('C:\Users\Zunashy\.codex\generated_images\01a18f56-8bf7-79a0-9ea5-7a7a1e9a99e5\exec-10e9e490-78b7-4cc6-8560-9cf0c2bb19b7.png')
$dst=New-Object System.Drawing.Bitmap(32,32)
$g=[System.Drawing.Graphics]::FromImage($dst)
$g.InterpolationMode='NearestNeighbor'
$g.PixelOffsetMode='Half'
$g.DrawImage($src,(New-Object System.Drawing.Rectangle(0,0,32,32)),0,0,$src.Width,$src.Height,[System.Drawing.GraphicsUnit]::Pixel)
$dst.Save((Join-Path (Get-Location) 'assets/sprites/fence_horizontal.png'),[System.Drawing.Imaging.ImageFormat]::Png)
$g.Dispose(); $dst.Dispose(); $src.Dispose()
Copy-Item -LiteralPath 'C:\Users\Zunashy\.codex\generated_images\01a18f56-8bf7-79a0-9ea5-7a7a1e9a99e5\exec-9adbba4c-cc69-4373-b892-894131e66f83.png' -Destination 'assets/sprites/sources/fence_vertical.png'
$src=[System.Drawing.Image]::FromFile('C:\Users\Zunashy\.codex\generated_images\01a18f56-8bf7-79a0-9ea5-7a7a1e9a99e5\exec-9adbba4c-cc69-4373-b892-894131e66f83.png')
$dst=New-Object System.Drawing.Bitmap(32,32)
$g=[System.Drawing.Graphics]::FromImage($dst)
$g.InterpolationMode='NearestNeighbor'
$g.PixelOffsetMode='Half'
$g.DrawImage($src,(New-Object System.Drawing.Rectangle(0,0,32,32)),0,0,$src.Width,$src.Height,[System.Drawing.GraphicsUnit]::Pixel)
$dst.Save((Join-Path (Get-Location) 'assets/sprites/fence_vertical.png'),[System.Drawing.Imaging.ImageFormat]::Png)
$g.Dispose(); $dst.Dispose(); $src.Dispose()
Copy-Item -LiteralPath 'C:\Users\Zunashy\.codex\generated_images\01a18f56-8bf7-79a0-9ea5-7a7a1e9a99e5\exec-d181cf83-12d3-47be-b88f-638375998400.png' -Destination 'assets/sprites/sources/fence_corner.png'
$src=[System.Drawing.Image]::FromFile('C:\Users\Zunashy\.codex\generated_images\01a18f56-8bf7-79a0-9ea5-7a7a1e9a99e5\exec-d181cf83-12d3-47be-b88f-638375998400.png')
$dst=New-Object System.Drawing.Bitmap(32,32)
$g=[System.Drawing.Graphics]::FromImage($dst)
$g.InterpolationMode='NearestNeighbor'
$g.PixelOffsetMode='Half'
$g.DrawImage($src,(New-Object System.Drawing.Rectangle(0,0,32,32)),0,0,$src.Width,$src.Height,[System.Drawing.GraphicsUnit]::Pixel)
$dst.Save((Join-Path (Get-Location) 'assets/sprites/fence_corner.png'),[System.Drawing.Imaging.ImageFormat]::Png)
$g.Dispose(); $dst.Dispose(); $src.Dispose()
Copy-Item -LiteralPath 'C:\Users\Zunashy\.codex\generated_images\01a18f56-8bf7-79a0-9ea5-7a7a1e9a99e5\exec-a4b61d77-bbc9-4ad2-a57b-76f8d5ac7829.png' -Destination 'assets/sprites/sources/fence_gate.png'
$src=[System.Drawing.Image]::FromFile('C:\Users\Zunashy\.codex\generated_images\01a18f56-8bf7-79a0-9ea5-7a7a1e9a99e5\exec-a4b61d77-bbc9-4ad2-a57b-76f8d5ac7829.png')
$dst=New-Object System.Drawing.Bitmap(32,32)
$g=[System.Drawing.Graphics]::FromImage($dst)
$g.InterpolationMode='NearestNeighbor'
$g.PixelOffsetMode='Half'
$g.DrawImage($src,(New-Object System.Drawing.Rectangle(0,0,32,32)),0,0,$src.Width,$src.Height,[System.Drawing.GraphicsUnit]::Pixel)
$dst.Save((Join-Path (Get-Location) 'assets/sprites/fence_gate.png'),[System.Drawing.Imaging.ImageFormat]::Png)
$g.Dispose(); $dst.Dispose(); $src.Dispose()
$b=New-Object System.Drawing.Bitmap(800,280)
$g=[System.Drawing.Graphics]::FromImage($b)
$g.Clear([System.Drawing.Color]::FromArgb(55,60,55))
$g.InterpolationMode='NearestNeighbor'
$i=0
$im=[System.Drawing.Image]::FromFile((Join-Path (Get-Location) 'assets/sprites/flowers_white.png'))
$x=($i%4)*200; $y=[math]::Floor($i/4)*140
$g.DrawImage($im,($x+36),$y,112,112)
$g.DrawString('flowers_white',(New-Object System.Drawing.Font('Arial',10)),[System.Drawing.Brushes]::White,($x+5),($y+115))
$im.Dispose(); $i++
$im=[System.Drawing.Image]::FromFile((Join-Path (Get-Location) 'assets/sprites/flowers_mixed.png'))
$x=($i%4)*200; $y=[math]::Floor($i/4)*140
$g.DrawImage($im,($x+36),$y,112,112)
$g.DrawString('flowers_mixed',(New-Object System.Drawing.Font('Arial',10)),[System.Drawing.Brushes]::White,($x+5),($y+115))
$im.Dispose(); $i++
$im=[System.Drawing.Image]::FromFile((Join-Path (Get-Location) 'assets/sprites/dirt_plain.png'))
$x=($i%4)*200; $y=[math]::Floor($i/4)*140
$g.DrawImage($im,($x+36),$y,112,112)
$g.DrawString('dirt_plain',(New-Object System.Drawing.Font('Arial',10)),[System.Drawing.Brushes]::White,($x+5),($y+115))
$im.Dispose(); $i++
$im=[System.Drawing.Image]::FromFile((Join-Path (Get-Location) 'assets/sprites/dirt_pebbles.png'))
$x=($i%4)*200; $y=[math]::Floor($i/4)*140
$g.DrawImage($im,($x+36),$y,112,112)
$g.DrawString('dirt_pebbles',(New-Object System.Drawing.Font('Arial',10)),[System.Drawing.Brushes]::White,($x+5),($y+115))
$im.Dispose(); $i++
$im=[System.Drawing.Image]::FromFile((Join-Path (Get-Location) 'assets/sprites/fence_horizontal.png'))
$x=($i%4)*200; $y=[math]::Floor($i/4)*140
$g.DrawImage($im,($x+36),$y,112,112)
$g.DrawString('fence_horizontal',(New-Object System.Drawing.Font('Arial',10)),[System.Drawing.Brushes]::White,($x+5),($y+115))
$im.Dispose(); $i++
$im=[System.Drawing.Image]::FromFile((Join-Path (Get-Location) 'assets/sprites/fence_vertical.png'))
$x=($i%4)*200; $y=[math]::Floor($i/4)*140
$g.DrawImage($im,($x+36),$y,112,112)
$g.DrawString('fence_vertical',(New-Object System.Drawing.Font('Arial',10)),[System.Drawing.Brushes]::White,($x+5),($y+115))
$im.Dispose(); $i++
$im=[System.Drawing.Image]::FromFile((Join-Path (Get-Location) 'assets/sprites/fence_corner.png'))
$x=($i%4)*200; $y=[math]::Floor($i/4)*140
$g.DrawImage($im,($x+36),$y,112,112)
$g.DrawString('fence_corner',(New-Object System.Drawing.Font('Arial',10)),[System.Drawing.Brushes]::White,($x+5),($y+115))
$im.Dispose(); $i++
$im=[System.Drawing.Image]::FromFile((Join-Path (Get-Location) 'assets/sprites/fence_gate.png'))
$x=($i%4)*200; $y=[math]::Floor($i/4)*140
$g.DrawImage($im,($x+36),$y,112,112)
$g.DrawString('fence_gate',(New-Object System.Drawing.Font('Arial',10)),[System.Drawing.Brushes]::White,($x+5),($y+115))
$im.Dispose(); $i++
$b.Save((Join-Path (Get-Location) 'assets/sprites/map_preview.png'))
$g.Dispose(); $b.Dispose()

