# Contributor: chakib blegaid
# Maintainer: chakib belgaid  <mohammed-chakib.belgaid@inria.fr>
pkgname=hwpc
pkgver=$GIT_TAG
pkgrel=$GIT_REV
pkgdesc="a library to access hardware performance counters on linux"
url="www.powerapi.org/reference/sensors/hwpc-sensor/"
arch="x86_64"
license="BSD 3-Clause"
depends="libsodium-dev  musl-dev autoconf snappy libtool mongo-c-driver-dev"
depends_dev="ncurses-dev swig  python3  patch git alpine-sdk kde-dev-scripts pkgconf  "
makedepends="cmake  czmq-dev json-c-dev linux-headers "
install=""
libdir="/home/packager/libs"
# install="$pkgname.post-install"

prepare() {
    # Replace with proper prepare command(s)
    :

    if [ -d "libpfm4" ]; then
        rm -rf "libpfm4"
    fi
    git clone -b smartwatts https://github.com/gfieni/libpfm4.git libpfm4
    cd libpfm4
    make install DESTDIR=$libdir/libpfm4
    cd ../

}

build() {
    # Replace with proper build command(s)
    if [ -d "hwpc" ]; then
        rm -rf "hwpc"
    fi
    git clone https://github.com/chakib-belgaid/hwpc-sensor.git --branch alpine2 hwpc
    cd hwpc
    
    sed -i 's/find_package(LibPFM REQUIRED)/# find_package(LibPFM REQUIRED)/' CMakeLists.txt
    sed -i 's/add_compile_options(-Werror -Wall -Wextra -Wpedantic -Wformat=2 -Wnull-dereference -Wno-gnu-statement-expression)/add_compile_options(-Wall -Wextra -Wpedantic -Wformat=2 -Wnull-dereference)/' CMakeLists.txt

    sed -i 's/target_link_libraries(hwpc-sensor "${LIBPFM_LIBRARIES}" "${CZMQ_LIBRARIES}" "${JSONC_LIBRARIES}" "${MONGOC_LIBRARIES}")/target_link_libraries(hwpc-sensor "${CZMQ_LIBRARIES}" pfm "${JSONC_LIBRARIES}" "${MONGOC_LIBRARIES}")/' CMakeLists.txt
    
    cmake -B build -DCMAKE_C_FLAGS="-I$libdir/libpfm4/usr/local/include"  -DCMAKE_EXE_LINKER_FLAGS="-L$libdir/libpfm4/usr/local/lib" -DCMAKE_BUILD_TYPE="${BUILD_TYPE}"  -DWITH_MONGODB="${MONGODB_SUPPORT}" 
    cmake --build build  
    echo "build done"
}

check() {
    # Replace with proper check command(s)
    :
}

package() {
    # Replace with proper package command(s)
    install -Dm755 hwpc/build/hwpc-sensor "$pkgdir"/usr/bin/hwpc-sensor
    install -Dm644 "$libdir"/libpfm4/usr/local/lib/libpfm.so.4 "$pkgdir"/usr/lib/libpfm.so.4
    # install -Dm755 hwpc/auto_hwpc_sensor.sh "$pkgdir"/usr/bin/auto-hwpc-sensor
}

clean() {
    :
}
