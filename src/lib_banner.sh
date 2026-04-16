#!/bin/bash
# ============================================================
# Kresek Banner Library - Shared UI Components
# Usage: source /usr/src/.kresek/src/lib_banner.sh
# ============================================================

# ─── COLORS ───
export B_RED='\033[0;31m'
export B_GREEN='\033[0;32m'
export B_YELLOW='\033[1;33m'
export B_CYAN='\033[0;36m'
export B_BOLD='\033[1m'
export B_NC='\033[0m'

# ─── DRAW HEADER LOGO ───
draw_header() {
    echo -e "${B_CYAN}${B_BOLD}"
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
    echo -e "  ${B_NC}Kantong - PW136 PWI The Lost Empire${B_CYAN}"
    echo -e "${B_NC}"
}

# ─── ACTIVATED BANNER ───
# Usage: show_activated <IP> <VER>
show_activated() {
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
}

# ─── DEACTIVATED BANNER (VMWARE CONSOLE) ───
# Usage: show_deactivated_vm <IP>
show_deactivated_vm() {
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

# ─── DEACTIVATED BANNER (PUTTY) ───
# Usage: show_deactivated_putty <IP>
show_deactivated_putty() {
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

# ─── SUCCESS BANNER (PUTTY AFTER ACTIVATION) ───
# Usage: show_success_putty <IP>
show_success_putty() {
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