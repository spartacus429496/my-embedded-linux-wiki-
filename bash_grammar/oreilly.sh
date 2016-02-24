#!/bin/bash
for i in `seq 0 1 9` 
do
#var=$(printf 'FILE=_%s_%s.dat' $val1 $val2) 
var=$(printf 'http://www.oreilly.com/openbook/linuxdrive3/book/ch0%d.pdf' $i)
wget $var -c &
done

for i in `seq 10 1 18` 
do
#var=$(printf 'FILE=_%s_%s.dat' $val1 $val2) 
var=$(printf 'http://www.oreilly.com/openbook/linuxdrive3/book/ch%d.pdf' $i)
wget $var -c &
done


wget http://www.oreilly.com/openbook/linuxdrive3/book/ldr3TOC.fm.pdf -c &
