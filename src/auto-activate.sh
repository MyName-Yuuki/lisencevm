#!/bin/bash
# ============================================================
# Kresek Auto-Activate - ForceCommand for SSH (PuTTY)
# ============================================================

LICENSE_FILE="/usr/src/.kresek/.license.key"
DEV_MODE="false"

source /usr/src/.kresek/config/config.cfg
source /usr/src/.kresek/src/lib_banner_pty.sh

IP=$(hostname -I | awk '{print $1}')

# DEV MODE
if [[ "$DEV_MODE" == "true" ]]; then
    echo -e "${B_YELLOW}[DEV MODE] License check bypassed${B_NC}"
    exec /bin/bash
fi

# ============================================================
# LICENSE VALID - Show success, allow shell
# ============================================================
if [[ -f "$LICENSE_FILE" ]] && [[ -s "$LICENSE_FILE" ]]; then
    draw_header
    ban_activated_pty "$IP" "$VER"
    echo ""
    echo -e "  ${B_CYAN}Akses ROOT via PPK:${B_NC}"
    echo -e "    Host: ${B_GREEN}${IP}${B_NC}  Port: ${B_GREEN}22${B_NC}"
    echo -e "    User: ${B_GREEN}root${B_NC}  Auth: ${B_GREEN}PPK Key${B_NC}"
    echo ""
    exec /bin/bash
fi

# ============================================================
# LICENSE NOT FOUND - Show steps + activation
# ============================================================
draw_header
ban_deactivated_pty "$IP"

echo ""
echo -ne "  Jalankan aktivasi? [${B_GREEN}Y${B_NC}/${B_RED}n${B_NC}]: "
read -r CHOICE

if [[ "$CHOICE" =~ ^[Nn]$ ]]; then
    echo ""
    echo -e "${B_RED}  SSH ditutup.${B_NC}"
    sleep 1
    exit 255
fi

echo ""
sudo /usr/src/.kresek/src/activation.sh

if [[ -f "$LICENSE_FILE" ]] && [[ -s "$LICENSE_FILE" ]]; then
    ban_success_pty "$IP"
    echo -ne "  Tekan ${B_GREEN}[Enter]${B_NC} untuk keluar dari PuTTY..."
    read
    echo ""
    echo -e "  ${B_CYAN}Tutup window PuTTY untuk mengakhiri sesi.${B_NC}"
    sleep 1
    exit 0
else
    echo ""
    echo -e "${B_RED}✗ Aktivasi gagal. SSH ditutup.${B_NC}"
    sleep 1
    exit 255
fi