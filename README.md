# Custom VLC patches

This repository contains source patches for **VLC 3.0.24 on macOS**. It does
not contain a VLC checkout, media files, dependencies, or a prebuilt
application bundle.

## Fullscreen Trash button

`patches/vlc-3.0.24-fullscreen-trash.patch` adds a **Trash** button to VLC's
fullscreen controls. The button is available only for a current local file.
After an explicit confirmation:

1. macOS moves that file to the Trash using `NSFileManager`.
2. VLC removes that exact item from its playlist.
3. VLC begins the next enabled item in playlist order, wrapping to the first
   enabled item when the deleted item was last.

If the move to Trash fails, VLC shows the macOS error and leaves playback and
the playlist unchanged. It never deletes network streams or files that are not
the current local media item.

## Fullscreen file size

`patches/vlc-3.0.24-fullscreen-file-size.patch` appends the current local
file's human-readable size to the fullscreen title, for example:

```
My Film.mkv (1.4 GB)
```

It reuses VLC's compatibility-aware byte formatter, respects the system
locale, and leaves stream titles unchanged. The patch requires the fullscreen
Trash patch above, so use the helper script to apply both in order.

## Apply the patch

Download and unpack the official VLC **3.0.24** source release, then run:

```sh
./scripts/apply-vlc-3.0.24-patch.sh /absolute/path/to/vlc-3.0.24
```

The script first performs a dry run and refuses to apply to a source tree that
does not contain the expected macOS interface files. To test without modifying
the source tree:

```sh
cd /absolute/path/to/vlc-3.0.24
/absolute/path/to/custom-vlc/scripts/apply-vlc-3.0.24-patch.sh "$(pwd)"
```

## Build on Apple Silicon

With Xcode and its command-line tools installed, create an out-of-tree build
directory next to the patched source checkout:

```sh
mkdir /absolute/path/to/vlc-3.0.24-build
cd /absolute/path/to/vlc-3.0.24-build
/absolute/path/to/vlc-3.0.24/extras/package/macosx/build.sh -a arm64
```

The resulting app is created in that build directory as `VLC.app`. VLC's
macOS build downloads and compiles its own dependencies, so it can take a long
time and needs a working network connection.

## Scope and license

This patch is intentionally pinned to VLC 3.0.24; do not assume it applies to
another VLC version without a dry run. The changes derive from VLC source and
are provided under VLC's GPL-2.0-or-later license.
