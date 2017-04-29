archlinux-v86
=============

This repo contains scripts to create an archlinux-x86 image for use with [v86](https://github.com/copy/v86/).


## Requirements

You need to have installed:

1. packer
2. kpartx
3. qemu

## Usage

1. Build the image
```
./build.sh
```

2. Set up `v86`
```
git clone https://github.com/copy/v86
cd v86
make
make run
```

3. Point your browser to `http://localhost:8000/`

4. Use the `Hard drive disk image` filepicker to select `packer/output-qemu/Archlinux-v86` and start the emulation


## Debugging

If the build fails, try tweaking `packer/template.json`. Things you can try:

1. Change `"headless": true,` to `"headless": false,` so you have visual output
2. Add some more waits (`<wait10>`) if it looks like the keystrokes are sent too fast
3. Add `"accelerator": "none",` if KVM gives you problems
4. Look [here](https://www.packer.io/docs/builders/qemu.html) for more options
