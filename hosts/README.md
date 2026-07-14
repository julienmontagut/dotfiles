# cloud-init user-data

First-boot bootstrap for headless Debian/Ubuntu hosts. A single
`user-data.yaml` serves every host: it is a Jinja-templated `#cloud-config`
that branches on the datasource hostname (`v1.local_hostname`, set by the
per-host `meta-data`) to pick the FQDN and any host-specific packages.

It creates `julien` (SSH-key auth, locked password), installs a minimal
bootstrap package set, hardens sshd, and drops a login notice with the
first-boot steps. It does **not** install the dotfiles - do that yourself after
logging in.

## Hosts

| Host   | Purpose                        | FQDN                     | Extra packages        |
|--------|--------------------------------|--------------------------|-----------------------|
| gaia   | private home LAN DNS (unbound) | `gaia.montagut.internal` | `unbound`             |
| hermes | upcast wake-on-LAN trigger     | `hermes.upcast.internal` | `wakeonlan etherwake` |

Any other `local-hostname` falls back to `<host>.montagut.internal` with only
the base packages.

`.internal` resolution itself is served out of band - unbound serves
`montagut.internal` on gaia, NetBird serves `upcast.internal` for hermes.
`user-data.yaml` only sets each host's own hostname/FQDN and `/etc/hosts`.

## First login

The login notice lists these; do them once, then the notice clears itself:

```
sudo passwd julien                      # set your sudo password (the only sudo you get for free)
sudo rm /etc/sudoers.d/10-julien-setpw  # removes the bootstrap rule and the notice
```

After that, every sudo requires the password you chose. Install dotfiles
whenever you want (`curl -fsSL .../install.sh | bash`, or clone and run it).

## Delivery per environment

The same `user-data.yaml` is used everywhere; only the `meta-data`
`local-hostname` differs.

### Raspberry Pi (hermes) - boot-partition NoCloud

Flash an Ubuntu Server arm64 image (cloud-init enabled) to the SD card, then on
the FAT32 boot partition:

```bash
cp user-data.yaml /Volumes/system-boot/user-data
printf 'instance-id: hermes\nlocal-hostname: hermes\n' > /Volumes/system-boot/meta-data
```

Boot the Pi, find it on the LAN, `ssh julien@hermes`.

### VM (gaia) - NoCloud seed ISO

```bash
brew install cdrtools           # macOS; or `genisoimage` on Linux
mkdir -p /tmp/seed
cp user-data.yaml /tmp/seed/user-data
printf 'instance-id: gaia\nlocal-hostname: gaia\n' > /tmp/seed/meta-data
mkisofs -output gaia-seed.iso -volid cidata -joliet -rock \
        /tmp/seed/user-data /tmp/seed/meta-data
```

Boot a Debian cloud image with `gaia-seed.iso` as a second CD-ROM. cloud-init's
NoCloud datasource finds the `cidata` volume on first boot.

### Scaleway Elastic Metal (gaia)

Paste the contents of `user-data.yaml` into the "Cloud-init" field when creating
the server. Name the server `gaia` so its datasource hostname drives the
template.

## Notes

- **SSH key**: my `id_ed25519.pub` is inlined. Rotate by editing the
  `ssh_authorized_keys` block.
- **Validating**: `cloud-init schema --config-file user-data.yaml` on a host
  with cloud-init (it renders the Jinja for the current instance).
