#!/bin/bash

showHelp(){
    echo -e "-l\t\tPrint baned IP list"
    echo -e "-b IP\t\tBan the specified IP"
    echo -e "-u Num\t\tUnban IP of the specified number, you can get it in baned IP list"
    echo -e "-ua\t\tUnban all IP"
}

showList(){
    echo "Baned IP list:"
    iptables -L INPUT --line-numbers | sed -e '1d' | grep 'DROP'
}

addBan(){
    if [ $# -eq 1 ]; then
        iptables -I INPUT -s $1 -j DROP
        echo "Ban $1 successfully"
    fi
}

delBan(){
    if [ $# -eq 1 ]; then
        iptables -D INPUT $1
        echo "Unban No.$1 successfully"
    fi
}

delAllBan(){
    BAN_NUM_LIST=`iptables -L INPUT --line-numbers | sed -e '1d' | grep 'DROP' | awk '{print $1}'`;
    COUNT=0
    for BAN_NUM in $BAN_NUM_LIST
    do
        iptables -D INPUT $((BAN_NUM-COUNT))
        let COUNT++
    done
	echo "Unban all IP successfully"
}

case $1 in
-l)
showList
;;
-b)
addBan $2
;;
-u)
delBan $2
;;
-ua)
delAllBan
;;
*)
showHelp
;;
esac