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

clear

# 1. SILENT STORAGE: Skip the warning if storage is already linked
if [ ! -d "$HOME/storage" ]; then
    echo -e "${CYAN}[➤] Configuring storage...${NC}"
    echo "" | termux-setup-storage > /dev/null 2>&1
    sleep 1
fi

# Ensure JQ is installed for the API logic
if ! command -v jq &> /dev/null; then
    pkg install jq -y > /dev/null 2>&1
fi

# 2. STRICT URL FETCH: Only grab the .zip link, ignore .sha256
RELEASE_INFO=$(curl -s "https://api.github.com/repos/$REPO_OWNER/$REPO_NAME/releases/latest")
LATEST_TAG=$(echo "$RELEASE_INFO" | jq -r '.tag_name // "v1.0"')
DOWNLOAD_URL=$(echo "$RELEASE_INFO" | jq -r '.assets[] | select(.name | endswith(".zip")) | .browser_download_url' | head -n 1)

# Safety Fallback
if [[ -z "$DOWNLOAD_URL" || "$DOWNLOAD_URL" == "null" ]]; then
    DOWNLOAD_URL="$FALLBACK_URL"
fi

# 3. HEADER
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

# 4. SYSTEM DETECTION
ARCH=$(uname -m)
if [[ "$ARCH" == "aarch64" ]]; then
    TARGET_BIN="$BINARY_NAME_64"
    echo -e "${CYAN}[➤] System: 64-bit Core Detected${NC}"
else
    TARGET_BIN="$BINARY_NAME_32"
    echo -e "${CYAN}[➤] System: 32-bit Legacy Core Detected${NC}"
fi

# 5. CLEAN & DOWNLOAD
cd $HOME || exit 1
rm -f core.zip supreme_scanner # Wipe failed attempts

echo -e "${CYAN}[➤] Downloading latest components...${NC}"
# -L is critical for GitHub redirects
wget -L --show-progress "$DOWNLOAD_URL" -O core.zip

# 6. EXTRACTION & FINAL SETUP
if [[ -f core.zip && -s core.zip ]]; then
    echo -ne "${CYAN}[➤] Installing...${NC}"
    unzip -q -o core.zip
    
    if [[ -f "$TARGET_BIN" ]]; then
        mv "$TARGET_BIN" supreme_scanner
        chmod +x supreme_scanner
        rm -f core.zip "$BINARY_NAME_64" "$BINARY_NAME_32"
        echo -e " [${GREEN}DONE${NC}]"
    else
        echo -e "\n${RED}[!] Error: Architecture binary not found in ZIP.${NC}"
        exit 1
    fi
else
    echo -e "\n${RED}[!] Error: Download failed or link is broken (404).${NC}"
    exit 1
fi

echo -e "\n${GREEN}🚀 Setup complete. Launching...${NC}\n"
sleep 1

if [[ -f "./supreme_scanner" ]]; then
    ./supreme_scanner
fi
