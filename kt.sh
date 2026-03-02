#!/bin/bash


echo -e "= Vopi Building Kernal="

bold=$(tput bold)
normal=$(tput sgr0)

# Scrip option
while (( ${#} )); do
    case ${1} in
        "-Z"|"--zip") ZIP=true ;;
    esac
    shift
done
[[ -z ${ZIP} ]] && { echo "${bold} Working.....${normal}"; }

# Inherit kernelsu next
#curl -LSs "https://raw.githubusercontent.com/KernelSU-Next/KernelSU-Next/next/kernel/setup.sh" | bash -s legacy

#export KBUILD_BUILD_USER="Vopi"
#export TZ=Asia/Jakarta
#export KBUILD_BUILD_VERSION="5.4"
#export KBUILD_BUILD_TIMESTAMP="Cat.Bag"
#export KBUILD_BUILD_HOST="Tiger-cat"
#export KERNELDIR="$(pwd)"
#export KERNELNAME="Hunter-Vopi"
#export SRCDIR="${KERNELDIR}"
#export OUTDIR="${KERNELDIR}/out"
#export ANYKERNEL="${KERNELDIR}/AnyKernel3"
#export DEFCONFIG="stone_defconfig"
#export ZIP_DIR="${KERNELDIR}/files"
#export IMAGE="${OUTDIR}/arch/arm64/boot/Image"
#export VARI="AOSP"
##export DTBO="${OUTDIR}/arch/arm64/boot/dtbo.img"
#export PATH="$(pwd)/clang/bin:$PATH"


export KBUILD_BUILD_USER="Vopi"
export TZ=Asia/Jakarta
#export KBUILD_BUILD_VERSION=186
#export KBUILD_BUILD_TIMESTAMP="Fri Dec 26 08:43:17 WIB 2025"
export KBUILD_BUILD_HOST="Tiger-cat"
export KERNELDIR="$(pwd)"
export KERNELNAME="Hunter-Vopi"
export SRCDIR="${KERNELDIR}"
export OUTDIR="${KERNELDIR}/out"
export ANYKERNEL="${KERNELDIR}/AnyKernel3"
export DEFCONFIG="stone_defconfig"
export ZIP_DIR="${KERNELDIR}/files"
export IMAGE="${OUTDIR}/arch/arm64/boot/Image"
export VARI="AOSP"
#export DTBO="${OUTDIR}/arch/arm64/boot/dtbo.img"
export PATH="$(pwd)/clang/bin:$PATH"

mkdir -p out
#make O=out ARCH=arm64 $DEFCONFIG
make -j$(nproc --all) O=out ARCH=arm64 CC=clang LD=ld.lld HOSTCC=clang HOSTCXX=clang++ READELF=llvm-readelf HOSTAR=llvm-ar AR=llvm-ar AS=llvm-as NM=llvm-nm OBJCOPY=llvm-objcopy OBJDUMP=llvm-objdump STRIP=llvm-strip CROSS_COMPILE=aarch64-linux-gnu- CROSS_COMPILE_ARM32=arm-linux-gnueabi- 2>&1 | tee log.txt
    echo -e "==========================="
    echo -e "   COMPILE KERNEL COMPLETE "
    echo -e "==========================="

# Make ZIP using AnyKernel
# =======================

ZIPNAME="${KERNELNAME}-Kernel-Vopi-+I${VARI}-$(date +%Y%m%d-%H%M%S).zip"
FINAL_ZIP="${ZIP_DIR}/${ZIPNAME}"

SDCARD_DIR="/sdcard/VopiBuild/Kernel"

# Safety check
if [[ -z "${ZIP_DIR}" ]]; then
  echo "ZIP_DIR is empty, aborting"
  exit 1
fi

rm -rf "${ZIP_DIR}"
mkdir -p "${ZIP_DIR}"

echo "Copying kernel image"
cp -v "${IMAGE}" "${ANYKERNEL}/"
# cp -v "${DTBO}" "${ANYKERNEL}/"

cd "${ANYKERNEL}" || exit 1
zip -r9 "${FINAL_ZIP}" ./*

cd "${KERNELDIR}" || exit 1

# Copy ZIP to phone storage
if [[ -d "/sdcard" ]]; then
  mkdir -p "${SDCARD_DIR}"
  cp -v "${FINAL_ZIP}" "${SDCARD_DIR}/"
  echo " Saved To Vopide Storage"
  echo "➡️ ${SDCARD_DIR}/${ZIPNAME}"
else
  echo "⚠️ /sdcard not found, skipping phone copy"
fi

exit 0
