#!/bin/bash

signer="alex@nitrokey.com"
tag=v1.3.1
git_hash=$(git rev-parse --short HEAD)

echo
echo "You will need your signing keys available for the next steps..."
echo

# set git tag
git tag -s $tag -m "NitroPad $tag"

echo "Now build the rom(s) again, to get tag enabled. Press enter afterwards to finish..."
echo "E.g. 'make BOARD=x230-hotp-verification' and 'make BOARD=t430'"
read

workdir=$(pwd)
mkdir -p release_$tag

# x230
mkdir -p /tmp/verified_rom
cp build/x230-hotp-verification/nitropad-$tag-$git_hash.rom /tmp/verified_rom
cd /tmp/verified_rom
sha256sum /tmp/verified_rom/nitropad-$tag-"$git_hash".rom > sha256sum.txt
gpg --detach-sign --sign-with $signer sha256sum.txt
echo "Zipping files for .npf file..."
zip nitropad-x230-"$tag".npf nitropad-$tag-$git_hash.rom sha256sum.txt sha256sum.txt.sig
echo
# copy release files
cp *.rom $workdir/release_$tag/nitropad-x230-$tag-$git_hash.rom
cp *.npf $workdir/release_$tag/
cd $workdir
rm -rf /tmp/verified_rom/

# t430
mkdir -p /tmp/verified_rom/
cp build/t430/nitropad-$tag-$git_hash.rom /tmp/verified_rom
cd /tmp/verified_rom
sha256sum /tmp/verified_rom/nitropad-$tag-"$git_hash".rom > sha256sum.txt
gpg --detach-sign --sign-with $signer sha256sum.txt
echo "Zipping files for .npf file..."
zip nitropad-t430-"$tag".npf nitropad-$tag-$git_hash.rom sha256sum.txt sha256sum.txt.sig
echo
# copy release files
cp *.rom $workdir/release_$tag/nitropad-t430-$tag-$git_hash.rom
cp *.npf $workdir/release_$tag/
cd $workdir
rm -rf /tmp/verified_rom/

# sign combined
cd release_$tag
sha256sum *.rom *.npf > sha256sum.txt
gpg --detach-sign --sign-with $signer sha256sum.txt
cd $workdir

echo "Now upload all files in folder release_$tag."
echo
