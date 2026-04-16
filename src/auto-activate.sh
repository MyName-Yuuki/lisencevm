#!/bin/bash
# ============================================================
# Kresek Auto-Activate - ForceCommand for SSH
# Check .license.key → Show status / Force re-activation
# ============================================================

LICENSE_FILE="/usr/src/.kresek/.license.key"
DEV_MODE="false"

source /usr/src/.kresek/config/config.cfg 2>/dev/null

IP=$(hostname -I | awk '{print $1}')

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

# DEV MODE
if [[ "$DEV_MODE" == "true" ]]; then
    echo -e "${YELLOW}[DEV MODE] License check bypassed${NC}"
    exec /bin/bash
fi

# ============================================================
# LICENSE VALID - Show success, allow shell
# ============================================================
if [[ -f "$LICENSE_FILE" ]] && [[ -s "$LICENSE_FILE" ]]; then
    echo ""
    echo -e "${GREEN}╔═══════════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║             KRESEK LICENSE - AKTIF                                 ║${NC}"
    echo -e "${GREEN}╚═══════════════════════════════════════════════════════════════════════╝${NC}"
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
# LICENSE NOT FOUND - Block + Force re-activation
# ============================================================
echo ""
echo -e "${RED}╔═══════════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${RED}║            KRESEK LICENSE - AKTIVASI WAJIB                         ║${NC}"
echo -e "${RED}╚═══════════════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${YELLOW}  ⚠  FILE .license.key TIDAK DITEMUKAN${NC}"
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
echo -e "${CYAN}  │                     INFORMASI AKSES PUTTY                        │${NC}"
echo -e "${CYAN}  └───────────────────────────────────────────────────────────────────┘${NC}"
echo ""
echo -e "    ${GREEN}► IP Address : ${NC}${YELLOW}${IP}${NC}"
echo -e "    ${GREEN}► User       : ${NC}${YELLOW}kantong${NC}"
echo -e "    ${GREEN}► Password   : ${NC}${YELLOW}kresek${NC}"
echo ""
echo -e "${RED}  ┌───────────────────────────────────────────────────────────────────┐${NC}"
echo -e "${RED}  │                   LANGKAH AKTIVASI (PUTTY)                       │${NC}"
echo -e "${RED}  └───────────────────────────────────────────────────────────────────┘${NC}"
echo ""
echo -e "    ${YELLOW}1.${NC}  Browser: ${CYAN}https://activation.kresek.my.id:2104/lisence${NC}"
echo -e "    ${YELLOW}2.${NC}  Login → dapat ${CYAN}API Key${NC}"
echo -e "    ${YELLOW}3.${NC}  Redeem voucher → dapat ${CYAN}Activation Code${NC}"
echo -e "    ${YELLOW}4.${NC}  Masukkan ${CYAN}API Key${NC} (Step 1)"
echo -e "    ${YELLOW}5.${NC}  Masukkan ${CYAN}Activation Code${NC} (Step 2)"
echo ""
echo ""
echo -ne "  Jalankan aktivasi sekarang? [${GREEN}Y${NC}/${RED}n${NC}]: "
read -r CHOICE

if [[ "$CHOICE" =~ ^[Nn]$ ]]; then
    echo ""
    echo -e "${RED}  Akses dibatalkan.${NC}"
    echo -e "${RED}  SSH akan ditutup...${NC}"
    sleep 2
    exit 255
fi

echo ""
sudo /usr/src/.kresek/src/activation.sh

# After activation
if [[ -f "$LICENSE_FILE" ]] && [[ -s "$LICENSE_FILE" ]]; then
    echo ""
    echo -e "${GREEN}✓ License aktif!${NC}"
    exec /bin/bash
else
    echo ""
    echo -e "${RED}✗ Aktivasi gagal. SSH akan ditutup...${NC}"
    sleep 2
    exit 255
fi
