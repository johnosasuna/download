#!/data/data/com.termux/files/usr/bin/bash

# --- Configuration ---
REPO_OWNER="johnosasuna"
REPO_NAME="download"
BINARY_NAME_64="supreme_scanner_64.bin"
BINARY_NAME_32="supreme_scanner_32.bin"
FALLBACK_URL="https://github.com/johnosasuna/download/releases/download/v1/supreme_latest_universal.zip"

# --- Colors ---
GOLD='\033[1;33m'
CYAN='\033[0;36m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

# 1. SILENT STORAGE & JQ CHECK
if [ ! -d "$HOME/storage" ]; then
    echo "" | termux-setup-storage > /dev/null 2>&1
fi

if ! command -v jq &> /dev/null; then
    pkg install jq -y > /dev/null 2>&1
fi

# Fetch Version Info Silently
RELEASE_INFO=$(curl -s "https://api.github.com/repos/$REPO_OWNER/$REPO_NAME/releases/latest")
LATEST_TAG=$(echo "$RELEASE_INFO" | jq -r '.tag_name // "v1.0"')
DOWNLOAD_URL=$(echo "$RELEASE_INFO" | jq -r '.assets[] | select(.name | endswith(".zip")) | .browser_download_url' | head -n 1)

[[ -z "$DOWNLOAD_URL" || "$DOWNLOAD_URL" == "null" ]] && DOWNLOAD_URL="$FALLBACK_URL"

clear
# 2. PREMIUM HEADER
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

# 3. YOUR ORIGINAL SYSTEM REPAIR (RESTORED)
echo -ne "${CYAN}[➤] Optimizing system & repairing libraries...${NC}"
echo "deb https://packages.termux.dev/apt/termux-main stable main" > $PREFIX/etc/apt/sources.list
export DEBIAN_FRONTEND=noninteractive
pkg install libandroid-posix-semaphore wget unzip -y > /dev/null 2>&1
echo -e " [${GREEN}DONE${NC}]"

# 4. ARCHITECTURE DETECTION
ARCH=$(uname -m)
if [[ "$ARCH" == "aarch64" ]]; then
    TARGET_BIN="$BINARY_NAME_64"
    echo -e "${CYAN}[➤] System: 64-bit Core Detected${NC}"
else
    TARGET_BIN="$BINARY_NAME_32"
    echo -e "${CYAN}[➤] System: 32-bit Legacy Core Detected${NC}"
fi

# 5. CLEAN DOWNLOAD & INSTALL
cd $HOME || exit 1
rm -f core.zip supreme_scanner

echo -e "${CYAN}[➤] Downloading latest components...${NC}"
# -q hides the junk, --show-progress keeps the status bar
wget -q --show-progress -L "$DOWNLOAD_URL" -O core.zip

if [[ -f core.zip && -s core.zip ]]; then
    echo -ne "${CYAN}[➤] Installing components...${NC}"
    unzip -q -o core.zip
    
    if [[ -f "$TARGET_BIN" ]]; then
        mv "$TARGET_BIN" supreme_scanner
        chmod +x supreme_scanner
        rm -f core.zip "$BINARY_NAME_64" "$BINARY_NAME_32"
        echo -e " [${GREEN}DONE${NC}]"
    else
        echo -e "\n${RED}[!] Error: Binary $TARGET_BIN not found in ZIP.${NC}"
        exit 1
    fi
else
    echo -e "\n${RED}[!] Error: Download failed.${NC}"
    exit 1
fi

echo -e "\n${GREEN}🚀 Setup complete. Initializing scanner...${NC}\n"
sleep 1

# 6. EXECUTE
if [[ -f "./supreme_scanner" ]]; then
    ./supreme_scanner
fi
