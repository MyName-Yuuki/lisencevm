#!/bin/bash
# ============================================================
# Kresek Boot License Check
# Runs on boot - check .license.key
# If valid → enable root SSH + unlock all
# If missing → block root SSH + lock all
# ============================================================

set -e

source /usr/src/.kresek/config/config.cfg

IP=$(hostname -I | awk '{print $1}')

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

# DEV MODE BYPASS
if [[ "$DEV_MODE" == "true" ]]; then
    echo -e "${YELLOW}[DEV MODE] License check bypassed${NC}"
    exit 0
fi

# ============================================================
enable_root_ssh() {
    sed -i 's/#PermitRootLogin.*/PermitRootLogin prohibit-password/' /etc/ssh/sshd_config
    sed -i 's/PermitRootLogin no/PermitRootLogin prohibit-password/' /etc/ssh/sshd_config
    systemctl reload sshd 2>/dev/null || systemctl reload ssh
}

disable_root_ssh() {
    sed -i 's/#PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config
    sed -i 's/PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config
    sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin no/' /etc/ssh/sshd_config
    systemctl reload sshd 2>/dev/null || systemctl reload ssh
}

block_scp_sftp() {
    if [[ ! -f /etc/ssh/sshd_config.bak ]]; then
        cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak
    fi
    sed -i '/KRESEK LICENSE BLOCK/,/^$/d' /etc/ssh/sshd_config
    sed -i '/Subsystem.*sftp/d' /etc/ssh/sshd_config
    cat >> /etc/ssh/sshd_config << 'SSHEOF'

# KRESEK LICENSE BLOCK - SCP & SFTP BLOCKED
SSHEOF
    systemctl reload sshd 2>/dev/null || systemctl reload ssh
}

unblock_scp_sftp() {
    if [[ -f /etc/ssh/sshd_config.bak ]]; then
        cp /etc/ssh/sshd_config.bak /etc/ssh/sshd_config
        sed -i '/KRESEK LICENSE BLOCK/,/^$/d' /etc/ssh/sshd_config
        systemctl reload sshd 2>/dev/null || systemctl reload ssh
    fi
}

show_console() {
    echo ""
    echo -e "${RED}╔═══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${RED}║            KRESEK LICENSE - AKTIVASI WAJIB             ║${NC}"
    echo -e "${RED}╚═══════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${YELLOW}  ⚠  FILE .license.key TIDAK DITEMUKAN!${NC}"
    echo -e "${RED}  ⚠  ROOT SSH & SCP/SFTP DIBLOKIR${NC}"
    echo ""
    echo -e "${CYAN}  ┌───────────────────────────────────────────────────────────┐${NC}"
    echo -e "${CYAN}  │              INFORMASI AKSES VM                            │${NC}"
    echo -e "${CYAN}  └───────────────────────────────────────────────────────────┘${NC}"
    echo ""
    echo -e "    ${GREEN}► IP Address : ${NC}${YELLOW}${IP}${NC}"
    echo -e "    ${GREEN}► User       : ${NC}${YELLOW}kantong${NC}"
    echo -e "    ${GREEN}► Password   : ${NC}${YELLOW}kresek${NC}"
    echo ""
    echo -e "${RED}  ┌───────────────────────────────────────────────────────────┐${NC}"
    echo -e "${RED}  │                 CARA AKTIVASI (PUTTY)                     │${NC}"
    echo -e "${RED}  └───────────────────────────────────────────────────────────┘${NC}"
    echo ""
    echo -e "    ${YELLOW}1.${NC} Buka ${CYAN}PuTTY${NC} → Host: ${GREEN}${IP}${NC} Port: ${GREEN}22${NC} SSH"
    echo -e "    ${YELLOW}2.${NC} Login: ${GREEN}kantong${NC} / ${GREEN}kresek${NC}"
    echo -e "    ${YELLOW}3.${NC} Jalankan: ${CYAN}sudo /usr/src/.kresek/src/activation.sh${NC}"
    echo ""
    echo -e "  ⚠  ROOT SSH & SCP/SFTP TIDAK BISA SEBELUM AKTIVASI!${NC}"
    echo ""
    echo -ne "  Tekan ${GREEN}[Enter]${NC}..."
    read
}

# ============================================================
main() {
    echo -e "${CYAN}[Kresek] License Check...${NC}"

    if [[ -f "$LICENSE_FILE" ]] && [[ -s "$LICENSE_FILE" ]]; then
        echo -e "${GREEN}[Kresek] ✓ .license.key ADA - Aktifasi valid${NC}"
        echo -e "${GREEN}  ✓ Enable ROOT SSH via PPK${NC}"
        echo -e "${GREEN}  ✓ Unlock SCP & SFTP${NC}"
        enable_root_ssh
        unblock_scp_sftp
        exit 0
    else
        echo -e "${RED}[Kresek] ✗ .license.key TIDAK ADA${NC}"
        echo -e "${RED}  ✗ Disable ROOT SSH${NC}"
        echo -e "${RED}  ✗ Block SCP & SFTP${NC}"
        disable_root_ssh
        block_scp_sftp
        show_console
        exit 1
    fi
}

main
