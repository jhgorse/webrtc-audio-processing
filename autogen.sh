#!/bin/sh
glibtoolize
aclocal
automake --add-missing --copy
autoconf
./configure ${@}
