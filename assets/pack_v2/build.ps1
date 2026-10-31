$ErrorActionPreference='Stop'
Add-Type -AssemblyName System.Drawing
Add-Type -ReferencedAssemblies @('System.Drawing.Common','System.Drawing.Primitives','System.Runtime','System.Private.Windows.GdiPlus','System.Private.Windows.Core') -TypeDefinition @'
using System;
using System.Drawing;
using System.Drawing.Drawing2D;
public static class PackPixels {
 public static string[] Hex={"302b26","53402f","785437","bd773c","e3a04e","f4bd67","ffe2a2","183d25","28592b","428037","70a13b","a6be43","d5d65c","754438","a85b42","cf7651","566878","7894a1","c8d8ce","655c52","8b8272","b6ad98","377b85","59a9ad","9ed3cb","704592","b183cb","dac8b1"};
 public static Color[] Pal=Array.ConvertAll(Hex,h=>ColorTranslator.FromHtml("#"+h));
 public static Bitmap Resize(Bitmap src,int w,int h) {
  var dst=new Bitmap(w,h,System.Drawing.Imaging.PixelFormat.Format32bppArgb);
  using(var g=Graphics.FromImage(dst)){g.InterpolationMode=InterpolationMode.NearestNeighbor;g.PixelOffsetMode=PixelOffsetMode.Half;g.DrawImage(src,new Rectangle(0,0,w,h),0,0,src.Width,src.Height,GraphicsUnit.Pixel);}return dst;
 }
 public static void Quantize(Bitmap b,bool alpha) {
  for(int y=0;y<b.Height;y++)for(int x=0;x<b.Width;x++){
   var c=b.GetPixel(x,y);if(alpha&&c.A<128){b.SetPixel(x,y,Color.Transparent);continue;}
   int best=int.MaxValue;Color found=Pal[0];foreach(var p in Pal){int dr=c.R-p.R,dg=c.G-p.G,db=c.B-p.B;int d=dr*dr*2+dg*dg*3+db*db*2;if(d<best){best=d;found=p;}}
   b.SetPixel(x,y,found);
  }
 }
 public static Bitmap Anchor(Bitmap src,int w,int h){
  int l=src.Width,t=src.Height,r=-1,b=-1;
  for(int y=0;y<src.Height;y++)for(int x=0;x<src.Width;x++)if(src.GetPixel(x,y).A>=128){l=Math.Min(l,x);r=Math.Max(r,x);t=Math.Min(t,y);b=Math.Max(b,y);}
  if(r<l)return new Bitmap(w,h);
  int sw=r-l+1,sh=b-t+1;double ratio=Math.Min((double)w/sw,(double)h/sh);
  int nw=Math.Max(1,(int)Math.Round(sw*ratio)),nh=Math.Max(1,(int)Math.Round(sh*ratio));
  var dst=new Bitmap(w,h);using(var g=Graphics.FromImage(dst)){g.InterpolationMode=InterpolationMode.NearestNeighbor;g.PixelOffsetMode=PixelOffsetMode.Half;g.DrawImage(src,new Rectangle((w-nw)/2,h-nh,nw,nh),l,t,sw,sh,GraphicsUnit.Pixel);}return dst;
 }
 public static Bitmap Character(Bitmap src){
  var dst=new Bitmap(128,192);using(var g=Graphics.FromImage(dst)){
   for(int y=0;y<4;y++)for(int x=0;x<4;x++){
    int x0=x*src.Width/4,y0=y*src.Height/4,x1=(x+1)*src.Width/4,y1=(y+1)*src.Height/4;
    using(var cell=src.Clone(new Rectangle(x0,y0,x1-x0,y1-y0),System.Drawing.Imaging.PixelFormat.Format32bppArgb))
    using(var frame=Anchor(cell,28,40)){g.DrawImageUnscaled(frame,x*32+2,y*48+8);}
   }
  }return dst;
 }
 public static Bitmap Terrain(Bitmap grass,Bitmap soil){
  var dst=new Bitmap(128,160);
  for(int mask=0;mask<16;mask++)for(int y=0;y<32;y++)for(int x=0;x<32;x++){
   int noise=((x*17+y*31)%5)-2;bool ground=true;
   if((mask&1)==0&&y<4+noise)ground=false;
   if((mask&2)==0&&x>27+noise)ground=false;
   if((mask&4)==0&&y>27+noise)ground=false;
   if((mask&8)==0&&x<4+noise)ground=false;
   dst.SetPixel(mask%4*32+x,mask/4*32+y,ground?soil.GetPixel(x,y):grass.GetPixel(x,y));
  }
  for(int variant=0;variant<4;variant++)for(int y=0;y<32;y++)for(int x=0;x<32;x++)dst.SetPixel(variant*32+x,128+y,soil.GetPixel((x+variant*7)%32,(y+variant*5)%32));
  return dst;
 }
}
'@
$root=$PSScriptRoot
foreach($file in Get-ChildItem (Join-Path $root 'manifests') -Filter '*.json') {
 $s=Get-Content -LiteralPath $file.FullName -Raw | ConvertFrom-Json
 $src=[System.Drawing.Bitmap]::FromFile((Join-Path $root ('sources/'+$s.name+'.png')))
 if($s.name -in @('player','employee')){$out=[PackPixels]::Character($src)}
 elseif($s.alpha -and $s.name -notmatch 'canopy|ui_panel|butterfly|bird_branch|sway|splash|falling'){$out=[PackPixels]::Anchor($src,$s.w,$s.h)}
 else {$out=[PackPixels]::Resize($src,$s.w,$s.h)}
 [PackPixels]::Quantize($out,$s.alpha)
 $out.Save((Join-Path $root ($s.name+'.png')),[System.Drawing.Imaging.ImageFormat]::Png)
 $out.Dispose(); $src.Dispose()
}
$grass=[System.Drawing.Bitmap]::FromFile((Join-Path $root 'tiles_grass.png'))
$tile=$grass.Clone((New-Object System.Drawing.Rectangle(0,0,32,32)),[System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
foreach($kind in @('path','soil_dry','soil_wet')){
 $s=[System.Drawing.Bitmap]::FromFile((Join-Path $root ($kind+'_base.png')))
 $atlas=[PackPixels]::Terrain($tile,$s)
 $atlas.Save((Join-Path $root ('tiles_'+$kind+'.png')),[System.Drawing.Imaging.ImageFormat]::Png)
 $s.Dispose(); $atlas.Dispose()
}
$tile.Dispose(); $grass.Dispose()
# Icônes déjà validées : même palette et dimensions du brief.
foreach($name in @('icon_seeds','icon_can','icon_hand','icon_wheat','icon_coin','icon_market','task_plant','task_water','task_harvest','task_sell','task_rest','wheat_0','wheat_1','wheat_2','wheat_3')){
 $size=16; if($name -eq 'icon_market'){$size=24}; if($name -like 'wheat_*'){$size=32}
 $src=[System.Drawing.Bitmap]::FromFile((Join-Path $root ('../sprites/'+$name+'.png')))
 $out=[PackPixels]::Resize($src,$size,$size); [PackPixels]::Quantize($out,$true)
 $out.Save((Join-Path $root ($name+'.png')),[System.Drawing.Imaging.ImageFormat]::Png)
 $out.Dispose(); $src.Dispose()
}
foreach($s in @(@('shadow_small',16,6),@('shadow_large',32,10))){
 $b=New-Object System.Drawing.Bitmap($s[1],$s[2]); $g=[System.Drawing.Graphics]::FromImage($b)
 $g.FillEllipse((New-Object System.Drawing.SolidBrush([PackPixels]::Pal[0])),0,0,$s[1],$s[2]); $g.Dispose()
 $b.Save((Join-Path $root ($s[0]+'.png')),[System.Drawing.Imaging.ImageFormat]::Png); $b.Dispose()
}
$b=New-Object System.Drawing.Bitmap(32,32); $g=[System.Drawing.Graphics]::FromImage($b)
$pen=New-Object System.Drawing.Pen([PackPixels]::Pal[6]); $g.DrawRectangle($pen,0,0,31,31); $pen.Dispose(); $g.Dispose()
$b.Save((Join-Path $root 'cursor_tile.png'),[System.Drawing.Imaging.ImageFormat]::Png); $b.Dispose()
$gpl="GIMP Palette`nName: Farming Coll warm v2`nColumns: 7`n#`n"
foreach($c in [PackPixels]::Pal){$gpl+="$($c.R) $($c.G) $($c.B)`n"}
[System.IO.File]::WriteAllText((Join-Path $root 'palette.gpl'),$gpl)
