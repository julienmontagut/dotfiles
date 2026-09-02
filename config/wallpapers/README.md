# Wallpapers

`rose-pine-maze.png` is `generative/maze.png` from
[rose-pine/wallpapers](https://github.com/rose-pine/wallpapers) (CC0), re-encoded here at its
native 3456x2234 with a 32-colour palette: the image is flat lines on a flat `#191724` ground, so
the palette is lossless to the eye and halves the file to 461 KB. Regenerate with:

```sh
python3 -c "
from PIL import Image
im = Image.open('maze.png').convert('RGB')
im.quantize(colors=32, dither=Image.Dither.NONE).save('rose-pine-maze.png', optimize=True)
"
```

`config/sway/config` sets `$wallpaper` to this path and hands it to both swaybg and swaylock.
