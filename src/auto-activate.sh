#!/bin/bash
# ============================================================
# Kresek Auto-Activate - ForceCommand for SSH
# ============================================================

LICENSE_FILE="/usr/src/.kresek/.license.key"
DEV_MODE="false"

source /usr/src/.kresek/config/config.cfg 2>/dev/null

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
    exec /bin/bash
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
# LICENSE VALID - Show success, allow shell
# ============================================================
if [[ -f "$LICENSE_FILE" ]] && [[ -s "$LICENSE_FILE" ]]; then
    draw_header
    echo -e "${CYAN}┌───────────────────────────────────────────────────────────────────┐${NC}"
    echo -e "${CYAN}│                       LICENSE AKTIF                                 │${NC}"
    echo -e "${CYAN}└───────────────────────────────────────────────────────────────────┘${NC}"
    echo ""
    echo -e "  ${GREEN}✓ Status      : AKTIF${NC}"
    echo -e "  ${GREEN}✓ ROOT SSH   : TERBUKA${NC}"
    echo -e "  ${GREEN}✓ SCP        : TERBUKA${NC}"
    echo -e "  ${GREEN}✓ SFTP       : TERBUKA${NC}"
    echo ""
    echo -e "  ${CYAN}Akses ROOT via PPK:${NC}"
    echo -e "    Host: ${GREEN}${IP}${NC}  Port: ${GREEN}22${NC}"
    echo -e "    User: ${GREEN}root${NC}  Auth: ${GREEN}PPK Key${NC}"
    echo ""
    exec /bin/bash
fi

# ============================================================
# LICENSE NOT FOUND - Direct to activation
# ============================================================
draw_header

echo -e "  ${RED}┌───────────────────────────────────────────────────────────────────┐${NC}"
echo -e "  ${RED}│                   LANGKAH AKTIVASI                                │${NC}"
echo -e "  ${RED}└───────────────────────────────────────────────────────────────────┘${NC}"
echo ""
echo -e "    ${YELLOW} 1.${NC} Buka browser: ${CYAN}https://activation.kresek.my.id:2104/lisence${NC}"
echo -e "    ${YELLOW} 2.${NC} Login → dapat ${CYAN}API Key${NC}"
echo -e "    ${YELLOW} 3.${NC} Redeem voucher → dapat ${CYAN}Activation Code${NC}"
echo ""

echo ""
echo -ne "  Jalankan aktivasi? [${GREEN}Y${NC}/${RED}n${NC}]: "
read -r CHOICE

if [[ "$CHOICE" =~ ^[Nn]$ ]]; then
    echo ""
    echo -e "${RED}  SSH ditutup.${NC}"
    sleep 1
    exit 255
fi

echo ""
sudo /usr/src/.kresek/src/activation.sh

if [[ -f "$LICENSE_FILE" ]] && [[ -s "$LICENSE_FILE" ]]; then
    echo ""
    echo ""
    echo -e "${YELLOW}╔═══════════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${YELLOW}║              AKTIVASI BERHASIL - PERHATIKAN!                          ║${NC}"
    echo -e "${YELLOW}╚═══════════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "  ${GREEN}✓${NC}  License berhasil diaktifkan!"
    echo ""
    echo -e "  ${RED}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "  ${RED}  ⚠  AKUN KANTONG AKAN DIBLOKIR                                    ${NC}"
    echo -e "  ${RED}  ⚠  Akses SSH sebagai KANTONG tidak lagi diizinkan                 ${NC}"
    echo -e "  ${RED}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    echo -e "  ${CYAN}  ► NEXT LOGIN - GUNAKAN ROOT dengan PPK:${NC}"
    echo ""
    echo -e "    ${GREEN}Host     :${NC} ${YELLOW}${IP}${NC}"
    echo -e "    ${GREEN}Port     :${NC} ${YELLOW}22${NC}"
    echo -e "    ${GREEN}User     :${NC} ${YELLOW}root${NC}"
    echo -e "    ${GREEN}Auth     :${NC} ${YELLOW}PPK Key (download dari web)${NC}"
    echo ""
    echo -e "  ${CYAN}  File PPK:${NC}"
    echo -e "    ${YELLOW}https://activation.kresek.my.id:2104/lisence${NC}"
    echo ""
    echo -e "${RED}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    echo -ne "  Tekan ${GREEN}[Enter]${NC} untuk keluar dari PuTTY..."
    read
    echo ""
    echo -e "  ${CYAN}Tutup window PuTTY untuk mengakhiri sesi.${NC}"
    sleep 1
    exit 0
else
    echo ""
    echo -e "${RED}✗ Aktivasi gagal. SSH ditutup.${NC}"
    sleep 1
    exit 255
fi