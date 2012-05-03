#!/bin/bash
echo 
min=1000000
max=0
while read v
do
    [ $min -gt $v ] && min=$v
    [ $max -lt $v ] && max=$v
done < <(grep -v CRASH /tmp/loadtest_writer.log)

echo "====[ WRITER ] ===="
echo "     Min: $min"
echo "     Max: $max"
echo "     Avg: `expr $( grep -v CRASH /tmp/loadtest_writer.log | awk '{ sum+=$1 } END {print sum}' ) / $( grep -v CRASH /tmp/loadtest_writer.log | wc -l )`"
echo " Crashes: `grep CRASH /tmp/loadtest_writer.log | wc -l`"
echo "    Reqs: `grep -v CRASH /tmp/loadtest_writer.log | wc -l`"

echo
min=1000000
max=0
while read v
do
    [ $min -gt $v ] && min=$v
    [ $max -lt $v ] && max=$v
done < <(grep -v CRASH /tmp/loadtest_reader.log)

echo "====[ READER ] ===="
echo "     Min: $min"
echo "     Max: $max"
echo "     Avg: `expr $( grep -v CRASH /tmp/loadtest_reader.log | awk '{ sum+=$1 } END {print sum}' ) / $( grep -v CRASH /tmp/loadtest_reader.log | wc -l )`"
echo " Crashes: `grep CRASH /tmp/loadtest_reader.log | wc -l`"
echo "    Reqs: `grep -v CRASH /tmp/loadtest_reader.log | wc -l`"

echo
