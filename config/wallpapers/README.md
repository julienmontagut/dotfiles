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

`config/sway/config` sets `$wallpaper` and hands it to both swaybg and swaylock. It currently
points at `~/Pictures/wallpapers/private-use/wallhaven-d6qwkg.jpg`, which stays out of the repo
because wallhaven images are not redistributable; `rose-pine-maze.png` is the CC0 fallback.
