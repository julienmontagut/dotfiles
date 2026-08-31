#!/usr/bin/env bash
# Doubles the font size everywhere Wayland output scaling can't reach: the GRUB
# menu and the Linux virtual consoles. Both render at the panel's native
# resolution with a fixed-pixel font, so on a 2880x1800 laptop the stock 16px
# fonts come out roughly half the physical size they do on a 1080p screen.
# Sway handles the graphical session separately via `output ... scale 2`.
set -eu

if [ "$(uname -s)" != Linux ]; then
    echo "Linux only." >&2
    exit 1
fi

GRUB_TTF=/usr/share/fonts/truetype/dejavu/DejaVuSansMono.ttf
GRUB_PF2=/boot/grub/fonts/unicode32.pf2
FBCON_ARG=fbcon=font:TER16x32

backup() {
    [ -f "$1.pre-2x" ] || sudo cp -a "$1" "$1.pre-2x"
}

# --- Virtual consoles -------------------------------------------------------
# Fixed tops out at 8x18, so this switches face to Terminus, which ships a
# 16x32 at exactly twice the current 8x16.
if [ ! -f /usr/share/consolefonts/Lat15-Terminus32x16.psf.gz ]; then
    echo "Missing Lat15-Terminus32x16; install console-setup." >&2
    exit 1
fi

backup /etc/default/console-setup
sudo sed -i \
    -e 's/^FONTFACE=.*/FONTFACE="Terminus"/' \
    -e 's/^FONTSIZE=.*/FONTSIZE="16x32"/' \
    /etc/default/console-setup

# --- GRUB -------------------------------------------------------------------
# gfxterm's default font is 16px tall; this builds the same face at 32.
if [ ! -f "$GRUB_TTF" ]; then
    echo "Missing $GRUB_TTF; install fonts-dejavu-core." >&2
    exit 1
fi
sudo grub-mkfont -s 32 -o "$GRUB_PF2" "$GRUB_TTF"

backup /etc/default/grub
if grep -q '^GRUB_FONT=' /etc/default/grub; then
    sudo sed -i "s|^GRUB_FONT=.*|GRUB_FONT=$GRUB_PF2|" /etc/default/grub
else
    printf '\n# 32px gfxterm font, twice the 16px default (see bin/install-boot-fonts).\nGRUB_FONT=%s\n' \
        "$GRUB_PF2" | sudo tee -a /etc/default/grub >/dev/null
fi

# fbcon picks the console font before console-setup runs, so without this the
# first few seconds of boot are still 8x16.
if ! grep -q "$FBCON_ARG" /etc/default/grub; then
    sudo sed -i "s|^\(GRUB_CMDLINE_LINUX_DEFAULT=\"[^\"]*\)\"|\1 $FBCON_ARG\"|" /etc/default/grub
fi

# --- Apply ------------------------------------------------------------------
sudo setupcon --force
sudo update-initramfs -u
sudo update-grub

echo
echo "Console font is live now. GRUB and the early-boot console apply on next reboot."
