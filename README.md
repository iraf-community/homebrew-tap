
# Homebrew Tap for IRAF Community

This [Homebrew tap](https://brew.sh) contains
[IRAF](https://iraf-community.github.io) and support packages. Most of
them are community maintained.

## Installation

```shell
brew tap iraf-community/tap
brew install iraf
brew install x11iraf
…
```

The **iraf** environment variable is

```shell
export iraf=${HOMEBREW_PREFIX}/opt/iraf/libexec/
```

## Available packages

 * **iraf**: Image Reduction and Analysis Facility ![GitHub Release](https://img.shields.io/github/v/release/iraf-community/homebrew-tap?filter=iraf-2*&label=&color=white)
 * **x11iraf**: X11 terminal emulator and image display for IRAF ![GitHub Release](https://img.shields.io/github/v/release/iraf-community/homebrew-tap?filter=x11iraf-*&label=&color=white)
 * **iraf-ctio**: Tools for the Cerro Tololo Inter-American Observatory ![GitHub Release](https://img.shields.io/github/v/release/iraf-community/homebrew-tap?filter=iraf-ctio-*&label=&color=white)
 * **iraf-fitsutil**: FITS utilities for IRAF ![GitHub Release](https://img.shields.io/github/v/release/iraf-community/homebrew-tap?filter=iraf-fitsutil-*&label=&color=white)
 * **iraf-mscred**: Mosaic CCD reduction package ![GitHub Release](https://img.shields.io/github/v/release/iraf-community/homebrew-tap?filter=iraf-mscred-*&label=&color=white)
 * **iraf-rvsao**: Radial velocities package ![GitHub Release](https://img.shields.io/github/v/release/iraf-community/homebrew-tap?filter=iraf-rvsao-*&label=&color=white)
 * **iraf-sptable**: Tabular spectra utilities ![GitHub Release](https://img.shields.io/github/v/release/iraf-community/homebrew-tap?filter=iraf-sptable-*&label=&color=white)
 * **iraf-st4gem**: Selected tasks from STSDAS ![GitHub Release](https://img.shields.io/github/v/release/iraf-community/homebrew-tap?filter=iraf-st4gem-*&label=&color=white)
 * **iraf-xdimsum**: Deep infrared mosaicing software ![GitHub Release](https://img.shields.io/github/v/release/iraf-community/homebrew-tap?filter=iraf-xdimsum-*&label=&color=white)

PyRAF can be installed from PyPI with the command

```shell
pip install pyraf
```
