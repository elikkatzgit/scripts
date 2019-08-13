#!/bin/bash
# Powered by elkatz

list=`ls /starhome/igate |grep  spu` ; for i in $list ; do  gate=`echo $i |cut -b9-` ; echo "alias $gate=\"cd /starhome/igate/$i/DSI\"" >>  ~/.bashrc ;done ; . ~/.bashrc



list=`ls /starhome/igate |grep -v probe` ; for i in $list ; do  gate=`echo $i |cut -b9-` ; echo "alias $gate=\"cd /starhome/igate/$i\"" >>  ~/.bashrc ;done ; . ~/.bashrc