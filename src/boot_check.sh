#!/bin/bash
# ============================================================
# Kresek Boot Check - VMware Console (TTY1)
# Tidak bisa akses shell/login langsung dari VMware Console
# Semua akses harus lewat PuTTY
# ============================================================

source /usr/src/.kresek/config/config.cfg

LICENSE_FILE="/usr/src/.kresek/.license.key"
IP=$(hostname -I | awk '{print $1}')

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

# DEV MODE
if [[ "$DEV_MODE" == "true" ]]; then
    echo -e "${YELLOW}[DEV MODE] License check bypassed${NC}"
fi

# ============================================================
draw_header() {
    echo -e "${CYAN}${BOLD}"
    echo -e "¦¦+  ¦¦+ ¦¦¦¦¦+ ¦¦¦+   ¦¦+¦¦¦¦¦¦¦¦+ ¦¦¦¦¦¦+ ¦¦¦+   ¦¦+ ¦¦¦¦¦+  "
    echo -e "¦¦+  ¦+¦+--¦+ ¦+--+  ¦+---+++--¦+---++----++  "
    echo -e "++++  ++    ++  ++     ++    ++     ++     ++     "
    echo -e "+-++-++-  +-++-+  +-++-+  +-++-++-  ++-++-++-  "
    echo -e "+-++-++-  +-+  +-+    +-+  +-+    +-+     +-+  "
    echo -e "+-+  +-+  +-+   +-+    +-+  +-+    +-+     +-+  "
    echo -e ""
    echo -e "¦¦+  ¦¦+  KRESEK LICENSE SYSTEM  ¦¦+  ¦¦+"
    echo -e "¦¦+  ¦+¦+--+ ¦¦+----+ ¦+--+ ¦+--++-+  ¦+¦+--+"
    echo -e "++++  ++  ++  ++++++  ++  ++  ++ ++  ++  ++  ++"
    echo -e "+-++-++  +-+  ++-++-+  +-+  +-++-+  +-++-++  +-+"
    echo -e "+-++-++  +-+  ++-  +-+ +-+  +-+    +-+  +-+  +-+"
    echo -e "+-+  +-+  +-+  ++-  +-+ +-+  +-+    +-+  +-+  +-+"
    echo -e ""
    echo -e "  ${NC}Kantong - PW136 PWI The Lost Empire${CYAN}"
    echo -e "${NC}"
}

# ============================================================
check_license() {
    [[ -f "$LICENSE_FILE" ]] && [[ -s "$LICENSE_FILE" ]]
}

# ============================================================
do_activate() {
    echo -e "${RED}  ┌───────────────────────────────────────────────────────────────────┐${NC}"
    echo -e "${RED}  │            AKTIVASI BELUM DILAKUKAN                              │${NC}"
    echo -e "${RED}  └───────────────────────────────────────────────────────────────────┘${NC}"
    echo ""
    echo -e "  ${YELLOW}  ⚠  Akses langsung dari VMware Console DIBLOKIR              ${NC}"
    echo -e "  ${YELLOW}  ⚠  Login shell tidak tersedia di Console ini                ${NC}"
    echo ""
    echo -e "${RED}  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${RED}  ⚠  ROOT SSH : TERKUNCI  |  SCP : TERKUNCI  |  SFTP : TERKUNCI${NC}"
    echo -e "${RED}  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    echo -e "  ${CYAN}  ► AKTIVASI HARUS DILAKUKAN VIA PUTTY:${NC}"
    echo ""
    echo -e "    ${YELLOW}  1.${NC}  Buka aplikasi ${GREEN}PuTTY${NC}"
    echo -e "    ${YELLOW}  2.${NC}  Host: ${GREEN}${IP}${NC}  |  Port: ${GREEN}22${NC}  |  SSH"
    echo -e "    ${YELLOW}  3.${NC}  Klik ${GREEN}Open${NC} → Login: ${GREEN}kantong${NC} / ${GREEN}kresek${NC}"
    echo -e "    ${YELLOW}  4.${NC}  Ikuti langkah aktivasi di form PuTTY"
    echo ""
    echo -e "  ${CYAN}  ► DAPATKAN LICENSE DI WEB:${NC}"
    echo -e "    ${CYAN}  https://activation.kresek.my.id:2104/lisence${NC}"
    echo ""
}

# ============================================================
do_success() {
    echo -e "${GREEN}  ┌───────────────────────────────────────────────────────────────────┐${NC}"
    echo -e "${GREEN}  │                    LICENSE AKTIF                                  │${NC}"
    echo -e "${GREEN}  └───────────────────────────────────────────────────────────────────┘${NC}"
    echo ""
    echo -e "  ${GREEN}✓ Status      : AKTIF${NC}"
    echo -e "  ${GREEN}✓ ROOT SSH   : TERBUKA${NC}"
    echo -e "  ${GREEN}✓ SCP        : TERBUKA${NC}"
    echo -e "  ${GREEN}✓ SFTP       : TERBUKA${NC}"
    echo ""
    echo -e "  ${CYAN}  ► VERSI        : ${YELLOW}${VER}${NC}"
    echo -e "  ${CYAN}  ► IP ADDRESS   : ${YELLOW}${IP}${NC}"
    echo ""
    echo -e "${YELLOW}  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${YELLOW}  ⚠  AKSES SHELL DARI VMware Console DIBLOKIR                    ${NC}"
    echo -e "${YELLOW}  ⚠  LOGIN LANGSUNG KE VM TIDAK DIIZINKAN                       ${NC}"
    echo -e "${YELLOW}  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    echo -e "  ${CYAN}  ► GUNAKAN PUTTY UNTUK AKSES ROOT:${NC}"
    echo ""
    echo -e "    ${GREEN}Host     :${NC} ${YELLOW}${IP}${NC}"
    echo -e "    ${GREEN}Port     :${NC} ${YELLOW}22${NC}"
    echo -e "    ${GREEN}User     :${NC} ${YELLOW}root${NC}"
    echo -e "    ${GREEN}Auth     :${NC} ${YELLOW}PPK Key (download dari web)${NC}"
    echo ""
    echo -e "  ${CYAN}  ► UNDUH PPK KEY:${NC}"
    echo -e "    ${YELLOW}https://activation.kresek.my.id:2104/lisence${NC}"
    echo ""
}

# ============================================================
# INFINITE LOOP - Jaga agar tidak pernah masuk ke login prompt
# User harus akses VM via PuTTY saja
# ============================================================
infinite_loop() {
    while true; do
        clear
        draw_header
        echo ""
        echo -e "${CYAN}  ┌───────────────────────────────────────────────────────────────────┐${NC}"
        echo -e "${CYAN}  │                  SISTEM KRESEK LICENSE                            │${NC}"
        echo -e "${CYAN}  └───────────────────────────────────────────────────────────────────┘${NC}"
        echo ""

        if check_license; then
            do_success
        else
            do_activate
        fi

        echo ""
        echo -ne "  Tekan ${GREEN}[Ctrl+C]${NC} untuk refresh...  "
        echo ""
        # Sleep lama, tapi interruptible
        read -t 10 -r && [[ "$REPLY" == "" ]] && echo "" > /dev/null
    done
}

# Start infinite loop - blocking screen
infinite_loop