#!/data/data/com.termux/files/usr/bin/bash

GOLD='\033[1;33m'
CYAN='\033[0;36m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

clear
echo -e "${GOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

LATEST_RELEASE=$(curl -s https://api.github.com/repos/johnosasuna/download/releases/latest | jq -r '.tag_name')

echo -e "${CYAN}    ____                                            ${NC}"
echo -e "${CYAN}   / ___| _   _ _ __  _ __ ___ _ __ ___   ___      ${NC}"
echo -e "${CYAN}   \___ \| | | | '_ \| '__/ _ \ '_ ' _ \ / _ \     ${NC}"
echo -e "${CYAN}    ___) | |_| | |_) | | |  __/ | | | | |  __/     ${NC}"
echo -e "${CYAN}   |____/ \__,_| .__/|_|  \___|_| |_| |_|\___|     ${NC}"
echo -e "${CYAN}               |_|  ${GOLD}S C A N N E R  ${LATEST_RELEASE}${NC}"
echo -e "${GOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${RED}  👤 Developer : @RookieHax${NC}"
echo -e "${RED}  📢 Telegram  : t.me/supremebughost${NC}"
echo -e "${GOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "\n"

get_latest_release_info() {
    curl -s https://api.github.com/repos/johnosasuna/download/releases/latest
}

cd $HOME || exit 1

echo -e "${CYAN}[➤] Configuring secure path...${NC}"

echo -ne "${CYAN}[➤] Optimizing system & repairing libraries...${NC}"
echo "deb https://packages.termux.dev/apt/termux-main stable main" > $PREFIX/etc/apt/sources.list
export DEBIAN_FRONTEND=noninteractive
pkg install libandroid-posix-semaphore wget unzip -y > /dev/null 2>&1
echo -e " [${GREEN}DONE${NC}]"

rm -f supreme_scanner core.zip supreme_scanner_64.bin supreme_scanner_32.bin > /dev/null 2>&1

ARCH=$(uname -m)
if [[ "$ARCH" == "aarch64" ]]; then
    BINARY_NAME="supreme_scanner_64.bin"
    echo -e "${CYAN}[➤] System: 64-bit Core Detected${NC}"
else
    BINARY_NAME="supreme_scanner_32.bin"
    echo -e "${CYAN}[➤] System: 32-bit Legacy Core Detected${NC}"
fi

if ! command -v jq &> /dev/null
then
    pkg install jq -y > /dev/null 2>&1
fi

RELEASE_INFO=$(get_latest_release_info)
RELEASE_TAG=$(echo "$RELEASE_INFO" | jq -r '.tag_name')
DOWNLOAD_URL=$(echo "$RELEASE_INFO" | jq -r '.assets[] | select(.name | test("supreme_latest_universal.zip")) | .browser_download_url')

echo -e "${CYAN}[➤] Downloading the latest release from: $DOWNLOAD_URL${NC}"

wget -q "$DOWNLOAD_URL" -O supreme_latest_universal.zip

echo -e "${CYAN}[➤] Please allow storage permission if prompted...${NC}"
termux-setup-storage > /dev/null 2>&1
sleep 1

if [ -f supreme_latest_universal.zip ]; then
    unzip -q -o supreme_latest_universal.zip
    if [ -f "$BINARY_NAME" ]; then
        mv "$BINARY_NAME" supreme_scanner
        chmod +x supreme_scanner
        rm supreme_latest_universal.zip supreme_scanner_64.bin supreme_scanner_32.bin > /dev/null 2>&1
        echo -e " [${GREEN}DONE${NC}]"
    else
        echo -e " [${RED}ERROR: Architecture binary not found in ZIP${NC}]"
        exit 1
    fi
else
    echo -e " [${RED}FAILED${NC}]"
    echo -e "${RED}Error: Download failed or zip file not found.${NC}"
    exit 1
fi

echo -e "\n${GREEN}🚀 Setup complete. Initializing security check...${NC}\n"
sleep 1

if [ ! -f "supreme_scanner" ]; then
    echo -e "${RED}Error: supreme_scanner binary not found.${NC}"
    exit 1
fi

./supreme_scanner
