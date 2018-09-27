# Note that this script can accept some limited command-line arguments, run
# `julia build_tarballs.jl --help` to see a usage message.
using BinaryBuilder

name = "LibELF"
version = v"0.8.13"

# Collection of sources required to build LibELF
sources = [
    "http://www.mr511.de/software/libelf-0.8.13.tar.gz" =>
    "591a9b4ec81c1f2042a97aa60564e0cb79d041c52faa7416acb38bc95bd2c76d",

]

# Bash recipe for building across all platforms
script = raw"""
cd $WORKSPACE/srcdir
cd libelf-0.8.13/
./configure --prefix=$prefix --host=$target --target=$target --enable-shared
make -j${nproc} -C lib

cd lib
$CC -shared -Wl,-soname,libelf.so.0 -o libelf.so.0.8.13 begin.o cntl.o end.o errmsg.o errno.o fill.o flag.o getarhdr.o getarsym.o getbase.o getdata.o getident.o getscn.o hash.o kind.o ndxscn.o newdata.o newscn.o next.o nextscn.o rand.o rawdata.o rawfile.o strptr.o update.o version.o checksum.o getaroff.o 32.fsize.o 32.getehdr.o 32.getphdr.o 32.getshdr.o 32.newehdr.o 32.newphdr.o 32.xlatetof.o cook.o data.o input.o assert.o nlist.o opt.delscn.o x.remscn.o x.movscn.o x.elfext.o 64.xlatetof.o gelfehdr.o gelfphdr.o gelfshdr.o gelftrans.o swap64.o verdef_32_tof.o verdef_32_tom.o verdef_64_tof.o verdef_64_tom.o
cd ..
cp -a lib/libelf.so.0.8.13 $WORKSPACE/destdir/lib/

make -C lib install

"""

# These are the platforms we will build for by default, unless further
# platforms are passed in on the command line
platforms = [
    Linux(:i686, libc=:glibc),
    Linux(:x86_64, libc=:glibc)
]

# The products that we will ensure are always built
products(prefix) = [
    LibraryProduct(prefix, "libelf", Symbol(""))
]

# Dependencies that must be installed before this package can be built
dependencies = [
    
]

# Build the tarballs, and possibly a `build.jl` as well.
build_tarballs(ARGS, name, version, sources, script, platforms, products, dependencies)

