# Note that this script can accept some limited command-line arguments, run
# `julia build_tarballs.jl --help` to see a usage message.
using BinaryBuilder

name = "Fontconfig"
version = v"2.13.1"

# Collection of sources required to build Fontconfig
sources = [
    "https://www.freedesktop.org/software/fontconfig/release/fontconfig-2.13.1.tar.gz" =>
    "9f0d852b39d75fc655f9f53850eb32555394f36104a044bb2b2fc9e66dbbfa7f",

]

# Bash recipe for building across all platforms
 # weird issue with uuid/uuid.h not being found without C_INCLUDE_PATH
script = raw"""
cd $WORKSPACE/srcdir/fontconfig-2.13.1/
export C_INCLUDE_PATH=$prefix/include:$C_INCLUDE_PATH
./configure --prefix=$prefix --host=$target
make
make install
"""

# These are the platforms we will build for by default, unless further
# platforms are passed in on the command line
platforms = supported_platforms()

# The products that we will ensure are always built
products(prefix) = [
    LibraryProduct(prefix, "libfontconfig", :libfontconfig),
    ExecutableProduct(prefix, "fc-query", :fc_query),
    ExecutableProduct(prefix, "fc-list", :fc_list),
    ExecutableProduct(prefix, "fc-validate", :fc_validate),
    ExecutableProduct(prefix, "fc-cat", :fc_cat),
    ExecutableProduct(prefix, "fc-conflist", :fc_conflist),
    ExecutableProduct(prefix, "fc-match", :fc_match),
    ExecutableProduct(prefix, "fc-scan", :fc_scan),
    ExecutableProduct(prefix, "fc-pattern", :fc_pattern),
    ExecutableProduct(prefix, "fc-cache", :fc_cache)
]

# Dependencies that must be installed before this package can be built
dependencies = [
    "https://github.com/bjarthur/ExpatBuilder/releases/download/v2.2.6/build_Expat.v2.2.6.jl",
    "https://github.com/bjarthur/UtilLinuxBuilder/releases/download/v2.32/build_UtilLinux.v2.32.0.jl",
    "https://github.com/JuliaGraphics/FreeTypeBuilder/releases/download/v2.9.1-1/build_FreeType2.v2.9.1.jl",
    "https://github.com/bjarthur/GperfBuilder/releases/download/v3.1.0/build_GperfBuilder.v3.1.0.jl"
]

# Build the tarballs, and possibly a `build.jl` as well.
build_tarballs(ARGS, name, version, sources, script, platforms, products, dependencies)
