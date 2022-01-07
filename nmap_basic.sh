!/bin/bash

# Meu primeiro script
# echo -n "Rede que quer escanear :" 
# read  rede
# echo -n "Porta aberta que quer descobrir :"
# read porta

rede=$1
porta=$2

clear
echo ------------------------------------------------------------- 
echo Procurando hosts na rede $1 com a porta $2 aberta
echo -------------------------------------------------------------
# EXEMPLO DO COMANDO: nmap -sS -vv -p 80 192.168.0.0/24 | grep "Discovered open port" | awk '{print$
nmap -sS -vv -p $2 $1 | grep "Discovered open port" | awk '{print $6}'
echo --------------------------------------------
