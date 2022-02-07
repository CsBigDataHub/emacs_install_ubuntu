# MIT License
#
# Copyright (c) 2022 CK
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

branch=${1}

if [ -d ~/git-repos ]; then
    if [ -d ~/git-repos/emacs ]; then
        echo "Assuming emacs repo is already cloned"
    else
        git clone git://git.savannah.gnu.org/emacs.git ~/git-repos/emacs
    fi
else
    echo "Cloning emacs repo for the first time"
    mkdir -p ~/git-repos
    git clone git://git.savannah.gnu.org/emacs.git ~/git-repos/emacs
fi

cd ~/git-repos/emacs

git clean -xdf

git reset --hard

git checkout -b ${branch} origin/{branch}

git pull

sudo apt update

sudo apt install -y autoconf make gcc texinfo libgtk-3-dev libxpm-dev \
     libjpeg-dev libgif-dev libtiff5-dev libgnutls28-dev libncurses5-dev \
     libjansson-dev libharfbuzz-dev libharfbuzz-bin imagemagick libmagickwand-dev libgccjit-10-dev libgccjit0 gcc-10 libjansson4 libjansson-dev xaw3dg-dev texinfo libx11-dev

export CC="gcc-10"

./autogen.sh

./configure --with-native-compilation -with-json \
            --with-modules --with-harfbuzz --with-compress-install \
            --with-threads --with-included-regex --with-x-toolkit=lucid \
            --with-zlib --with-jpeg --with-png --with-imagemagick --with-tiff \
            --with-xpm --with-gnutls --with-xft \
            # --with-pgtk \ #only on emacs-29
            --with-xml2 --with-mailutils

make NATIVE_FULL_AOT=1 -j $(nproc)
sudo make install
