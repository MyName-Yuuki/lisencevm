#!/bin/bash
# ============================================================
# Kresek Auto-Activate - ForceCommand for SSH
# If .license.key missing → show banner → give user choice
# If .license.key exists → show success → allow shell
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

# DEV MODE BYPASS
if [[ "$DEV_MODE" == "true" ]]; then
    echo -e "${YELLOW}[DEV MODE] License check bypassed${NC}"
    exec /bin/bash
fi

# ============================================================
# LICENSE VALID - Show success and allow shell
# ============================================================
if [[ -f "$LICENSE_FILE" ]] && [[ -s "$LICENSE_FILE" ]]; then
    echo -e "${GREEN}"
    echo "╔═══════════════════════════════════════════════════════════╗"
    echo "║             KRESEK LICENSE - AKTIF                     ║"
    echo "╚═══════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
    echo -e "  ${GREEN}✓ Status      : AKTIF${NC}"
    echo -e "  ${GREEN}✓ ROOT SSH   : AKTIF${NC}"
    echo -e "  ${GREEN}✓ SCP/SFTP   : BUKA${NC}"
    echo ""
    echo -e "  ${CYAN}Akses ROOT via PPK:${NC}"
    echo -e "    Host: ${GREEN}${IP}${NC}  Port: ${GREEN}22${NC}"
    echo -e "    User: ${GREEN}root${NC}  Auth: ${GREEN}PPK Key${NC}"
    echo ""
    exec /bin/bash
fi

# ============================================================
# LICENSE NOT FOUND - Show banner and give user choice
# ============================================================
echo ""
echo -e "${RED}╔═══════════════════════════════════════════════════════════╗${NC}"
echo -e "${RED}║            KRESEK LICENSE - AKTIVASI WAJIB             ║${NC}"
echo -e "${RED}╚═══════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${YELLOW}  ⚠  FILE .license.key TIDAK DITEMUKAN!${NC}"
echo -e "${RED}  ⚠  AKSES DIBLOKIR${NC}"
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
echo -e "${RED}  │                 CARA AKTIVASI                              │${NC}"
echo -e "${RED}  └───────────────────────────────────────────────────────────┘${NC}"
echo ""
echo -e "    ${YELLOW}1.${NC} Buka browser: ${CYAN}https://activation.kresek.my.id:2104/lisence${NC}"
echo -e "    ${YELLOW}2.${NC} Login → dapat ${CYAN}API Key${NC}"
echo -e "    ${YELLOW}3.${NC} Redeem voucher → dapat ${CYAN}Activation Code${NC}"
echo -e "    ${YELLOW}4.${NC} Jalankan: ${CYAN}sudo /usr/src/.kresek/src/activation.sh${NC}"
echo ""
echo -e "    ${YELLOW}A.${NC} Masukkan ${CYAN}API Key${NC} terlebih dahulu (Step 1)"
echo -e "    ${YELLOW}B.${NC} Baru masukkan ${CYAN}Activation Code${NC} (Step 2)"
echo ""
echo ""
echo -ne "  Jalankan aktivasi sekarang? [${GREEN}Y${NC}/${RED}n${NC}]: "
read -r CHOICE

if [[ "$CHOICE" =~ ^[Nn]$ ]]; then
    echo ""
    echo -e "${RED}  Akses dibatalkan. PuTTY akan ditutup...${NC}"
    sleep 2
    exit 255
fi

# Run activation
echo ""
sudo /usr/src/.kresek/src/activation.sh

# After activation, check again
if [[ -f "$LICENSE_FILE" ]] && [[ -s "$LICENSE_FILE" ]]; then
    echo ""
    echo -e "${GREEN}✓ License aktif! Shell dibuka.${NC}"
    exec /bin/bash
else
    echo ""
    echo -e "${RED}  Aktivasi gagal. PuTTY akan ditutup...${NC}"
    sleep 2
    exit 255
fi
