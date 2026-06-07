#!/bin/bash
set -e

if [ -z "$VLLM_VERSION_OVERRIDE" ]; then
    echo "Error: VLLM_VERSION_OVERRIDE is required"
    echo "Usage: VLLM_VERSION_OVERRIDE=2.2.1 bash build_lvllmds4.sh"
    exit 1
fi

PROJECT_DIR=$(pwd)
export TMPDIR=~/Downloads/tmp
export CMAKE_BUILD_TYPE=Release
export CMAKE_ARGS="-DCMAKE_BUILD_TYPE=Release"
export LD_LIBRARY_PATH=/home/guqiong/.conda/envs/$CONDA_DEFAULT_ENV/lib/python3.12/site-packages/torch/lib:$LD_LIBRARY_PATH

mkdir -p $TMPDIR

rm -f dist/lvllmds4-${VLLM_VERSION_OVERRIDE}-cp312-cp312-linux_x86_64.whl
rm -f dist/lvllmds4-${VLLM_VERSION_OVERRIDE}-cp312-cp312-manylinux_2_34_x86_64.whl
rm -f dist/lvllmds4-${VLLM_VERSION_OVERRIDE}-cp312-cp312-manylinux_2_34_x86_64_stripped.whl

VLLM_VERSION_OVERRIDE="$VLLM_VERSION_OVERRIDE" pip install -e . --no-build-isolation -vvv
VLLM_VERSION_OVERRIDE="$VLLM_VERSION_OVERRIDE" pip wheel . --no-build-isolation -v --wheel-dir=dist

ORIGINAL_WHL=$(ls dist/lvllmds4-${VLLM_VERSION_OVERRIDE}-cp312-cp312-linux_x86_64.whl | head -1)

auditwheel repair "$ORIGINAL_WHL" -w dist/ \
  --exclude libtorch_cuda.so --exclude libtorch_cpu.so --exclude libtorch_python.so \
  --exclude libtorch.so --exclude libtorch_nvshmem.so \
  --exclude libc10.so --exclude libc10_cuda.so \
  --exclude libcuda.so.595.58.03 --exclude libcudart.so.13 --exclude libcudart.so.13.2.75 \
  --exclude libnvrtc.so.13 --exclude libnvrtc.so.13.2.78 --exclude libnvJitLink.so.13 \
  --exclude libcublas.so.13 --exclude libcublasLt.so.13 --exclude libcufft.so.12 \
  --exclude libcusparse.so.12 --exclude libcusparseLt.so.0 --exclude libcurand.so.10 \
  --exclude libcudnn.so.9 --exclude libnccl.so.2 --exclude libnvshmem_host.so.3 \
  --exclude libcupti.so.13 --exclude libcufile.so.0 --exclude libgomp.so.1 --exclude libshm.so

REPAIRED_FILE=$(ls dist/lvllmds4-${VLLM_VERSION_OVERRIDE}-cp312-cp312-manylinux_2_34_x86_64.whl | head -1)
FINAL_WHL="dist/lvllmds4-${VLLM_VERSION_OVERRIDE}-cp312-cp312-manylinux_2_34_x86_64_stripped.whl"

TMP_DIR=$(mktemp -d)
cd "$TMP_DIR"
unzip -q "$PROJECT_DIR/$REPAIRED_FILE"
rm -rf lvllmds4.libs/
grep -v "lvllmds4.libs/" lvllmds4-*.dist-info/RECORD > RECORD.tmp
mv RECORD.tmp lvllmds4-*.dist-info/RECORD
zip -qr "$PROJECT_DIR/$FINAL_WHL" .
rm -rf "$TMP_DIR"
rm -f "$PROJECT_DIR/$REPAIRED_FILE"
cd "$PROJECT_DIR"

FINAL_NAME="dist/lvllmds4-${VLLM_VERSION_OVERRIDE}-cp312-cp312-manylinux_2_34_x86_64.whl"
mv "$FINAL_WHL" "$FINAL_NAME"

echo ""
echo "Wheel: $(ls -lh $FINAL_NAME | awk '{print $5}')"
echo "Usage: VLLM_VERSION_OVERRIDE=2.2.1 bash build_lvllmds4.sh"