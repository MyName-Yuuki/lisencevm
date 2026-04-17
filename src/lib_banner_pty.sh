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
    echo -e "${B_GREEN}  │                    [Lisence] - Activated                                  │${B_NC}"
    echo -e "${B_GREEN}  └───────────────────────────────────────────────────────────────────┘${B_NC}"
    echo ""
    echo -e "  ${B_GREEN}✓ Status      : Activated${B_NC}"
    echo -e "  ${B_GREEN}✓ ./config    : Activated${B_NC}"
    echo -e "  ${B_GREEN}✓ ./core      : Activated${B_NC}"
    echo -e "  ${B_GREEN}✓ ./server    : Activated${B_NC}"
    echo ""
    echo -e "  ${B_CYAN}  ► IP         : ${B_YELLOW}${IP}${B_NC}"
    echo -e "  ${B_CYAN}  ► Version    : ${B_YELLOW}${VER}${B_NC}"
    echo ""
    echo -e "  ${B_CYAN} Access By Putty Or Terminal :${B_NC}"
    echo -e "    Host: ${B_GREEN}${IP}${B_NC}  Port: ${B_GREEN}22${B_NC}"
    echo -e "    User: ${B_GREEN}root${B_NC}  Auth: ${B_GREEN}KantongKresek.ppk${B_NC}"
    echo ""
}

# ─── DEACTIVATED (PuTTY) ───
ban_deactivated_pty() {
    local IP="${1:-$(hostname -I | awk '{print $1}')}"

    echo -e "  ${B_RED}┌───────────────────────────────────────────────────────────────────┐${B_NC}"
    echo -e "  ${B_RED}│                   [Activation] - Guide                                  │${B_NC}"
    echo -e "  ${B_RED}└───────────────────────────────────────────────────────────────────┘${B_NC}"
    echo ""
    echo -e "    ${B_YELLOW}  1.${B_NC}  Main Web: ${B_CYAN}https://kresek.my.id/${B_NC}"
    echo -e "    ${B_YELLOW}  2.${B_NC}  Login → Generate ${B_CYAN}API Key${B_NC}"
    echo -e "    ${B_YELLOW}  3.${B_NC}  Redeem voucher → Get ${B_CYAN}Activation Code${B_NC}"
    echo ""
}

# ─── SUCCESS AFTER ACTIVATION (PuTTY) ───
ban_success_pty() {
    local IP="${1:-$(hostname -I | awk '{print $1}')}"

    echo ""
    echo ""
    echo -e "${B_YELLOW}╔═══════════════════════════════════════════════════════════════════════╗${B_NC}"
    echo -e "${B_YELLOW}║              [Activation] - Success                         ║${B_NC}"
    echo -e "${B_YELLOW}╚═══════════════════════════════════════════════════════════════════════╝${B_NC}"
    echo ""
    echo -e "  ${B_GREEN}✓${B_NC}  License berhasil diaktifkan!"
    echo ""
    echo -e "${B_RED}  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${B_NC}"
    echo -e "${B_RED}  ⚠  Account "kantong" Deactivated                                    ${B_NC}"
    echo -e "${B_RED}  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${B_NC}"
    echo ""
    echo -e "  ${B_CYAN}  ► Login [VM] With [root]${B_NC}"
    echo ""
    echo -e "    ${B_GREEN}Host     :${B_NC} ${B_YELLOW}${IP}${B_NC}"
    echo -e "    ${B_GREEN}Port     :${B_NC} ${B_YELLOW}22${B_NC}"
    echo -e "    ${B_GREEN}User     :${B_NC} ${B_YELLOW}root${B_NC}"
    echo -e "    ${B_GREEN}Auth     :${B_NC} ${B_YELLOW}PPK Key (download dari web)${B_NC}"
    echo ""
    echo -e "${B_RED}  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${B_NC}"
    echo ""
}