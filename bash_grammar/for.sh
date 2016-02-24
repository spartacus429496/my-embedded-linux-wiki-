#!/bin/bash
ans=0
for i in {1..100}
do
    let ans+=$i
done
echo $ans
ans=0
for ((i=1;i<=100;i++))
do
    let ans+=$i
done
echo $ans

for i in 'apple' 'meat' 'sleep' 'woman'
do
        echo I like $i
    done
    ip link show | awk '{if($0~/^[0-9]+:/)printf( "%-15s%-15s",$2,$9);else print $2}'
    val1=1
    val2=2
    var=$(printf 'FILE=_%s_%s.dat' $val1 $val2) 
echo $var
PREFIX=192.168.0.
for i in `seq 100 110`
do
    echo -n "${PREFIX}$i "
    ping -c5  ${PREFIX}${i} >/dev/null 2>&1
    if [ "$?" -eq 0 ];then
        echo "OK"
    else
        echo "Failed"
    fi
done
