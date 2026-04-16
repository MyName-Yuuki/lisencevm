#!/bin/bash
# ============================================================
# Kresek Boot Check - VMware Console (Non-PuTTY)
# ============================================================

source /usr/src/.kresek/config/config.cfg

IP=$(hostname -I | awk '{print $1}')

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

# DEV MODE
if [[ "$DEV_MODE" == "true" ]]; then
    echo -e "${YELLOW}[DEV MODE] Boot check bypassed${NC}"
    exit 0
fi

# ============================================================
draw_header() {
    echo -e "${CYAN}${BOLD}"
    echo -e "¦¦+  ¦¦+ ¦¦¦¦¦+ ¦¦¦+   ¦¦+¦¦¦¦¦¦¦¦+ ¦¦¦¦¦¦+ ¦¦¦+   ¦¦+ ¦¦¦¦¦¦+ "
    echo -e "¦¦¦ ¦¦++¦¦+--¦¦+¦¦¦¦+  ¦¦¦+--¦¦+--+¦¦+---¦¦+¦¦¦¦+  ¦¦¦¦¦+----+ "
    echo -e "¦¦¦¦¦++ ¦¦¦¦¦¦¦¦¦¦+¦¦+ ¦¦¦   ¦¦¦   ¦¦¦   ¦¦¦¦¦+¦¦+ ¦¦¦¦¦  ¦¦¦+"
    echo -e "¦¦+-¦¦+ ¦¦+--¦¦¦¦¦¦+¦¦+¦¦¦   ¦¦¦   ¦¦¦   ¦¦¦¦¦¦+¦¦+¦¦¦¦¦¦   ¦¦¦"
    echo -e "¦¦¦  ¦¦+¦¦¦  ¦¦¦¦¦¦ +¦¦¦¦¦   ¦¦¦   +¦¦¦¦¦¦++¦¦¦ +¦¦¦¦¦+¦¦¦¦¦++"
    echo -e "+-+  +-++-+  +-++-+  +---+   +-+    +-----+ +-+  +---+ +-----+ "
    echo -e ""
    echo -e "¦¦+  ¦¦+¦¦¦¦¦¦+ ¦¦¦¦¦¦+¦¦¦¦¦¦+¦¦¦¦¦¦+¦¦+  ¦¦+"
    echo -e "¦¦¦ ¦¦++¦¦+--¦¦+¦¦+----+¦¦+----+¦¦+----+¦¦¦ ¦¦++"
    echo -e "¦¦¦¦¦++ ¦¦¦¦¦¦++¦¦¦¦¦+  ¦¦¦¦¦+  ¦¦+    ¦¦¦¦¦++ "
    echo -e "¦¦+-¦¦+ ¦¦+--¦¦+¦¦+--+  +----+   ¦¦+    ¦¦+-¦¦+ "
    echo -e "¦¦¦  ¦¦+¦¦¦  ¦¦+¦¦¦¦+    ¦¦+      ¦¦+    ¦¦+ ¦¦+"
    echo -e "+-+  +-++-+  +-++------+-+        +-+     +-+  +-+"
    echo -e ""
    echo -e "          ${NC}VM Activation System — First Boot Setup${CYAN}"
    echo -e "${NC}"
}

# ============================================================
lock_ssh() {
    sed -i 's/^PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config
    sed -i '/Subsystem.*sftp/d' /etc/ssh/sshd_config
    if ! grep -q "^# KRESEK" /etc/ssh/sshd_config; then
        echo "" >> /etc/ssh/sshd_config
        echo "# KRESEK BLOCK SFTP" >> /etc/ssh/sshd_config
    fi
    if [[ ! -d /run/sshd ]]; then mkdir -p /run/sshd; fi
    systemctl reload sshd 2>/dev/null || systemctl reload ssh
}

unlock_ssh() {
    sed -i 's/^PermitRootLogin.*/PermitRootLogin prohibit-password/' /etc/ssh/sshd_config
    sed -i '/# KRESEK BLOCK SFTP/d' /etc/ssh/sshd_config
    if ! grep -q "^Subsystem.*sftp" /etc/ssh/sshd_config; then
        echo "Subsystem sftp /usr/lib/openssh/sftp-server" >> /etc/ssh/sshd_config
    fi
    if [[ ! -d /run/sshd ]]; then mkdir -p /run/sshd; fi
    systemctl reload sshd 2>/dev/null || systemctl reload ssh
}

# ============================================================
check_license() {
    [[ -f "$LICENSE_FILE" ]] && [[ -s "$LICENSE_FILE" ]]
}

# ============================================================
main() {
    clear
    echo ""
    draw_header

    # ─── STATUS CHECK ───
    echo -e "${CYAN}┌───────────────────────────────────────────────────────────────────┐${NC}"
    echo -e "${CYAN}│                       STATUS CHECK                                  │${NC}"
    echo -e "${CYAN}└───────────────────────────────────────────────────────────────────┘${NC}"
    echo ""

    if check_license; then
        echo -e "    ${GREEN}✓ License      : AKTIF${NC}"
        unlock_ssh
    else
        echo -e "    ${RED}✗ License      : BELUM AKTIF${NC}"
        lock_ssh
    fi

    echo -e "    ${CYAN}✓ Version     : ${NC}${YELLOW}${VER}${NC}"
    echo -e "    ${CYAN}✓ HWID        : ${NC}${YELLOW}08D94D56-4D17-0252-5F64-E88CBE8A6CE5${NC}"
    echo -e "    ${CYAN}✓ IP Address  : ${NC}${YELLOW}${IP}${NC}"
    echo ""

    if check_license; then
        echo -e "${GREEN}  ┌───────────────────────────────────────────────────────────────────┐${NC}"
        echo -e "${GREEN}  │                    LICENSE AKTIF                                  │${NC}"
        echo -e "${GREEN}  │               SYSTEM SIAP DIGUNAKAN                                  │${NC}"
        echo -e "${GREEN}  └───────────────────────────────────────────────────────────────────┘${NC}"
        echo ""
        echo -ne "  Tekan ${GREEN}[Enter]${NC} untuk melanjutkan..."
        read
        exit 0
    fi

    # ─── ACTIVATION GUIDE ───
    echo -e "${RED}  ┌───────────────────────────────────────────────────────────────────┐${NC}"
    echo -e "${RED}  │               AKTIVASI WAJIB - GUNAKAN PUTTY                   │${NC}"
    echo -e "${RED}  └───────────────────────────────────────────────────────────────────┘${NC}"
    echo ""

    echo -e "${RED}  ┌───────────────────────────────────────────────────────────────────┐${NC}"
    echo -e "${RED}  │                   AKSES PUTTY                                       │${NC}"
    echo -e "${RED}  └───────────────────────────────────────────────────────────────────┘${NC}"
    echo ""

    echo -e "    ${CYAN}  ► IP Address  : ${GREEN}${IP}${NC}"
    echo -e "    ${CYAN}  ► User        : ${GREEN}kantong${NC}"
    echo -e "    ${CYAN}  ► Password    : ${GREEN}kresek${NC}"
    echo -e "    ${CYAN}  ► Port        : ${GREEN}22${NC}"
    echo -e "    ${CYAN}  ► Protocol    : ${GREEN}SSH${NC}"
    echo ""

    echo -e "${RED}  ┌───────────────────────────────────────────────────────────────────┐${NC}"
    echo -e "${RED}  │                   LANGKAH AKTIVASI                                │${NC}"
    echo -e "${RED}  └───────────────────────────────────────────────────────────────────┘${NC}"
    echo ""

    echo -e "    ${YELLOW}  1.${NC}  Buka aplikasi ${CYAN}PuTTY${NC}"
    echo -e "    ${YELLOW}  2.${NC}  Masukkan Host: ${GREEN}${IP}${NC}  |  Port: ${GREEN}22${NC}  |  SSH"
    echo -e "    ${YELLOW}  3.${NC}  Klik ${GREEN}Open${NC} → Login: ${GREEN}kantong${NC} / ${GREEN}kresek${NC}"
    echo -e "    ${YELLOW}  4.${NC}  Form aktivasi otomatis muncul"
    echo -e "    ${YELLOW}  5.${NC}  Input ${CYAN}API Key${NC} → Step 1"
    echo -e "    ${YELLOW}  6.${NC}  Input ${CYAN}Activation Code${NC} → Step 2"
    echo ""

    echo -e "${CYAN}  ┌───────────────────────────────────────────────────────────────────┐${NC}"
    echo -e "${CYAN}  │               DAPATKAN API KEY & ACTIVATION CODE                    │${NC}"
    echo -e "${CYAN}  └───────────────────────────────────────────────────────────────────┘${NC}"
    echo ""

    echo -e "    ${YELLOW}  •${NC}  Buka browser: ${CYAN}https://activation.kresek.my.id:2104/lisence${NC}"
    echo -e "    ${YELLOW}  •${NC}  Login → dapat ${CYAN}API Key${NC}"
    echo -e "    ${YELLOW}  •${NC}  Redeem voucher → dapat ${CYAN}Activation Code${NC}"
    echo ""

    echo -e "${RED}  ⚠ ROOT SSH: TERKUNCI  |  SCP: TERKUNCI  |  SFTP: TERKUNCI ⚠${NC}"
    echo ""

    echo ""
    echo -ne "  Tekan ${GREEN}[Enter]${NC} untuk boot sistem...
  (Aktivasi wajib melalui PuTTY)"
    read
}

main
