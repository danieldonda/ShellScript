!/bin/bash

# Meu primeiro script
# echo -n "Rede que quer escanear :" 
# read  rede
# echo -n "Porta aberta que quer descobrir :"
# read porta

rede="192.168.0.0/24"
porta="80"

clear
echo .............................................
echo Procurando hosts na rede $rede com a porta $porta aberta
echo ---------------------------------------------
# nmap -sS -vv -p 80 192.168.0.0/24 | grep "Discovered open port" | awk '{print$
nmap -sS -vv -p $porta $rede | grep "Discovered open port" | awk '{print $6}'
echo --------------------------------------------
