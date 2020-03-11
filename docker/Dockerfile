FROM ubuntu:bionic 

RUN apt-get update && apt-get install -y curl software-properties-common

ARG ARCH=x86_64
ARG DLLS="libgcc_s_sjlj-1.dll libgomp-1.dll libstdc++-6.dll"

#if test "$ARCH" != "i686"; then
#  ARCH=x86_64
#  DLLS="libgcc_s_seh-1.dll libgomp-1.dll libstdc++-6.dll"
#fi

ARG ROOTDIR=$PWD
ARG DISTDIR=$ROOTDIR/dist
ARG HOST=$ARCH-w64-mingw32
ARG BUILDDIR=bin/ndebug/$HOST-$TAG
ARG PKG_ARCH=mingw64-${ARCH/_/-}

# Install cygwin key and add cygwin sources.
RUN curl -s https://qemu.weilnetz.de/debian/gpg.key | apt-key add -\
&& echo deb https://qemu.weilnetz.de/debian/ testing contrib | \
  tee /etc/apt/sources.list.d/cygwin.list

# Install packages.
RUN apt-get update && apt-get install --no-install-recommends \
  asciidoc xsltproc docbook-xsl \
  mingw-w64-tools nsis g++-mingw-w64-${ARCH/_/-} \
  $PKG_ARCH-liblept5 $PKG_ARCH-curl \
  $PKG_ARCH-libarchive $PKG_ARCH-giflib $PKG_ARCH-libpng \
  $PKG_ARCH-libwebp $PKG_ARCH-openjpeg2 $PKG_ARCH-tiff \
  $PKG_ARCH-pango1.0 $PKG_ARCH-icu

for dll in $DLLS; do
  ln -sf /usr/lib/gcc/$HOST/*-posix/$dll dll/$HOST
done

file dll/$HOST/*

ARG TAG=5.0.0-alpha.$(date +%Y%m%d)

RUN git config --global user.email "sw@weilnetz.de"\
&& git config --global user.name "Stefan Weil"\ 
&& git tag -a v$TAG -m "Tesseract $TAG"

RUN ./autogen.sh

# Build Tesseract installer.
RUN mkdir -p $BUILDDIR && cd $BUILDDIR

# Run configure.
RUN ../../../configure --disable-openmp --host=$HOST --prefix=/usr/$HOST \
  CXX=$HOST-g++-posix \
  CXXFLAGS="-fno-math-errno -Wall -Wextra -Wpedantic -g -O2"

RUN make install-jars install training-install html winsetup prefix=$PWD/usr/$HOST

# Copy result for upload.
RUN mkdir -p $DISTDIR && cp nsis/tesseract-ocr-w*-setup-*.exe $DISTDIR
