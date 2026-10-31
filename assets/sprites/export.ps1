Add-Type -AssemblyName System.Drawing
New-Item -ItemType Directory -Force 'assets/sprites/sources' | Out-Null
Copy-Item -LiteralPath 'C:\Users\Zunashy\.codex\generated_images\01a18f56-8bf7-79a0-9ea5-7a7a1e9a99e5\exec-0863521f-e1e1-44bf-a48e-4dfa194f5724.png' -Destination 'assets/sprites/sources/player.png'
$src=[System.Drawing.Image]::FromFile('C:\Users\Zunashy\.codex\generated_images\01a18f56-8bf7-79a0-9ea5-7a7a1e9a99e5\exec-0863521f-e1e1-44bf-a48e-4dfa194f5724.png')
$dst=New-Object System.Drawing.Bitmap(64,128)
$g=[System.Drawing.Graphics]::FromImage($dst)
$g.InterpolationMode=[System.Drawing.Drawing2D.InterpolationMode]::NearestNeighbor
$g.PixelOffsetMode=[System.Drawing.Drawing2D.PixelOffsetMode]::Half
$g.DrawImage($src,(New-Object System.Drawing.Rectangle(0,0,64,128)),0,0,$src.Width,$src.Height,[System.Drawing.GraphicsUnit]::Pixel)
$dst.Save((Join-Path (Get-Location) 'assets/sprites/player.png'),[System.Drawing.Imaging.ImageFormat]::Png)
$g.Dispose(); $dst.Dispose(); $src.Dispose()
Copy-Item -LiteralPath 'C:\Users\Zunashy\.codex\generated_images\01a18f56-8bf7-79a0-9ea5-7a7a1e9a99e5\exec-b869fe60-e491-4e79-89bc-822c5685d275.png' -Destination 'assets/sprites/sources/employee.png'
$src=[System.Drawing.Image]::FromFile('C:\Users\Zunashy\.codex\generated_images\01a18f56-8bf7-79a0-9ea5-7a7a1e9a99e5\exec-b869fe60-e491-4e79-89bc-822c5685d275.png')
$dst=New-Object System.Drawing.Bitmap(64,128)
$g=[System.Drawing.Graphics]::FromImage($dst)
$g.InterpolationMode=[System.Drawing.Drawing2D.InterpolationMode]::NearestNeighbor
$g.PixelOffsetMode=[System.Drawing.Drawing2D.PixelOffsetMode]::Half
$g.DrawImage($src,(New-Object System.Drawing.Rectangle(0,0,64,128)),0,0,$src.Width,$src.Height,[System.Drawing.GraphicsUnit]::Pixel)
$dst.Save((Join-Path (Get-Location) 'assets/sprites/employee.png'),[System.Drawing.Imaging.ImageFormat]::Png)
$g.Dispose(); $dst.Dispose(); $src.Dispose()
Copy-Item -LiteralPath 'C:\Users\Zunashy\.codex\generated_images\01a18f56-8bf7-79a0-9ea5-7a7a1e9a99e5\exec-a504018f-0d9b-4ebe-9b36-eed29b6b58ef.png' -Destination 'assets/sprites/sources/soil_dry.png'
$src=[System.Drawing.Image]::FromFile('C:\Users\Zunashy\.codex\generated_images\01a18f56-8bf7-79a0-9ea5-7a7a1e9a99e5\exec-a504018f-0d9b-4ebe-9b36-eed29b6b58ef.png')
$dst=New-Object System.Drawing.Bitmap(32,32)
$g=[System.Drawing.Graphics]::FromImage($dst)
$g.InterpolationMode=[System.Drawing.Drawing2D.InterpolationMode]::NearestNeighbor
$g.PixelOffsetMode=[System.Drawing.Drawing2D.PixelOffsetMode]::Half
$g.DrawImage($src,(New-Object System.Drawing.Rectangle(0,0,32,32)),0,0,$src.Width,$src.Height,[System.Drawing.GraphicsUnit]::Pixel)
$dst.Save((Join-Path (Get-Location) 'assets/sprites/soil_dry.png'),[System.Drawing.Imaging.ImageFormat]::Png)
$g.Dispose(); $dst.Dispose(); $src.Dispose()
Copy-Item -LiteralPath 'C:\Users\Zunashy\.codex\generated_images\01a18f56-8bf7-79a0-9ea5-7a7a1e9a99e5\exec-cca414b2-a413-4c79-83b5-58877fe1a801.png' -Destination 'assets/sprites/sources/soil_wet.png'
$src=[System.Drawing.Image]::FromFile('C:\Users\Zunashy\.codex\generated_images\01a18f56-8bf7-79a0-9ea5-7a7a1e9a99e5\exec-cca414b2-a413-4c79-83b5-58877fe1a801.png')
$dst=New-Object System.Drawing.Bitmap(32,32)
$g=[System.Drawing.Graphics]::FromImage($dst)
$g.InterpolationMode=[System.Drawing.Drawing2D.InterpolationMode]::NearestNeighbor
$g.PixelOffsetMode=[System.Drawing.Drawing2D.PixelOffsetMode]::Half
$g.DrawImage($src,(New-Object System.Drawing.Rectangle(0,0,32,32)),0,0,$src.Width,$src.Height,[System.Drawing.GraphicsUnit]::Pixel)
$dst.Save((Join-Path (Get-Location) 'assets/sprites/soil_wet.png'),[System.Drawing.Imaging.ImageFormat]::Png)
$g.Dispose(); $dst.Dispose(); $src.Dispose()
Copy-Item -LiteralPath 'C:\Users\Zunashy\.codex\generated_images\01a18f56-8bf7-79a0-9ea5-7a7a1e9a99e5\exec-4dde2787-c9e3-4572-8525-aff56816c656.png' -Destination 'assets/sprites/sources/grass.png'
$src=[System.Drawing.Image]::FromFile('C:\Users\Zunashy\.codex\generated_images\01a18f56-8bf7-79a0-9ea5-7a7a1e9a99e5\exec-4dde2787-c9e3-4572-8525-aff56816c656.png')
$dst=New-Object System.Drawing.Bitmap(32,32)
$g=[System.Drawing.Graphics]::FromImage($dst)
$g.InterpolationMode=[System.Drawing.Drawing2D.InterpolationMode]::NearestNeighbor
$g.PixelOffsetMode=[System.Drawing.Drawing2D.PixelOffsetMode]::Half
$g.DrawImage($src,(New-Object System.Drawing.Rectangle(0,0,32,32)),0,0,$src.Width,$src.Height,[System.Drawing.GraphicsUnit]::Pixel)
$dst.Save((Join-Path (Get-Location) 'assets/sprites/grass.png'),[System.Drawing.Imaging.ImageFormat]::Png)
$g.Dispose(); $dst.Dispose(); $src.Dispose()
Copy-Item -LiteralPath 'C:\Users\Zunashy\.codex\generated_images\01a18f56-8bf7-79a0-9ea5-7a7a1e9a99e5\exec-b162e93c-9332-45ed-868b-9a474d3831e3.png' -Destination 'assets/sprites/sources/wheat_0.png'
$src=[System.Drawing.Image]::FromFile('C:\Users\Zunashy\.codex\generated_images\01a18f56-8bf7-79a0-9ea5-7a7a1e9a99e5\exec-b162e93c-9332-45ed-868b-9a474d3831e3.png')
$dst=New-Object System.Drawing.Bitmap(32,32)
$g=[System.Drawing.Graphics]::FromImage($dst)
$g.InterpolationMode=[System.Drawing.Drawing2D.InterpolationMode]::NearestNeighbor
$g.PixelOffsetMode=[System.Drawing.Drawing2D.PixelOffsetMode]::Half
$g.DrawImage($src,(New-Object System.Drawing.Rectangle(0,0,32,32)),0,0,$src.Width,$src.Height,[System.Drawing.GraphicsUnit]::Pixel)
$dst.Save((Join-Path (Get-Location) 'assets/sprites/wheat_0.png'),[System.Drawing.Imaging.ImageFormat]::Png)
$g.Dispose(); $dst.Dispose(); $src.Dispose()
Copy-Item -LiteralPath 'C:\Users\Zunashy\.codex\generated_images\01a18f56-8bf7-79a0-9ea5-7a7a1e9a99e5\exec-804ad87b-a131-4fd1-8ecd-e458d20b0ec3.png' -Destination 'assets/sprites/sources/wheat_1.png'
$src=[System.Drawing.Image]::FromFile('C:\Users\Zunashy\.codex\generated_images\01a18f56-8bf7-79a0-9ea5-7a7a1e9a99e5\exec-804ad87b-a131-4fd1-8ecd-e458d20b0ec3.png')
$dst=New-Object System.Drawing.Bitmap(32,32)
$g=[System.Drawing.Graphics]::FromImage($dst)
$g.InterpolationMode=[System.Drawing.Drawing2D.InterpolationMode]::NearestNeighbor
$g.PixelOffsetMode=[System.Drawing.Drawing2D.PixelOffsetMode]::Half
$g.DrawImage($src,(New-Object System.Drawing.Rectangle(0,0,32,32)),0,0,$src.Width,$src.Height,[System.Drawing.GraphicsUnit]::Pixel)
$dst.Save((Join-Path (Get-Location) 'assets/sprites/wheat_1.png'),[System.Drawing.Imaging.ImageFormat]::Png)
$g.Dispose(); $dst.Dispose(); $src.Dispose()
Copy-Item -LiteralPath 'C:\Users\Zunashy\.codex\generated_images\01a18f56-8bf7-79a0-9ea5-7a7a1e9a99e5\exec-b50036b2-1b8e-469d-9641-fe2d25a89c13.png' -Destination 'assets/sprites/sources/wheat_2.png'
$src=[System.Drawing.Image]::FromFile('C:\Users\Zunashy\.codex\generated_images\01a18f56-8bf7-79a0-9ea5-7a7a1e9a99e5\exec-b50036b2-1b8e-469d-9641-fe2d25a89c13.png')
$dst=New-Object System.Drawing.Bitmap(32,32)
$g=[System.Drawing.Graphics]::FromImage($dst)
$g.InterpolationMode=[System.Drawing.Drawing2D.InterpolationMode]::NearestNeighbor
$g.PixelOffsetMode=[System.Drawing.Drawing2D.PixelOffsetMode]::Half
$g.DrawImage($src,(New-Object System.Drawing.Rectangle(0,0,32,32)),0,0,$src.Width,$src.Height,[System.Drawing.GraphicsUnit]::Pixel)
$dst.Save((Join-Path (Get-Location) 'assets/sprites/wheat_2.png'),[System.Drawing.Imaging.ImageFormat]::Png)
$g.Dispose(); $dst.Dispose(); $src.Dispose()
Copy-Item -LiteralPath 'C:\Users\Zunashy\.codex\generated_images\01a18f56-8bf7-79a0-9ea5-7a7a1e9a99e5\exec-d06c2493-1256-4067-97c6-08abdc587004.png' -Destination 'assets/sprites/sources/wheat_3.png'
$src=[System.Drawing.Image]::FromFile('C:\Users\Zunashy\.codex\generated_images\01a18f56-8bf7-79a0-9ea5-7a7a1e9a99e5\exec-d06c2493-1256-4067-97c6-08abdc587004.png')
$dst=New-Object System.Drawing.Bitmap(32,32)
$g=[System.Drawing.Graphics]::FromImage($dst)
$g.InterpolationMode=[System.Drawing.Drawing2D.InterpolationMode]::NearestNeighbor
$g.PixelOffsetMode=[System.Drawing.Drawing2D.PixelOffsetMode]::Half
$g.DrawImage($src,(New-Object System.Drawing.Rectangle(0,0,32,32)),0,0,$src.Width,$src.Height,[System.Drawing.GraphicsUnit]::Pixel)
$dst.Save((Join-Path (Get-Location) 'assets/sprites/wheat_3.png'),[System.Drawing.Imaging.ImageFormat]::Png)
$g.Dispose(); $dst.Dispose(); $src.Dispose()
Copy-Item -LiteralPath 'C:\Users\Zunashy\.codex\generated_images\01a18f56-8bf7-79a0-9ea5-7a7a1e9a99e5\exec-dbcc0d12-c13d-46bb-ae5c-b25f72c3b74a.png' -Destination 'assets/sprites/sources/sell_box.png'
$src=[System.Drawing.Image]::FromFile('C:\Users\Zunashy\.codex\generated_images\01a18f56-8bf7-79a0-9ea5-7a7a1e9a99e5\exec-dbcc0d12-c13d-46bb-ae5c-b25f72c3b74a.png')
$dst=New-Object System.Drawing.Bitmap(40,32)
$g=[System.Drawing.Graphics]::FromImage($dst)
$g.InterpolationMode=[System.Drawing.Drawing2D.InterpolationMode]::NearestNeighbor
$g.PixelOffsetMode=[System.Drawing.Drawing2D.PixelOffsetMode]::Half
$g.DrawImage($src,(New-Object System.Drawing.Rectangle(0,0,40,32)),0,0,$src.Width,$src.Height,[System.Drawing.GraphicsUnit]::Pixel)
$dst.Save((Join-Path (Get-Location) 'assets/sprites/sell_box.png'),[System.Drawing.Imaging.ImageFormat]::Png)
$g.Dispose(); $dst.Dispose(); $src.Dispose()
Copy-Item -LiteralPath 'C:\Users\Zunashy\.codex\generated_images\01a18f56-8bf7-79a0-9ea5-7a7a1e9a99e5\exec-e8039796-2701-40c3-8dcf-9057b276f7ad.png' -Destination 'assets/sprites/sources/icon_seeds.png'
$src=[System.Drawing.Image]::FromFile('C:\Users\Zunashy\.codex\generated_images\01a18f56-8bf7-79a0-9ea5-7a7a1e9a99e5\exec-e8039796-2701-40c3-8dcf-9057b276f7ad.png')
$dst=New-Object System.Drawing.Bitmap(16,16)
$g=[System.Drawing.Graphics]::FromImage($dst)
$g.InterpolationMode=[System.Drawing.Drawing2D.InterpolationMode]::NearestNeighbor
$g.PixelOffsetMode=[System.Drawing.Drawing2D.PixelOffsetMode]::Half
$g.DrawImage($src,(New-Object System.Drawing.Rectangle(0,0,16,16)),0,0,$src.Width,$src.Height,[System.Drawing.GraphicsUnit]::Pixel)
$dst.Save((Join-Path (Get-Location) 'assets/sprites/icon_seeds.png'),[System.Drawing.Imaging.ImageFormat]::Png)
$g.Dispose(); $dst.Dispose(); $src.Dispose()
Copy-Item -LiteralPath 'C:\Users\Zunashy\.codex\generated_images\01a18f56-8bf7-79a0-9ea5-7a7a1e9a99e5\exec-26b9ae9a-483b-4a1b-ab2c-2392bf9e72df.png' -Destination 'assets/sprites/sources/icon_can.png'
$src=[System.Drawing.Image]::FromFile('C:\Users\Zunashy\.codex\generated_images\01a18f56-8bf7-79a0-9ea5-7a7a1e9a99e5\exec-26b9ae9a-483b-4a1b-ab2c-2392bf9e72df.png')
$dst=New-Object System.Drawing.Bitmap(16,16)
$g=[System.Drawing.Graphics]::FromImage($dst)
$g.InterpolationMode=[System.Drawing.Drawing2D.InterpolationMode]::NearestNeighbor
$g.PixelOffsetMode=[System.Drawing.Drawing2D.PixelOffsetMode]::Half
$g.DrawImage($src,(New-Object System.Drawing.Rectangle(0,0,16,16)),0,0,$src.Width,$src.Height,[System.Drawing.GraphicsUnit]::Pixel)
$dst.Save((Join-Path (Get-Location) 'assets/sprites/icon_can.png'),[System.Drawing.Imaging.ImageFormat]::Png)
$g.Dispose(); $dst.Dispose(); $src.Dispose()
Copy-Item -LiteralPath 'C:\Users\Zunashy\.codex\generated_images\01a18f56-8bf7-79a0-9ea5-7a7a1e9a99e5\exec-91ccebea-660c-4846-bb14-9c7c11402d7f.png' -Destination 'assets/sprites/sources/icon_hand.png'
$src=[System.Drawing.Image]::FromFile('C:\Users\Zunashy\.codex\generated_images\01a18f56-8bf7-79a0-9ea5-7a7a1e9a99e5\exec-91ccebea-660c-4846-bb14-9c7c11402d7f.png')
$dst=New-Object System.Drawing.Bitmap(16,16)
$g=[System.Drawing.Graphics]::FromImage($dst)
$g.InterpolationMode=[System.Drawing.Drawing2D.InterpolationMode]::NearestNeighbor
$g.PixelOffsetMode=[System.Drawing.Drawing2D.PixelOffsetMode]::Half
$g.DrawImage($src,(New-Object System.Drawing.Rectangle(0,0,16,16)),0,0,$src.Width,$src.Height,[System.Drawing.GraphicsUnit]::Pixel)
$dst.Save((Join-Path (Get-Location) 'assets/sprites/icon_hand.png'),[System.Drawing.Imaging.ImageFormat]::Png)
$g.Dispose(); $dst.Dispose(); $src.Dispose()
Copy-Item -LiteralPath 'C:\Users\Zunashy\.codex\generated_images\01a18f56-8bf7-79a0-9ea5-7a7a1e9a99e5\exec-558e2b38-905f-4b6b-9aa7-89e00164293d.png' -Destination 'assets/sprites/sources/icon_wheat.png'
$src=[System.Drawing.Image]::FromFile('C:\Users\Zunashy\.codex\generated_images\01a18f56-8bf7-79a0-9ea5-7a7a1e9a99e5\exec-558e2b38-905f-4b6b-9aa7-89e00164293d.png')
$dst=New-Object System.Drawing.Bitmap(16,16)
$g=[System.Drawing.Graphics]::FromImage($dst)
$g.InterpolationMode=[System.Drawing.Drawing2D.InterpolationMode]::NearestNeighbor
$g.PixelOffsetMode=[System.Drawing.Drawing2D.PixelOffsetMode]::Half
$g.DrawImage($src,(New-Object System.Drawing.Rectangle(0,0,16,16)),0,0,$src.Width,$src.Height,[System.Drawing.GraphicsUnit]::Pixel)
$dst.Save((Join-Path (Get-Location) 'assets/sprites/icon_wheat.png'),[System.Drawing.Imaging.ImageFormat]::Png)
$g.Dispose(); $dst.Dispose(); $src.Dispose()
Copy-Item -LiteralPath 'C:\Users\Zunashy\.codex\generated_images\01a18f56-8bf7-79a0-9ea5-7a7a1e9a99e5\exec-aff282e6-b779-4361-9b80-fee43a01788c.png' -Destination 'assets/sprites/sources/icon_coin.png'
$src=[System.Drawing.Image]::FromFile('C:\Users\Zunashy\.codex\generated_images\01a18f56-8bf7-79a0-9ea5-7a7a1e9a99e5\exec-aff282e6-b779-4361-9b80-fee43a01788c.png')
$dst=New-Object System.Drawing.Bitmap(16,16)
$g=[System.Drawing.Graphics]::FromImage($dst)
$g.InterpolationMode=[System.Drawing.Drawing2D.InterpolationMode]::NearestNeighbor
$g.PixelOffsetMode=[System.Drawing.Drawing2D.PixelOffsetMode]::Half
$g.DrawImage($src,(New-Object System.Drawing.Rectangle(0,0,16,16)),0,0,$src.Width,$src.Height,[System.Drawing.GraphicsUnit]::Pixel)
$dst.Save((Join-Path (Get-Location) 'assets/sprites/icon_coin.png'),[System.Drawing.Imaging.ImageFormat]::Png)
$g.Dispose(); $dst.Dispose(); $src.Dispose()
Copy-Item -LiteralPath 'C:\Users\Zunashy\.codex\generated_images\01a18f56-8bf7-79a0-9ea5-7a7a1e9a99e5\exec-bfce26df-645e-49b0-b746-9bf9dd302ff1.png' -Destination 'assets/sprites/sources/icon_market.png'
$src=[System.Drawing.Image]::FromFile('C:\Users\Zunashy\.codex\generated_images\01a18f56-8bf7-79a0-9ea5-7a7a1e9a99e5\exec-bfce26df-645e-49b0-b746-9bf9dd302ff1.png')
$dst=New-Object System.Drawing.Bitmap(24,24)
$g=[System.Drawing.Graphics]::FromImage($dst)
$g.InterpolationMode=[System.Drawing.Drawing2D.InterpolationMode]::NearestNeighbor
$g.PixelOffsetMode=[System.Drawing.Drawing2D.PixelOffsetMode]::Half
$g.DrawImage($src,(New-Object System.Drawing.Rectangle(0,0,24,24)),0,0,$src.Width,$src.Height,[System.Drawing.GraphicsUnit]::Pixel)
$dst.Save((Join-Path (Get-Location) 'assets/sprites/icon_market.png'),[System.Drawing.Imaging.ImageFormat]::Png)
$g.Dispose(); $dst.Dispose(); $src.Dispose()
Copy-Item -LiteralPath 'C:\Users\Zunashy\.codex\generated_images\01a18f56-8bf7-79a0-9ea5-7a7a1e9a99e5\exec-f0da14db-0b49-44b0-9372-250542dc01bf.png' -Destination 'assets/sprites/sources/field_for_sale.png'
$src=[System.Drawing.Image]::FromFile('C:\Users\Zunashy\.codex\generated_images\01a18f56-8bf7-79a0-9ea5-7a7a1e9a99e5\exec-f0da14db-0b49-44b0-9372-250542dc01bf.png')
$dst=New-Object System.Drawing.Bitmap(128,128)
$g=[System.Drawing.Graphics]::FromImage($dst)
$g.InterpolationMode=[System.Drawing.Drawing2D.InterpolationMode]::NearestNeighbor
$g.PixelOffsetMode=[System.Drawing.Drawing2D.PixelOffsetMode]::Half
$g.DrawImage($src,(New-Object System.Drawing.Rectangle(0,0,128,128)),0,0,$src.Width,$src.Height,[System.Drawing.GraphicsUnit]::Pixel)
$dst.Save((Join-Path (Get-Location) 'assets/sprites/field_for_sale.png'),[System.Drawing.Imaging.ImageFormat]::Png)
$g.Dispose(); $dst.Dispose(); $src.Dispose()

