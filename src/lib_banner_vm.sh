#!/bin/bash
# ============================================================
# Kresek Banner - VMware CLI Console (TTY1)
# Usage: source /usr/src/.kresek/src/lib_banner_vm.sh
# ============================================================

source /usr/src/.kresek/src/lib_banner.sh

# ─── ACTIVATED (VMware Console) ───
ban_activated_vm() {
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
    echo -e "${B_YELLOW}  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${B_NC}"
    echo -e "${B_YELLOW}  ⚠  AKSES SHELL DARI VMware Console DIBLOKIR                    ${B_NC}"
    echo -e "${B_YELLOW}  ⚠  LOGIN LANGSUNG KE VM TIDAK DIIZINKAN                       ${B_NC}"
    echo -e "${B_YELLOW}  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${B_NC}"
    echo ""
    echo -e "  ${B_CYAN}  ► GUNAKAN PUTTY UNTUK AKSES ROOT:${B_NC}"
    echo ""
    echo -e "    ${B_GREEN}Host     :${B_NC} ${B_YELLOW}${IP}${B_NC}"
    echo -e "    ${B_GREEN}Port     :${B_NC} ${B_YELLOW}22${B_NC}"
    echo -e "    ${B_GREEN}User     :${B_NC} ${B_YELLOW}root${B_NC}"
    echo -e "    ${B_GREEN}Auth     :${B_NC} ${B_YELLOW}PPK Key (download dari web)${B_NC}"
    echo ""
    echo -e "  ${B_CYAN}  ► UNDUH PPK KEY:${B_NC}"
    echo -e "    ${B_YELLOW}https://activation.kresek.my.id:2104/lisence${B_NC}"
    echo ""
}

# ─── DEACTIVATED (VMware Console) ───
ban_deactivated_vm() {
    local IP="${1:-$(hostname -I | awk '{print $1}')}"

    echo -e "${B_RED}  ┌───────────────────────────────────────────────────────────────────┐${B_NC}"
    echo -e "${B_RED}  │            AKTIVASI BELUM DILAKUKAN                              │${B_NC}"
    echo -e "${B_RED}  └───────────────────────────────────────────────────────────────────┘${B_NC}"
    echo ""
    echo -e "  ${B_YELLOW}  ⚠  Akses langsung dari VMware Console DIBLOKIR              ${B_NC}"
    echo -e "  ${B_YELLOW}  ⚠  Login shell tidak tersedia di Console ini                ${B_NC}"
    echo ""
    echo -e "${B_RED}  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${B_NC}"
    echo -e "${B_RED}  ⚠  ROOT SSH : TERKUNCI  |  SCP : TERKUNCI  |  SFTP : TERKUNCI${B_NC}"
    echo -e "${B_RED}  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${B_NC}"
    echo ""
    echo -e "  ${B_CYAN}  ► AKTIVASI HARUS DILAKUKAN VIA PUTTY:${B_NC}"
    echo ""
    echo -e "    ${B_YELLOW}  1.${B_NC}  Buka aplikasi ${B_GREEN}PuTTY${B_NC}"
    echo -e "    ${B_YELLOW}  2.${B_NC}  Host: ${B_GREEN}${IP}${B_NC}  |  Port: ${B_GREEN}22${B_NC}  |  SSH"
    echo -e "    ${B_YELLOW}  3.${B_NC}  Klik ${B_GREEN}Open${B_NC} → Login: ${B_GREEN}kantong${B_NC} / ${B_GREEN}kresek${B_NC}"
    echo -e "    ${B_YELLOW}  4.${B_NC}  Ikuti langkah aktivasi di form PuTTY"
    echo ""
    echo -e "  ${B_CYAN}  ► DAPATKAN LICENSE DI WEB:${B_NC}"
    echo -e "    ${B_CYAN}  https://activation.kresek.my.id:2104/lisence${B_NC}"
    echo ""
}