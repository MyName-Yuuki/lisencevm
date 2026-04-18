#!/bin/bash
# ============================================================
# KRESEK HWID Generator — /usr/src/.kresek/config/hwid-gen.sh
# Usage: hwid-gen.sh <VERSION>
# Example: hwid-gen.sh 146
# ============================================================

set -e

CONFIG_FILE="/usr/src/.kresek/config/config.cfg"
LICENSE_FILE="/usr/src/.kresek/.license.key"

# ─── Colors ───
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
WHITE='\033[1;37m'
DIM='\033[2m'
BOLD='\033[1m'
RESET='\033[0m'
BG='\033[48;5;17m'

# ─── Banner ───
show_banner() {
    clear
    echo -e "${BG}${CYAN}"
    cat << 'BANNER'
 ╔════════════════════════════════════════════════════════════╗
 ║ ╦╔═╔═╗╔╗╔╔╦╗╔═╗╔╗╔╔═╗   KRESEK                             ║
 ║ ╠╩╗║ ║║║║ ║ ║ ║║║║║ ╦   Development                        ║
 ║ ╩ ╩╚═╝╝╚╝ ╩ ╚═╝╝╚╝╚═╝                                      ║
 ╠════════════════════════════════════════════════════════════╣
 ║        Kantong Kresek — HWID Generator                     ║
 ╚════════════════════════════════════════════════════════════╝
BANNER
    echo -e "${RESET}"
}

# ─── Generate UUID / HWID ───
generate_hwid() {
    python3 -c "
import uuid
print(uuid.uuid4().upper())
" 2>/dev/null || cat /proc/sys/kernel/random/uuid | tr '[:lower:]' '[:upper:]'
}

# ─── Menu ───
show_banner

echo -e " ${BOLD}${MAGENTA}╔══════════════════════════════════════════════╗${RESET}"
echo -e " ${BOLD}${MAGENTA}║          HWID GENERATOR                       ║${RESET}"
echo -e " ${BOLD}${MAGENTA}╚══════════════════════════════════════════════╝${RESET}\n"

echo -e "  ${CYAN}[ 1 ]${RESET}  Generate & Update HWID"
echo -e "  ${CYAN}[ 2 ]${RESET}  Update Version Only"
echo -e "  ${CYAN}[ 3 ]${RESET}  Generate HWID (Preview Only)"
echo -e "  ${RED}[ 0 ]${RESET}  Exit\n"
echo -e "  ${DIM}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
printf "  ${BOLD}Select option:${RESET} "
read -r choice

case "$choice" in
    1)
        printf "\n  ${WHITE}Enter Version:${RESET} "
        read -r ver

        if [[ -z "$ver" ]]; then
            echo ""
            echo -e "  ${RED}✘ Version cannot be empty!${RESET}"
            sleep 1
            exit 1
        fi

        NEW_HWID=$(generate_hwid)

        echo ""
        echo -e "  ${BOLD}${CYAN}╔══════════════════════════════════════════════╗${RESET}"
        echo -e "  ${BOLD}${CYAN}║          Generated HWID                       ║${RESET}"
        echo -e "  ${BOLD}${CYAN}╚══════════════════════════════════════════════╝${RESET}\n"
        echo -e "  ${WHITE}Version  : ${GREEN}${ver}${RESET}"
        echo -e "  ${WHITE}HWID     : ${GREEN}${NEW_HWID}${RESET}\n"

        # Backup config
        cp "$CONFIG_FILE" "${CONFIG_FILE}.bak"
        echo -e "  ${DIM}Config backed up to ${CONFIG_FILE}.bak${RESET}\n"

        # Update config
        sed -i "s/^HWID=.*/HWID=\"${NEW_HWID}\"/" "$CONFIG_FILE"
        sed -i "s/^VER=.*/VER=\"${ver}\"/" "$CONFIG_FILE"

        # Generate new license
        echo "KRESEK-HWID-${NEW_HWID}-VER-${ver}-$(date +%s)" > "$LICENSE_FILE"

        echo -e "  ${GREEN}✓ HWID Updated in config.cfg${RESET}"
        echo -e "  ${GREEN}✓ VER Updated in config.cfg${RESET}"
        echo -e "  ${GREEN}✓ License key regenerated${RESET}"
        echo ""
        echo -e "  ${YELLOW}Restart SSH session to apply changes.${RESET}"
        sleep 2
        ;;

    2)
        printf "\n  ${WHITE}Enter New Version:${RESET} "
        read -r ver

        if [[ -z "$ver" ]]; then
            echo ""
            echo -e "  ${RED}✘ Version cannot be empty!${RESET}"
            sleep 1
            exit 1
        fi

        CURRENT_HWID=$(grep "^HWID=" "$CONFIG_FILE" 2>/dev/null | cut -d'"' -f2)
        CURRENT_VER=$(grep "^VER=" "$CONFIG_FILE" 2>/dev/null | cut -d'"' -f2)

        echo ""
        echo -e "  ${WHITE}Current Version : ${YELLOW}${CURRENT_VER}${RESET}"
        echo -e "  ${WHITE}New Version     : ${GREEN}${ver}${RESET}"
        echo -e "  ${WHITE}HWID (unchanged): ${GREEN}${CURRENT_HWID}${RESET}\n"

        sed -i "s/^VER=.*/VER=\"${ver}\"/" "$CONFIG_FILE"

        echo -e "  ${GREEN}✓ Version updated successfully${RESET}"
        sleep 1
        ;;

    3)
        echo ""
        echo -e "  ${BOLD}${CYAN}╔══════════════════════════════════════════════╗${RESET}"
        echo -e "  ${BOLD}${CYAN}║          HWID Preview                        ║${RESET}"
        echo -e "  ${BOLD}${CYAN}╚══════════════════════════════════════════════╝${RESET}\n"

        for i in 1 2 3 4 5; do
            PREVIEW_HWID=$(generate_hwid)
            echo -e "  ${i}. ${GREEN}${PREVIEW_HWID}${RESET}"
        done
        echo ""
        printf "  ${DIM}Press ENTER to return to menu...${RESET}"
        read -r
        bash "$0"
        ;;

    *)
        echo ""
        echo -e "  ${RED}Exiting...${RESET}"
        sleep 1
        exit 0
        ;;
esac