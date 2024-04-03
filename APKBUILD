# Contributor: chakib blegaid
# Maintainer: chakib belgaid  <mohammed-chakib.belgaid@inria.fr>
pkgname=hwpc
pkgver=0.3
pkgrel=9
pkgdesc="a library to access hardware performance counters on linux"
url="www.powerapi.org/reference/sensors/hwpc-sensor/"
arch="x86_64"
license="BSD 3-Clause"
depends="libsodium-dev  musl-dev autoconf snappy libtool mongo-c-driver-dev"
depends_dev="ncurses-dev swig  python3  patch git alpine-sdk kde-dev-scripts pkgconf  "
makedepends="cmake  czmq-dev  linux-headers"
install=""
libdir="/home/packager/libs"
install="$pkgname.post-install"

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
    git clone https://github.com/chakib-belgaid/hwpc-sensor.git --branch alpine hwpc
    cd hwpc
    cmake -B build -DCMAKE_C_FLAGS="-I$libdir/libpfm4/usr/local/include" -DCMAKE_EXE_LINKER_FLAGS="-L$libdir/libpfm4/usr/local/lib"
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
    install -Dm755 hwpc/auto_hwpc_sensor.sh "$pkgdir"/usr/bin/auto-hwpc-sensor
}

clean() {
    :
}
