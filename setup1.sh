#!/bin/bash
dateFromServer=$(curl -v --insecure --silent https://google.com/ 2>&1 | grep Date | sed -e 's/< Date: //')
biji=`date +"%Y-%m-%d" -d "$dateFromServer"`
#########################
# https://raw.githubusercontent.com/kenDevXD/permission/main/ipmini 
MYIP=$(curl -sS ipv4.icanhazip.com)

clear
red='\e[1;31m'
green='\e[0;32m'
yell='\e[1;33m'
tyblue='\e[1;36m'
NC='\e[0m'
purple() { echo -e "\\033[35;1m${*}\\033[0m"; }
tyblue() { echo -e "\\033[36;1m${*}\\033[0m"; }
yellow() { echo -e "\\033[33;1m${*}\\033[0m"; }
green() { echo -e "\\033[32;1m${*}\\033[0m"; }
red() { echo -e "\\033[31;1m${*}\\033[0m"; }
cd /root
#System version number
if [ "${EUID}" -ne 0 ]; then
		echo "You need to run this script as root"
		exit 1
fi
if [ "$(systemd-detect-virt)" == "openvz" ]; then
		echo "OpenVZ is not supported"
		exit 1
fi

localip=$(hostname -I | cut -d\  -f1)
hst=( `hostname` )
dart=$(cat /etc/hosts | grep -w `hostname` | awk '{print $2}')
if [[ "$hst" != "$dart" ]]; then
echo "$localip $(hostname)" >> /etc/hosts
fi
mkdir -p /etc/xray

echo -e "[ ${tyblue}NOTES${NC} ] Before we go.. "
sleep 1
echo -e "[ ${tyblue}NOTES${NC} ] I need check your headers first.."
sleep 2
echo -e "[ ${green}INFO${NC} ] Checking headers"
sleep 1
totet=`uname -r`
REQUIRED_PKG="linux-headers-$totet"
PKG_OK=$(dpkg-query -W --showformat='${Status}\n' $REQUIRED_PKG|grep "install ok installed")
echo Checking for $REQUIRED_PKG: $PKG_OK
if [ "" = "$PKG_OK" ]; then
  sleep 2
  echo -e "[ ${yell}WARNING${NC} ] Try to install ...."
  echo "No $REQUIRED_PKG. Setting up $REQUIRED_PKG."
  apt-get --yes install $REQUIRED_PKG
  sleep 1
  echo ""
  sleep 1
  echo -e "[ ${tyblue}NOTES${NC} ] If error you need.. to do this"
  sleep 1
  echo ""
  sleep 1
  echo -e "[ ${tyblue}NOTES${NC} ] 1. apt update -y"
  sleep 1
  echo -e "[ ${tyblue}NOTES${NC} ] 2. apt upgrade -y"
  sleep 1
  echo -e "[ ${tyblue}NOTES${NC} ] 3. apt dist-upgrade -y"
  sleep 1
  echo -e "[ ${tyblue}NOTES${NC} ] 4. reboot"
  sleep 1
  echo ""
  sleep 1
  echo -e "[ ${tyblue}NOTES${NC} ] After rebooting"
  sleep 1
  echo -e "[ ${tyblue}NOTES${NC} ] Then run this script again"
  echo -e "[ ${tyblue}NOTES${NC} ] if you understand then tap enter now"
  read
else
  echo -e "[ ${green}INFO${NC} ] Oke installed"
fi

ttet=`uname -r`
ReqPKG="linux-headers-$ttet"
if ! dpkg -s $ReqPKG  >/dev/null 2>&1; then
  rm /root/setup.sh >/dev/null 2>&1 
  exit
else
  clear
fi


secs_to_human() {
    echo "Installation time : $(( ${1} / 3600 )) hours $(( (${1} / 60) % 60 )) minute's $(( ${1} % 60 )) seconds"
}
start=$(date +%s)
ln -fs /usr/share/zoneinfo/Asia/Jakarta /etc/localtime
sysctl -w net.ipv6.conf.all.disable_ipv6=1 >/dev/null 2>&1
sysctl -w net.ipv6.conf.default.disable_ipv6=1 >/dev/null 2>&1

coreselect=''
cat> /root/.profile << END
# ~/.profile: executed by Bourne-compatible login shells.

if [ "$BASH" ]; then
  if [ -f ~/.bashrc ]; then
    . ~/.bashrc
  fi
fi

mesg n || true
clear
END
chmod 644 /root/.profile

echo -e "[ ${green}INFO${NC} ] Preparing the install file"
apt install git curl -y >/dev/null 2>&1
echo -e "[ ${green}INFO${NC} ] Aight good ... installation file is ready"
sleep 2
sleep 3

mkdir -p /etc/alexxa
mkdir -p /etc/alexxa/theme
mkdir -p /var/lib/alexxa-pro >/dev/null 2>&1
echo "IP=" >> /var/lib/alexxa-pro/ipvps.conf

if [ -f "/etc/xray/domain" ]; then
echo ""
echo -e "[ ${green}INFO${NC} ] Script Already Installed"
echo -ne "[ ${yell}WARNING${NC} ] Do you want to install again ? (y/n)? "
read answer
if [ "$answer" == "${answer#[Yy]}" ] ;then
rm setup.sh
sleep 10
exit 0
else
clear
fi
fi

echo ""
wget -q https://raw.githubusercontent.com/kenDevXD/multiws/main/dependencies.sh;chmod +x dependencies.sh;./dependencies.sh
rm dependencies.sh
clear

yellow "Add Domain for vmess/vless/trojan dll"
echo " "
read -rp "Input ur domain : " -e pp
echo "$pp" > /root/domain
echo "$pp" > /root/scdomain
echo "$pp" > /etc/xray/domain
echo "$pp" > /etc/xray/scdomain
echo "IP=$pp" > /var/lib/alexxa-pro/ipvps.conf

#THEME RED
cat <<EOF>> /etc/alexxa/theme/red
BG : \E[40;1;41m
TEXT : \033[0;31m
EOF
#THEME BLUE
cat <<EOF>> /etc/alexxa/theme/blue
BG : \E[40;1;44m
TEXT : \033[0;34m
EOF
#THEME GREEN
cat <<EOF>> /etc/alexxa/theme/green
BG : \E[40;1;42m
TEXT : \033[0;32m
EOF
#THEME YELLOW
cat <<EOF>> /etc/alexxa/theme/yellow
BG : \E[40;1;43m
TEXT : \033[0;33m
EOF
#THEME MAGENTA
cat <<EOF>> /etc/alexxa/theme/magenta
BG : \E[40;1;43m
TEXT : \033[0;33m
EOF
#THEME CYAN
cat <<EOF>> /etc/alexxa/theme/cyan
BG : \E[40;1;46m
TEXT : \033[0;36m
EOF
#THEME CONFIG
cat <<EOF>> /etc/alexxa/theme/color.conf
blue
EOF
    
#install ssh ovpn
echo -e "$green[INFO]$NC Install SSH & OpenVPN!"
sleep 2
clear
wget https://raw.githubusercontent.com/kenDevXD/multiws/main/ssh/ssh-vpn.sh && chmod +x ssh-vpn.sh && ./ssh-vpn.sh
#Instal Xray
echo -e "$green[INFO]$NC Install Install XRAY!"
sleep 2
clear
wget https://raw.githubusercontent.com/kenDevXD/multiws/main/xray/ins-xray.sh && chmod +x ins-xray.sh && ./ins-xray.sh
clear



sleep 1
echo -e "[ ${green}INFO$NC ] Installing bbr.."
wget -q -O /usr/bin/bbr "https://raw.githubusercontent.com/kenDevXD/multiws/main/ssh/bbr.sh"
chmod +x /usr/bin/bbr
bbr >/dev/null 2>&1
rm /usr/bin/bbr >/dev/null 2>&1
echo -e "$yell[SERVICE]$NC Restart All service"
systemctl daemon-reload
sleep 1


sleep 1
wget -q -O /usr/bin/auto-set "https://raw.githubusercontent.com/kenDevXD/multiws/main/xray/auto-set.sh" && chmod +x /usr/bin/auto-set 
wget -q -O /usr/bin/crtxray "https://raw.githubusercontent.com/kenDevXD/multiws/main/xray/crt.sh" && chmod +x /usr/bin/crtxray 
sleep 1


wget https://raw.githubusercontent.com/SSHSEDANG4/multiws/main/backup/set-br.sh && chmod +x set-br.sh && ./set-br.sh
clear

wget https://raw.githubusercontent.com/kenDevXD/multiws/main/websocket/insshws.sh && chmod +x insshws.sh && ./insshws.sh
clear
echo -e "$green[INFO]$NC Download Extra Menu"
sleep 2
wget https://raw.githubusercontent.com/kenDevXD/multiws/main/update/update.sh && chmod +x update.sh && ./update.sh
clear
cat> /root/.profile << END
# ~/.profile: executed by Bourne-compatible login shells.

if [ "$BASH" ]; then
  if [ -f ~/.bashrc ]; then
    . ~/.bashrc
  fi
fi

mesg n || true
clear
menu
END
chmod 644 /root/.profile

if [ -f "/root/log-install.txt" ]; then
rm /root/log-install.txt > /dev/null 2>&1
fi
if [ -f "/etc/afak.conf" ]; then
rm /etc/afak.conf > /dev/null 2>&1
fi
if [ ! -f "/etc/log-create-user.log" ]; then
echo "Log All Account " > /etc/log-create-user.log
fi
history -c
curl -sS ifconfig.me > /etc/myipvps

echo " "
echo "====================-[ KennXV Premium ]-===================="
echo ""
echo "------------------------------------------------------------"
echo ""  | tee -a log-install.txt
echo "   >>> Service & Port"  | tee -a log-install.txt
echo "   - OpenSSH                 : 22"  | tee -a log-install.txt
echo "   - SSH Websocket           : 80 [ON]" | tee -a log-install.txt
echo "   - SSH SSL Websocket       : 443" | tee -a log-install.txt
echo "   - Stunnel4                : 447, 777" | tee -a log-install.txt
echo "   - Dropbear                : 109, 143" | tee -a log-install.txt
echo "   - Badvpn                  : 7100-7900" | tee -a log-install.txt
echo "   - Nginx                   : 81" | tee -a log-install.txt
echo "   - XRAY  Vmess TLS         : 443" | tee -a log-install.txt
echo "   - XRAY  Vmess None TLS    : 80" | tee -a log-install.txt
echo "   - XRAY  Vless TLS         : 443" | tee -a log-install.txt
echo "   - XRAY  Vless None TLS    : 80" | tee -a log-install.txt
echo "   - Trojan GRPC             : 443" | tee -a log-install.txt
echo "   - Trojan WS               : 443" | tee -a log-install.txt
echo "   - Sodosok WS/GRPC         : 443" | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "   >>> Server Information & Other Features"  | tee -a log-install.txt
echo "   - Timezone                : Asia/Jakarta (GMT +7)"  | tee -a log-install.txt
echo "   - Fail2Ban                : [ON]"  | tee -a log-install.txt
echo "   - Dflate                  : [ON]"  | tee -a log-install.txt
echo "   - IPtables                : [ON]"  | tee -a log-install.txt
echo "   - Auto-Reboot             : [ON]"  | tee -a log-install.txt
echo "   - IPv6                    : [OFF]"  | tee -a log-install.txt
echo "   - Autoreboot On           : $aureb:00 $gg GMT +7" | tee -a log-install.txt
echo "   - Autobackup Data" | tee -a log-install.txt
echo "   - AutoKill Multi Login User" | tee -a log-install.txt
echo "   - Auto Delete Expired Account" | tee -a log-install.txt
echo "   - Fully automatic script" | tee -a log-install.txt
echo "   - VPS settings" | tee -a log-install.txt
echo "   - Admin Control" | tee -a log-install.txt
echo "   - Backup & Restore Data" | tee -a log-install.txt
echo "   - Full Orders For Various Services" | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "   >>> About " | tee -a log-install.txt
echo "   - Script Presented By      : KennXV x Alexxa" | tee -a log-install.txt" | tee -a log-install.txt
echo "   - Contact (Only Text)      : t.me/aixxy7" | tee -a log-install.txt" | tee -a log-install.txt
echo "------------------------------------------------------------"
echo ""
echo "=============-[ KennXV x Alexxa ]-==============="
echo -e ""
echo ""
echo "" | tee -a log-install.txt
rm /root/cf.sh >/dev/null 2>&1
rm /root/setup.sh >/dev/null 2>&1
rm /root/insshws.sh 
rm /root/update.sh
rm /root/set-br.sh
secs_to_human "$(($(date +%s) - ${start}))" | tee -a log-install.txt
echo -e "
"
echo -ne "[ ${yell}WARNING${NC} ] Do you want to reboot now ? (y/n)? "
read answer
if [ "$answer" == "${answer#[Yy]}" ] ;then
exit 0
else
reboot
fi