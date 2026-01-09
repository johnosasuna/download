#!/data/data/com.termux/files/usr/bin/bash

REPO_OWNER="johnosasuna"
REPO_NAME="download"
BINARY_NAME_64="supreme_scanner_64.bin"
BINARY_NAME_32="supreme_scanner_32.bin"
FALLBACK_URL="https://github.com/johnosasuna/download/releases/download/v1/supreme_latest_universal.zip"

GOLD='\033[1;33m'
CYAN='\033[0;36m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

clear

if [ ! -d "$HOME/storage" ]; then
    echo -e "${CYAN}[➤] Configuring storage...${NC}"
    echo "" | termux-setup-storage > /dev/null 2>&1
    sleep 1
fi

if ! command -v jq &> /dev/null; then
    pkg install jq -y > /dev/null 2>&1
fi

RELEASE_INFO=$(curl -s "https://api.github.com/repos/$REPO_OWNER/$REPO_NAME/releases/latest")
LATEST_TAG=$(echo "$RELEASE_INFO" | jq -r '.tag_name // "v1.0"')
DOWNLOAD_URL=$(echo "$RELEASE_INFO" | jq -r '.assets[] | select(.name | test("universal.zip")) | .browser_download_url' | head -n 1)

if [[ -z "$DOWNLOAD_URL" || "$DOWNLOAD_URL" == "null" ]]; then
    DOWNLOAD_URL="$FALLBACK_URL"
fi

echo -e "${GOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${CYAN}    ____                                            ${NC}"
echo -e "${CYAN}   / ___| _   _ _ __  _ __ ___ _ __ ___   ___      ${NC}"
echo -e "${CYAN}   \___ \| | | | '_ \| '__/ _ \ '_ ' _ \ / _ \     ${NC}"
echo -e "${CYAN}    ___) | |_| | |_) | | |  __/ | | | | |  __/     ${NC}"
echo -e "${CYAN}   |____/ \__,_| .__/|_|  \___|_| |_| |_|\___|     ${NC}"
echo -e "${CYAN}               |_|  ${GOLD}S C A N N E R  ${LATEST_TAG}${NC}"
echo -e "${GOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${RED}  👤 Developer : @RookieHax${NC}"
echo -e "${RED}  📢 Telegram  : t.me/supremebughost${NC}"
echo -e "${GOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

ARCH=$(uname -m)
if [[ "$ARCH" == "aarch64" ]]; then
    TARGET_BIN="$BINARY_NAME_64"
    echo -e "${CYAN}[➤] System: 64-bit Core Detected${NC}"
else
    TARGET_BIN="$BINARY_NAME_32"
    echo -e "${CYAN}[➤] System: 32-bit Legacy Core Detected${NC}"
fi

cd $HOME || exit 1
echo -e "${CYAN}[➤] Downloading latest components...${NC}"

rm -f core.zip supreme_scanner

wget -L --show-progress "$DOWNLOAD_URL" -O core.zip

if [[ -f core.zip && -s core.zip ]]; then
    echo -ne "${CYAN}[➤] Installing...${NC}"
    unzip -q -o core.zip
    
    if [[ -f "$TARGET_BIN" ]]; then
        mv "$TARGET_BIN" supreme_scanner
        chmod +x supreme_scanner
        rm -f core.zip "$BINARY_NAME_64" "$BINARY_NAME_32"
        echo -e " [${GREEN}DONE${NC}]"
    else
        echo -e "\n${RED}[!] Error: Binary $TARGET_BIN not found in ZIP.${NC}"
        echo -e "${CYAN}Files found in ZIP:${NC}"
        unzip -l core.zip
        exit 1
    fi
else
    echo -e "${RED}[!] Error: Downloaded file is empty or missing.${NC}"
    exit 1
fi

echo -e "\n${GREEN}🚀 Setup complete. Initializing...${NC}\n"
sleep 1

if [[ -f "./supreme_scanner" ]]; then
    ./supreme_scanner
fi
