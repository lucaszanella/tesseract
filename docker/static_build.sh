#--disable-shared
cd /home/project
ls
./autogen.sh
./configure --disable-openmp --enable-static LDFLAGS='-static -static-libgcc -static-libstdc++'\
  --host=$HOST --prefix=/usr/$HOST \
  CXX=$HOST-g++-posix \
  CXXFLAGS="-fno-math-errno -Wall -Wextra -Wpedantic -g -O2"

mkdir -p /home/install_prefix

make prefix=/home/install_prefix
#make install
