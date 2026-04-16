#!/bin/bash
# ============================================================
# Kresek Banner - PuTTY SSH
# Usage: source /usr/src/.kresek/src/lib_banner_pty.sh
# ============================================================

source /usr/src/.kresek/src/lib_banner.sh

# ─── ACTIVATED (PuTTY) ───
ban_activated_pty() {
    local IP="${1:-$(hostname -I | awk '{print $1}')}"
    local VER="${2:-$(grep '^VER=' /usr/src/.kresek/config/config.cfg 2>/dev/null | cut -d'"' -f2)}"

    echo -e "${B_GREEN}  ┌───────────────────────────────────────────────────────────────────┐${B_NC}"
    echo -e "${B_GREEN}  │                    LICENSE AKTIF                                  │${B_NC}"
    echo -e "${B_GREEN}  └───────────────────────────────────────────────────────────────────┘${B_NC}"
    echo ""
    echo -e "  ${B_GREEN}✓ Status      : AKTIF${B_NC}"
    echo -e "  ${B_GREEN}✓ ROOT SSH   : TERBUKA${B_NC}"
    echo -e "  ${B_GREEN}✓ SCP        : TERBUKA${B_NC}"
    echo -e "  ${B_GREEN}✓ SFTP       : TERBUKA${B_NC}"
    echo ""
    echo -e "  ${B_CYAN}  ► IP         : ${B_YELLOW}${IP}${B_NC}"
    echo -e "  ${B_CYAN}  ► Version    : ${B_YELLOW}${VER}${B_NC}"
    echo ""
    echo -e "  ${B_CYAN}Akses ROOT via PPK:${B_NC}"
    echo -e "    Host: ${B_GREEN}${IP}${B_NC}  Port: ${B_GREEN}22${B_NC}"
    echo -e "    User: ${B_GREEN}root${B_NC}  Auth: ${B_GREEN}PPK Key${B_NC}"
    echo ""
}

# ─── DEACTIVATED (PuTTY) ───
ban_deactivated_pty() {
    local IP="${1:-$(hostname -I | awk '{print $1}')}"

    echo -e "  ${B_RED}┌───────────────────────────────────────────────────────────────────┐${B_NC}"
    echo -e "  ${B_RED}│                   LANGKAH AKTIVASI                                │${B_NC}"
    echo -e "  ${B_RED}└───────────────────────────────────────────────────────────────────┘${B_NC}"
    echo ""
    echo -e "    ${B_YELLOW}  1.${B_NC}  Buka browser: ${B_CYAN}https://activation.kresek.my.id:2104/lisence${B_NC}"
    echo -e "    ${B_YELLOW}  2.${B_NC}  Login → dapat ${B_CYAN}API Key${B_NC}"
    echo -e "    ${B_YELLOW}  3.${B_NC}  Redeem voucher → dapat ${B_CYAN}Activation Code${B_NC}"
    echo ""
}

# ─── SUCCESS AFTER ACTIVATION (PuTTY) ───
ban_success_pty() {
    local IP="${1:-$(hostname -I | awk '{print $1}')}"

    echo ""
    echo ""
    echo -e "${B_YELLOW}╔═══════════════════════════════════════════════════════════════════════╗${B_NC}"
    echo -e "${B_YELLOW}║              AKTIVASI BERHASIL - PERHATIKAN!                          ║${B_NC}"
    echo -e "${B_YELLOW}╚═══════════════════════════════════════════════════════════════════════╝${B_NC}"
    echo ""
    echo -e "  ${B_GREEN}✓${B_NC}  License berhasil diaktifkan!"
    echo ""
    echo -e "${B_RED}  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${B_NC}"
    echo -e "${B_RED}  ⚠  AKUN KANTONG AKAN DIBLOKIR                                    ${B_NC}"
    echo -e "${B_RED}  ⚠  Akses SSH sebagai KANTONG tidak lagi diizinkan                 ${B_NC}"
    echo -e "${B_RED}  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${B_NC}"
    echo ""
    echo -e "  ${B_CYAN}  ► NEXT LOGIN - GUNAKAN ROOT dengan PPK:${B_NC}"
    echo ""
    echo -e "    ${B_GREEN}Host     :${B_NC} ${B_YELLOW}${IP}${B_NC}"
    echo -e "    ${B_GREEN}Port     :${B_NC} ${B_YELLOW}22${B_NC}"
    echo -e "    ${B_GREEN}User     :${B_NC} ${B_YELLOW}root${B_NC}"
    echo -e "    ${B_GREEN}Auth     :${B_NC} ${B_YELLOW}PPK Key (download dari web)${B_NC}"
    echo ""
    echo -e "  ${B_CYAN}  ► File PPK:${B_NC}"
    echo -e "    ${B_YELLOW}https://activation.kresek.my.id:2104/lisence${B_NC}"
    echo ""
    echo -e "${B_RED}  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${B_NC}"
    echo ""
}