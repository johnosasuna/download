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
rm -f supreme_scanner core.zip supreme_scanner_64.bin supreme_scanner_32.bin > /dev/null 2>&1

ARCH=$(uname -m)
if [[ "$ARCH" == "aarch64" ]]; then
    BINARY_NAME="supreme_scanner_64.bin"
    echo -e "${CYAN}[➤] System: 64-bit Core Detected${NC}"
else
    BINARY_NAME="supreme_scanner_32.bin"
    echo -e "${CYAN}[➤] System: 32-bit Legacy Core Detected${NC}"
fi

echo -ne "${CYAN}[➤] Optimizing system & repairing libraries...${NC}"
echo "deb https://packages.termux.dev/apt/termux-main stable main" > $PREFIX/etc/apt/sources.list
export DEBIAN_FRONTEND=noninteractive
pkg install libandroid-posix-semaphore wget unzip -y > /dev/null 2>&1
echo -e " [${GREEN}DONE${NC}]"

echo -e "${CYAN}[➤] Please allow storage permission if prompted...${NC}"
echo "y" | termux-setup-storage > /dev/null 2>&1
sleep 1

echo -ne "${CYAN}[➤] Downloading encrypted core...${NC}"
wget -q "https://github.com/johnosasuna/download/releases/download/v4.0/supreme_v4_universal.zip" -O core.zip

if [ -f core.zip ]; then
    unzip -q -o core.zip
    if [ -f "$BINARY_NAME" ]; then
        mv "$BINARY_NAME" supreme_scanner
        chmod +x supreme_scanner
        rm core.zip supreme_scanner_64.bin supreme_scanner_32.bin > /dev/null 2>&1
        echo -e " [${GREEN}DONE${NC}]"
    else
        echo -e " [${RED}ERROR: Architecture binary not found in ZIP${NC}]"
        exit 1
    fi
else
    echo -e " [${RED}FAILED${NC}]"
    echo -e "${RED}Error: Link expired or network timeout.${NC}"
    exit 1
fi

rm install.sh > /dev/null 2>&1

echo -e "\n${GREEN}🚀 Setup complete. Initializing security check...${NC}\n"
sleep 1

./supreme_scanner
