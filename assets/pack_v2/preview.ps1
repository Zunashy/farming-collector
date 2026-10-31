Add-Type -AssemblyName System.Drawing
$root=$PSScriptRoot
$files=@(Get-ChildItem $root -Filter '*.png' | Where-Object Name -notmatch 'preview|recomposition')
$rows=[math]::Ceiling($files.Count/8)
$sheet=New-Object System.Drawing.Bitmap(1152,($rows*160))
$g=[System.Drawing.Graphics]::FromImage($sheet)
$g.Clear([System.Drawing.Color]::FromArgb(58,66,55)); $g.InterpolationMode='NearestNeighbor'; $g.PixelOffsetMode='Half'
$font=New-Object System.Drawing.Font('Arial',9)
$i=0
foreach($f in $files){
 $im=[System.Drawing.Image]::FromFile($f.FullName); $x=($i%8)*144; $y=[math]::Floor($i/8)*160
 $scale=[math]::Min([double](128.0/$im.Width),[double](125.0/$im.Height)); if($scale -gt 1){$scale=[math]::Floor($scale)}
 $w=[int]($im.Width*$scale); $h=[int]($im.Height*$scale)
 $g.DrawImage($im,[int]($x+(144-$w)/2),[int]$y,[int]$w,[int]$h)
 $g.DrawString($f.BaseName,$font,[System.Drawing.Brushes]::White,$x,($y+130)); $im.Dispose();$i++
}
$sheet.Save((Join-Path $root 'preview.png')); $g.Dispose();$sheet.Dispose();$font.Dispose()
# Croquis recomposé à la résolution de la carte uniquement avec les pièces du pack.
$b=New-Object System.Drawing.Bitmap(896,512);$g=[System.Drawing.Graphics]::FromImage($b)
$g.InterpolationMode='NearestNeighbor';$g.PixelOffsetMode='Half'
$images=@{}
foreach($f in Get-ChildItem $root -Filter '*.png' | Where-Object Name -notmatch 'preview|recomposition'){$images[$f.BaseName]=[System.Drawing.Image]::FromFile($f.FullName)}
for($y=0;$y -lt 512;$y+=32){for($x=0;$x -lt 896;$x+=32){$g.DrawImage($images['tiles_grass'],(New-Object System.Drawing.Rectangle($x,$y,32,32)),(($x/32+$y/32)%4)*32,0,32,32,[System.Drawing.GraphicsUnit]::Pixel)}}
for($x=96;$x -lt 800;$x+=32){$g.DrawImageUnscaled($images['path_base'],$x,320)}
foreach($c in @(192,416,640)){
 if($c -eq 192){for($y=96;$y -lt 224;$y+=32){for($x=$c+32;$x -lt $c+160;$x+=32){$g.DrawImageUnscaled($images['soil_dry_base'],$x,$y)}}}
 for($y=256;$y -le 288;$y+=32){$g.DrawImageUnscaled($images['path_base'],($c+64),$y)}
 # La barrière validée est incluse à l'identique dans le pack.
 $g.DrawImageUnscaled($images['fence_enclosure_back'],$c,64)
 if($c -eq 192){$g.DrawImageUnscaled($images['wheat_3'],($c+32),112);$g.DrawImageUnscaled($images['wheat_1'],($c+96),176)}
 elseif($images.ContainsKey('sign_for_sale')) {$g.DrawImageUnscaled($images['sign_for_sale'],($c+76),145)}
 $g.DrawImageUnscaled($images['fence_enclosure_front'],$c,64)
}
if($images.ContainsKey('tree_apple_trunk')){$g.DrawImageUnscaled($images['tree_apple_trunk'],48,96)}
if($images.ContainsKey('tree_apple_canopy')){$g.DrawImageUnscaled($images['tree_apple_canopy'],0,0)}
$rng=New-Object System.Random(42)
$flowers=@('flowers_white_1','flowers_yellow_1','flowers_purple_1','lavender_1','tall_grass_1')
for($i=0;$i -lt 65;$i++){
 $x=$rng.Next(0,864);$y=$rng.Next(370,480);$n=$flowers[$i%$flowers.Count]
 if($images.ContainsKey($n)){$g.DrawImageUnscaled($images[$n],$x,$y)}
}
foreach($p in @(@('sell_box',80,230),@('seed_bag',130,230),@('basket_apples',60,260),@('basket_tomatoes',130,270),@('pitchfork',155,238),@('signpost',50,210))){if($images.ContainsKey($p[0])){$g.DrawImageUnscaled($images[$p[0]],$p[1],$p[2])}}
foreach($p in @(@('player',142,226),@('employee',290,310))){if($images.ContainsKey($p[0])){$g.DrawImage($images[$p[0]],(New-Object System.Drawing.Rectangle($p[1],$p[2],32,48)),0,0,32,48,[System.Drawing.GraphicsUnit]::Pixel)}}
foreach($p in @(@('bush_1',0,430),@('bush_2',360,446),@('bush_3',810,430),@('rock_medium',460,360))){if($images.ContainsKey($p[0])){$g.DrawImageUnscaled($images[$p[0]],$p[1],$p[2])}}
$b.Save((Join-Path $root 'recomposition.png'));$g.Dispose();$b.Dispose()
foreach($im in $images.Values){$im.Dispose()}
