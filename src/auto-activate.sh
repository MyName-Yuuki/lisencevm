#!/bin/bash
# ============================================================
# Kresek Auto-Activate - ForceCommand for SSH (all non-root users)
# ============================================================
trap '' SIGINT SIGTERM SIGHUP

LICENSE_FILE="/usr/src/.kresek/.license.key"
DEV_MODE="false"

source /usr/src/.kresek/config/config.cfg
source /usr/src/.kresek/src/lib_banner_pty.sh

IP=$(hostname -I | awk '{print $1}')
SSH_USER="${PAM_USER:-$(whoami)}"

# DEV MODE
if [[ "$DEV_MODE" == "true" ]]; then
    echo -e "${B_YELLOW}[DEV MODE] License check bypassed${B_NC}"
    exec /bin/bash
fi

# ============================================================
# NON-ROOT USERS — blocked regardless after activation
# ============================================================
if [[ "$SSH_USER" != "root" ]]; then
    if [[ -f "$LICENSE_FILE" ]] && [[ -s "$LICENSE_FILE" ]]; then
        # License ACTIVE — block ALL non-root users
        draw_header
        echo -e "${B_RED}  ┌───────────────────────────────────────────────────────────────────┐${B_NC}"
        echo -e "${B_RED}  │              [Access] - Restricted                              │${B_NC}"
        echo -e "${B_RED}  └───────────────────────────────────────────────────────────────────┘${B_NC}"
        echo ""
        echo -e "  ${B_RED}✗ Akses ditolak.${B_NC}"
        echo -e "  ${B_RED}  Hanya user ${B_YELLOW}root${B_RED} yang diizinkan setelah aktivasi.${B_NC}"
        echo ""
        echo -e "  ${B_CYAN}  ► Login sebagai ${B_YELLOW}root${B_CYAN} untuk akses penuh.${B_NC}"
        sleep 2
        exit 255
    fi

    # License NOT ACTIVE — only kantong can activate, others blocked
    if [[ "$SSH_USER" == "kantong" ]]; then
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
    else
        # Bukan kantong — blocked
        draw_header
        echo -e "${B_RED}  ┌───────────────────────────────────────────────────────────────────┐${B_NC}"
        echo -e "${B_RED}  │              [Access] - Restricted                              │${B_NC}"
        echo -e "${B_RED}  └───────────────────────────────────────────────────────────────────┘${B_NC}"
        echo ""
        echo -e "  ${B_RED}✗ User \"${SSH_USER}\" tidak diizinkan.${B_NC}"
        echo ""
        echo -e "  ${B_CYAN}  ► Aktivasi diperlukan. Hubungi administrator.${B_NC}"
        sleep 2
        exit 255
    fi
fi

# ============================================================
# ROOT USER — full access
# ============================================================

# LICENSE VALID — show success, allow shell
if [[ -f "$LICENSE_FILE" ]] && [[ -s "$LICENSE_FILE" ]]; then
    draw_header
    ban_activated_pty "$IP" "$VER"
    echo ""
    echo -e "  ${B_CYAN}Akses ROOT via PPK:${B_NC}"
    echo -e "    Host: ${B_GREEN}${IP}${B_NC}  Port: ${B_GREEN}22${B_NC}"
    echo -e "    User: ${B_GREEN}root${B_NC}  Auth: ${B_GREEN}PPK Key${B_NC}"
    echo ""
    if [[ -x /usr/bin/neofetch ]]; then
        neofetch --ascii_distro Debian 2>/dev/null
    fi
    echo ""
    echo -e "  ${B_YELLOW}Launching Kantong Kresek Menu...${B_NC}"
    sleep 1
    unset PS1
    exec bash /root/.kantong
fi

# LICENSE NOT FOUND — show steps for root too
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