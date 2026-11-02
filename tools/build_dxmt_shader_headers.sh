#!/bin/bash
# Generate DXMT's airconv shader headers (air_msad.h, air_samplepos.h, air_tessellation.h) the way DXMT's meson does (metal -> xxd -n NAME -i),
# which build/dxmt-ios/build.sh does not do. Compile the pinned shader source unchanged;
# the available Metal compiler accepts the original four-argument atomic intrinsic.
set -eu
R="$(cd "$(dirname "$0")/../vendor/Madeira" && pwd)"
SRC="$R/dxmt/src/airconv/shaders"; OUT="$R/build/dxmt-ios/shader-headers"; mkdir -p "$OUT"; cd "$OUT"
for n in air_msad air_samplepos air_tessellation; do
  in="$SRC/$n.metal"
  xcrun -sdk macosx metal -o "$n.air" -c "$in" -std=metal3.1 --target=air64-apple-macos14.0
  xxd -n "$n" -i "$n.air" "$n.h"
  echo "$n.h $(wc -c < $n.h) bytes"
done
