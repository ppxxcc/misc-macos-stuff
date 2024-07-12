#!/usr/bin/env sh

prefix=/opt/toolchains/fpga/utilities

echo "\nPrefix is $prefix\n"

echo "Xcode must be set to Xcode.app and not CLT to build iverilog."
echo "Changing Xcode..."
sudo xcode-select -s /Applications/Xcode.app/Contents/Developer


echo "Creating temporary working directory..."
mkdir setup
cd setup
# Make GTKWave
echo "Working on GTKWave..."
sleep 2

# Get dependencies
echo "Getting dependencies..."
sleep 2
brew install desktop-file-utils shared-mime-info gobject-introspection gtk-mac-integration meson ninja pkg-config gtk+3

# Get GTKWave source
echo "Getting GTKWave..."
sleep 2
git clone https://github.com/gtkwave/gtkwave gtkwave

# Set up the build
echo "Building GTKWave..."
sleep 2
cd gtkwave
meson setup --prefix $prefix build
meson compile -C build
meson install -C build

echo '#!/usr/bin/env sh' > $prefix/bin/gtkw
echo 'gtkwave "$@" 2>/dev/null &' >> $prefix/bin/gtkw
chmod +x $prefix/bin/gtkw

######################################################################################

# Download and setup GHDL
echo "Working on GHDL..."
sleep 2

# Download from Github
echo "Downloading release..."
sleep 2
curl -OL https://github.com/ghdl/ghdl/releases/download/v4.1.0/ghdl-macos-11-mcode.tgz

# Unpack
echo "Unpacking..."
sleep 2
mkdir ghdl
tar -xzf ghdl-macos-11-mcode.tgz -C ghdl

# Copy files over
echo "Installing files..."
sleep 2
xattr -r -d com.apple.quarantine ghdl
cp -rv ghdl/bin/*     $prefix/bin
cp -rv ghdl/lib/*     $prefix/lib
cp -rv ghdl/include/* $prefix/include

####################################################################################

# Build iverilog
echo "Working on iverilog..."
sleep 2

# Downloading dependencies
echo "Downloading dependencies..."
sleep 2
brew install autoconf gperf bison

# Download repository from Github
echo "Downloading repository..."
sleep 2
git clone https://github.com/steveicarus/iverilog iverilog

# Configuring iverilog
echo "Configuring iverilog..."
sleep 2
cd iverilog
export PATH=/opt/homebrew/opt/bison/bin:$PATH
sh autoconf.sh
./configure --prefix=$prefix
echo "Building iverilog..."
sleep 2
make install

echo "Restoring Xcode back to CLT..."
sudo xcode-select -s /Library/Developer/CommandLineTools

echo "Cleaning up files..."
sleep 2
cd ../..
rm -rf $prefix/setup

echo "\nInstallation complete!\n"


