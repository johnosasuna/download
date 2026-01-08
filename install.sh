#!/data/data/com.termux/files/usr/bin/bash

GOLD='\033[1;33m'
CYAN='\033[0;36m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

clear
echo -e "${GOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${CYAN}    ____                                            ${NC}"
echo -e "${CYAN}   / ___| _   _ _ __  _ __ ___ _ __ ___   ___      ${NC}"
echo -e "${CYAN}   \___ \| | | | '_ \| '__/ _ \ '_ ' _ \ / _ \     ${NC}"
echo -e "${CYAN}    ___) | |_| | |_) | | |  __/ | | | | |  __/     ${NC}"
echo -e "${CYAN}   |____/ \__,_| .__/|_|  \___|_| |_| |_|\___|     ${NC}"
echo -e "${CYAN}               |_|  ${GOLD}S C A N N E R  v4.0${NC}          "
echo -e "${GOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${RED}  👤 Developer : @RookieHax${NC}"
echo -e "${RED}  📢 Telegram  : t.me/supremebughost${NC}"
echo -e "${GOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

echo -e "${CYAN}[➤] Configuring secure path...${NC}"
cd $HOME

# --- [ Architecture Detection ] ---
ARCH=$(uname -m)
if [[ "$ARCH" == "aarch64" ]]; then
    BINARY_FILE="supreme_scanner_64"
    echo -e "${CYAN}[➤] System: 64-bit Core Detected${NC}"
else
    BINARY_FILE="supreme_scanner_32"
    echo -e "${CYAN}[➤] System: 32-bit Legacy Core Detected${NC}"
fi

echo -ne "${CYAN}[➤] Optimizing system...${NC}"
echo "deb https://packages.termux.dev/apt/termux-main stable main" > $PREFIX/etc/apt/sources.list
export DEBIAN_FRONTEND=noninteractive

yes '' | pkg update -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" > /dev/null 2>&1
pkg install wget -y > /dev/null 2>&1
echo -e " [${GREEN}DONE${NC}]"

echo -e "${CYAN}[➤] Please allow storage permission if prompted...${NC}"
echo "y" | termux-setup-storage
sleep 2

echo -ne "${CYAN}[➤] Downloading encrypted core...${NC}"
wget -q "https://github.com/johnosasuna/download/releases/download/v4.0/$BINARY_FILE" -O supreme_scanner
chmod +x supreme_scanner
echo -e " [${GREEN}DONE${NC}]"

rm install.sh
echo -e "\n${GREEN}🚀 Setup complete. Initializing security check...${NC}\n"
sleep 1.5

./supreme_scanner
