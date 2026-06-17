# cloud-init user-data

First-boot bootstrap for Debian 13 hosts. Each `<host>.yaml` is a complete
`#cloud-config` drop-in that sets hostname, creates julien (SSH-key auth,
locked password), installs the common package set, drops `/etc/doas.conf`
(initially `permit nopass`) and `/etc/ssh/sshd_config.d/10-hardening.conf`,
and clones this repo into `/home/julien/sources/dotfiles`.

After cloud-init finishes:

```
ssh julien@<host>
~/sources/dotfiles/hosts/<host>.sh        # layer 2: mise dotfiles + per-host extras
~/sources/dotfiles/hosts/harden-doas.sh   # optional: switch doas to persist
```

## Delivery per environment

### Raspberry Pi (hermes) — boot-partition NoCloud

Flash an Ubuntu Server arm64 image (or any image with cloud-init enabled)
to the SD card, then on the FAT32 boot partition:

```bash
cp hermes.yaml   /Volumes/system-boot/user-data
printf 'instance-id: hermes\nlocal-hostname: hermes\n' > /Volumes/system-boot/meta-data
```

Boot the Pi. Find it on the LAN, `ssh julien@hermes`, run layer 2.

### VM (apollo, gaia) — NoCloud seed ISO

When the host is a Parallels / UTM / Proxmox VM, build a tiny seed ISO and
attach it as a second CD drive:

```bash
brew install cdrtools           # macOS; or `genisoimage` on Linux
mkdir -p /tmp/seed
cp gaia.yaml /tmp/seed/user-data
printf 'instance-id: gaia\nlocal-hostname: gaia\n' > /tmp/seed/meta-data
mkisofs -output gaia-seed.iso -volid cidata -joliet -rock \
        /tmp/seed/user-data /tmp/seed/meta-data
```

Boot the VM with `gaia-seed.iso` as a second CD-ROM alongside a Debian
cloud image (e.g. `debian-13-genericcloud-arm64.qcow2`). Cloud-init's
NoCloud datasource finds the `cidata` volume on first boot.

### Scaleway Elastic Metal (apollo, gaia)

Paste the contents of `apollo.yaml` (or `gaia.yaml`) into the "Cloud-init"
field when creating the server. Scaleway's datasource injects it directly;
no ISO needed.

## Notes

- **Hostname** in the yaml is authoritative and overrides any datasource-provided
  hostname. Make sure to use the right `<host>.yaml`.
- **SSH key**: my `id_ed25519.pub` is inlined. Rotate by editing the
  `ssh_authorized_keys` block in each file.
- **doas** starts as `permit nopass julien as root` (account is locked, so
  the only way in is via SSH key — nopass is fine). Run
  `hosts/harden-doas.sh` later to set a password and switch to `persist`.
- **Validating** a file before flashing: `cloud-init schema --config-file <host>.yaml`
  on any host that has cloud-init installed.
