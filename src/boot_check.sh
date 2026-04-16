#!/bin/bash
# ============================================================
# Kresek Boot Check - VMware Console
# Check .license.key → Lock/Unlock SSH services
# ============================================================

source /usr/src/.kresek/config/config.cfg

IP=$(hostname -I | awk '{print $1}')

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

# DEV MODE
if [[ "$DEV_MODE" == "true" ]]; then
    echo -e "${YELLOW}[DEV MODE] Boot check bypassed${NC}"
    exit 0
fi

# ============================================================
lock_ssh() {
    # Block ROOT SSH
    sed -i 's/^PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config
    
    # Block SFTP
    if ! grep -q "^# KRESEK BLOCK SFTP" /etc/ssh/sshd_config; then
        sed -i '/Subsystem.*sftp/d' /etc/ssh/sshd_config
        echo "" >> /etc/ssh/sshd_config
        echo "# KRESEK BLOCK SFTP - SCP & SFTP BLOCKED" >> /etc/ssh/sshd_config
    fi
    
    if [[ ! -d /run/sshd ]]; then mkdir -p /run/sshd; fi
    systemctl reload sshd 2>/dev/null || systemctl reload ssh
}

unlock_ssh() {
    # Enable ROOT SSH
    sed -i 's/^PermitRootLogin.*/PermitRootLogin prohibit-password/' /etc/ssh/sshd_config
    
    # Enable SFTP
    sed -i '/# KRESEK BLOCK SFTP/d' /etc/ssh/sshd_config
    if ! grep -q "^Subsystem.*sftp" /etc/ssh/sshd_config; then
        echo "Subsystem sftp /usr/lib/openssh/sftp-server" >> /etc/ssh/sshd_config
    fi
    
    if [[ ! -d /run/sshd ]]; then mkdir -p /run/sshd; fi
    systemctl reload sshd 2>/dev/null || systemctl reload ssh
}

# ============================================================
main() {
    if [[ -f "$LICENSE_FILE" ]] && [[ -s "$LICENSE_FILE" ]]; then
        echo -e "${GREEN}[Kresek] License Valid - System Unlocked${NC}"
        unlock_ssh
        exit 0
    fi

    # No license - LOCK everything
    echo -e "${RED}[Kresek] No License - Locking System...${NC}"
    lock_ssh

    clear
    echo ""
    echo -e "${RED}╔═══════════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${RED}║              KRESEK LICENSE - AKTIVASI WAJIB                      ║${NC}"
    echo -e "${RED}╚═══════════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${YELLOW}  ⚠  FILE .license.key TIDAK DITEMUKAN${NC}"
    echo -e "${YELLOW}  ⚠  SISTEM TERKUNCI${NC}"
    echo ""
    echo -e "${RED}  ┌───────────────────────────────────────────────────────────────────┐${NC}"
    echo -e "${RED}  │                     STATUS PENGUNCIAN                              │${NC}"
    echo -e "${RED}  └───────────────────────────────────────────────────────────────────┘${NC}"
    echo ""
    echo -e "    ${RED}✗ ROOT SSH   : TERKUNCI${NC}"
    echo -e "    ${RED}✗ SCP        : TERKUNCI${NC}"
    echo -e "    ${RED}✗ SFTP       : TERKUNCI${NC}"
    echo ""
    echo -e "${CYAN}  ┌───────────────────────────────────────────────────────────────────┐${NC}"
    echo -e "${CYAN}  │                     GUNAKAN PUTTY UNTUK AKTIVASI                   │${NC}"
    echo -e "${CYAN}  └───────────────────────────────────────────────────────────────────┘${NC}"
    echo ""
    echo -e "${CYAN}  ┌───────────────────────────────────────────────────────────────────┐${NC}"
    echo -e "${CYAN}  │                     INFORMASI AKSES PUTTY                        │${NC}"
    echo -e "${CYAN}  └───────────────────────────────────────────────────────────────────┘${NC}"
    echo ""
    echo -e "    ${GREEN}► IP Address : ${NC}${YELLOW}${IP}${NC}"
    echo -e "    ${GREEN}► User       : ${NC}${YELLOW}kantong${NC}"
    echo -e "    ${GREEN}► Password   : ${NC}${YELLOW}kresek${NC}"
    echo -e "    ${GREEN}► Port       : ${NC}${YELLOW}22${NC}"
    echo -e "    ${GREEN}► Protocol   : ${NC}${YELLOW}SSH${NC}"
    echo ""
    echo -e "${RED}  ┌───────────────────────────────────────────────────────────────────┐${NC}"
    echo -e "${RED}  │                   LANGKAH AKTIVASI (PUTTY)                       │${NC}"
    echo -e "${RED}  └───────────────────────────────────────────────────────────────────┘${NC}"
    echo ""
    echo -e "    ${YELLOW}1.${NC}  Buka ${CYAN}PuTTY${NC} → Host: ${GREEN}${IP}${NC} | Port: ${GREEN}22${NC} | SSH"
    echo -e "    ${YELLOW}2.${NC}  Klik ${GREEN}Open${NC} → Login: ${GREEN}kantong${NC} / ${GREEN}kresek${NC}"
    echo -e "    ${YELLOW}3.${NC}  Form aktivasi langsung muncul setelah login"
    echo ""
    echo -e "    ${YELLOW}4.${NC}  Masukkan ${CYAN}API Key${NC} (Step 1)"
    echo -e "    ${YELLOW}5.${NC}  Masukkan ${CYAN}Activation Code${NC} (Step 2)"
    echo ""
    echo -e "${RED}  ┌───────────────────────────────────────────────────────────────────┐${NC}"
    echo -e "${RED}  │                 DAPATKAN API KEY & ACTIVATION CODE                 │${NC}"
    echo -e "${RED}  └───────────────────────────────────────────────────────────────────┘${NC}"
    echo ""
    echo -e "    ${YELLOW}•${NC} Browser: ${CYAN}https://activation.kresek.my.id:2104/lisence${NC}"
    echo -e "    ${YELLOW}•${NC} Login → dapat ${CYAN}API Key${NC}"
    echo -e "    ${YELLOW}•${NC} Redeem voucher → dapat ${CYAN}Activation Code${NC}"
    echo ""
    echo ""
    echo -ne "  Tekan ${GREEN}[Enter]${NC} untuk boot sistem..."
    read
}

main
