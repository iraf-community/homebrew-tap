# This is work in progress and does not work yet. Help is appreciated.

![Be careful](https://upload.wikimedia.org/wikipedia/commons/thumb/f/f4/Baustelle.svg/2339px-Baustelle.svg.png)

# Homebrew Tap for IRAF Community

This [Homebrew tap](https://brew.sh) contains
[IRAF](https://iraf-community.github.io) and support packages. Most of
them are community maintained.

## Installation

```bash
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

 * **iraf**: Image Reduction and Analysis Facility ![GitHub Release](https://img.shields.io/github/v/release/iraf-community/homebrew-tap?filter=iraf-2*&label=Homebrew&color=blue)
 * **x11iraf**: X11 terminal emulator and image display for IRAF ![GitHub Release](https://img.shields.io/github/v/release/iraf-community/homebrew-tap?filter=x11iraf-*&label=Homebrew&color=blue)
 * **iraf-fitsutil**: FITS utilities for IRAF ![GitHub Release](https://img.shields.io/github/v/release/iraf-community/homebrew-tap?filter=iraf-fitsutil-*&label=Homebrew&color=blue)
 * **iraf-mscred**: Mosaic CCD reduction package ![GitHub Release](https://img.shields.io/github/v/release/iraf-community/homebrew-tap?filter=iraf-mscred-*&label=Homebrew&color=blue)
 * **iraf-rvsao**: Radial velocities package ![GitHub Release](https://img.shields.io/github/v/release/iraf-community/homebrew-tap?filter=iraf-rvsao-*&label=Homebrew&color=blue)
 * **iraf-sptable**: Tabular spectra utilities ![GitHub Release](https://img.shields.io/github/v/release/iraf-community/homebrew-tap?filter=iraf-sptable-*&label=Homebrew&color=blue)
 * **iraf-st4gem**: Selected tasks from STSDAS ![GitHub Release](https://img.shields.io/github/v/release/iraf-community/homebrew-tap?filter=iraf-st4gem-*&label=Homebrew&color=blue)
 * **iraf-xdimsum**: Deep Infrared Mosaicing Software ![GitHub Release](https://img.shields.io/github/v/release/iraf-community/homebrew-tap?filter=iraf-xdimsum-*&label=Homebrew&color=blue)
