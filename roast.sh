#!/bin/bash

#load1 () { sleep .5;echo -ne .;sleep .5;echo -ne .;sleep .5;echo -ne .;sleep .4;echo -ne .;echo -ne .;sleep .2; }
#load2 () { sleep .2;echo -ne .;sleep .1;echo -ne .;sleep .1;echo -ne .;sleep .1;echo -ne .;echo -ne .;sleep .1; }

# Valores coletados do site https://docs.microsoft.com/pt-br/troubleshoot/windows-server/identity/useraccountcontrol-manipulate-account-properties
# SCRIPT=1
# ACCOUNTDISABLE=2
# HOMEDIR_REQUIRED=8
# LOCKOUT=16
# PASSWD_NOTREQD=32
# PASSWD_CANT_CHANGE = 64
# ENCRYPTED_TEXT_PWD_ALLOWED= 128
# TEMP_DUPLICATE_ACCOUNT=256
# NORMAL_ACCOUNT=512
# INTERDOMAIN_TRUST_ACCOUNT=2048
# WORKSTATION_TRUST_ACCOUNT=4096
# SERVER_TRUST_ACCOUNT=8192
# DONT_EXPIRE_PASSWORD=65536
# MNS_LOGON_ACCOUNT=131072
# SMARTCARD_REQUIRED=262144
# TRUSTED_FOR_DELEGATION=524288
# NOT_DELEGATED=1048576
# USE_DES_KEY_ONLY=2097152
# DONT_REQ_PREAUTH=4194304
# PASSWORD_EXPIRED=8388608
# TRUSTED_TO_AUTH_FOR_DELEGATION=16777216
# PARTIAL_SECRETS_ACCOUNT=67108864

# Variaveis basicas - Devbo incrementar com outros atrubutos
#SAE = DONT_EXPIRE_PASSWORD + NORMAL_ACCOUNT + DONT_REQ_PREAUTH = 4260352
#SAD = DONT_EXPIRE_PASSWORD + NORMAL_ACCOUNT + DONT_REQ_PREAUTH + ACCOUNTDISABLE = 4260354
#NAP = DONT_EXPIRE_PASSWORD + NORMAL_ACCOUNT + DONT_REQ_PREAUTH + PASSWD_NOTREQD = 4260384
#NAE = NORMAL_ACCOUNT + DONT_REQ_PREAUTH = 4194816
#NAD = NORMAL_ACCOUNT + DONT_REQ_PREAUTH + ACCOUNTDISABLE = 4194818

#Variaveis
SAE=4260352
SAD=4260354
NAP=4260384
NAE=4194816
NAD=4194818

#Variavei desabilitadas no momento. Alterar diretamente no codigo.
# DC=$1
#USER=$2
# DN=$3

#Verificação de passagem de parametro desabilitada 
# 
# if [[ $# -eq 0 ]] ; then
#    echo 'Use ./roast DomainController [nome de usuário]@dominio Distinguished names (DNs)  '
#     exit 0
# fi

clear

banner() {
printf "\033[1;37m @@@@@@@    @@@@@@    @@@@@@    @@@@@@   @@@@@@@ \n"
printf "\033[1;37m @@@@@@@@  @@@@@@@@  @@@@@@@@  @@@@@@@   @@@@@@@ \n"
printf "\033[1;37m @@!  @@@  @@!  @@@  @@!  @@@  !@@         @@!  \n"
printf "\033[1;37m !@!  @!@  !@!  @!@  !@!  @!@  !@!         !@!  \n"
printf "\033[1;37m @!@!!@!   @!@  !@!  @!@!@!@!  !!@@!!      @!!  \n"
printf "\033[1;37m !!@!@!    !@!  !!!  !!!@!!!!   !!@!!!     !!!  \n"
printf "\033[1;37m !!: :!!   !!:  !!!  !!:  !!!       !:!    !!:  \n"
printf "\033[1;37m :!:  !:!  :!:  !:!  :!:  !:!      !:!     :!:  \n"
printf "\033[1;37m ::   :::  ::::: ::  ::   :::  :::: ::      ::  \n"
printf "\033[1;37m :    : :   : :  :    :   : :  :: : :       :  \n"

printf "\033[0;36m+=================================================+ \n"
printf "| Usuarios do AD com Don't_Req_Preauth habilitado | \n"
printf "+=================================================+ \n"
}

banner
echo -e "\033[0;33m"

#linah de execução usando os parametros desabilitado - alterar o codigo abaixo
# ldapsearch -x -h $1  -D $2  -W  -b $3 UserAccountControl > uac.txt


ldapsearch -x -h w2k16adds.itsec.lab  -D "administrator@itsec.lab" -W  -b "dc=itsec,dc=lab" UserAccountControl > uac.txt
TOTAL=`egrep "$SAE|$SAD|$NAP|$NAE|$NAD" uac.txt | wc -l`

$amarelo
printf "\033[0;36m--------------------------------------------------------------------------------------------- \n"
printf "\033[1;37mForam encontrados \033[0;33m $TOTAL \033[1;37m usuario(s) com a opção do not require Kerberos preauth habilitada \n"
printf "\033[0;36m--------------------------------------------------------------------------------------------- \n"


printf "\n\033[33m[\e[0;36m✔\033[0;33m] \033[1;37mConta de serviço habilitada - DONT_EXPIRE_PASSWORD + NORMAL_ACCOUNT + DONT_REQ_PREAUT \033[0;36m \n"
grep -B 2  "$SAE" uac.txt

printf "\n\033[33m[\e[0;36m✔\033[0;33m] \033[1;37mConta de serviço desabilitada - DONT_EXPIRE_PASSWORD + NORMAL_ACCOUNT + ACCOUNTDISABLE + DONT_REQ_PREAUT \033[0;36m \n"
grep -B 2  "$SAD" uac.txt

printf "\n\033[33m[\e[0;36m✔\033[0;33m] \033[1;37mConta habilitada não requer senha - DONT_EXPIRE_PASSWORD + NORMAL_ACCOUNT + PASSWD_NOTREQD + DONT_REQ_PREAUT \033[0;36m \n"
grep -B 2  "$NAP" uac.txt

printf "\n\033[33m[\e[0;36m✔\033[0;33m] \033[1;37mConta habilitada - NORMAL_ACCOUNT + DONT_REQ_PREAUT \033[0;36m \n"
grep -B 2  "$NAE" uac.txt

printf "\n\033[33m[\e[0;36m✔\033[0;33m] \033[1;37mConta desabitada - NORMAL_ACCOUNT + ACCOUNTDISABLE + DONT_REQ_PREAUT \033[0;36m \n"
grep -B 2  "$NAD" uac.txt

