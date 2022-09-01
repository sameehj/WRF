## Install Spack (only pull if does not exist)
git -C ~/spack pull || git clone -c feature.manyFiles=true https://github.com/spack/spack.git ~/spack

## Remember to add add to bashrc[!]
source ~/spack/share/spack/setup-env.sh

## Install UCX and Open MPI using Spack
spack install openmpi fabrics=ucx
spack load ucx
spack load openmpi

source ~/spack/share/spack/setup-env.sh


spack load ucx
spack load openmpi


## Clone ADIOS2
git -C ./ADIOS2 pull || git clone https://github.com/sameehj/ADIOS2 ./ADIOS2
pushd ADIOS2
git checkout ucx-sst
popd

### compile ADIOS2 with UCX
mkdir -p adios2-build && pushd adios2-build
cmake -DUCX_ROOT=$(spack location -i ucx) -DADIOS2_USE_Python=ON -DCMAKE_DISABLE_FIND_PACKAGE_BISON=TRUE -DCMAKE_DISABLE_FIND_PACKAGE_FLEX=TRUE ../ADIOS2
make -j2
#ctest -R SST
popd

export ADIOS2_BIN_PATH=`pwd`/adios2-build/bin
cp packages.yaml.org packages.yaml
sed -i "s|ADIOS2_BIN_PATH|$ADIOS2_BIN_PATH|g" packages.yaml
mv packages.yaml ${HOME}/.spack/
