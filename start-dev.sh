#!/bin/sh

cd `dirname $0`


ulimit -n 10240
ulimit -c unlimited

export ERL_LIBS=$PWD/lib
exec erl -args_file $PWD/conf/vm.args -pa $PWD/ebin -s loadtest
