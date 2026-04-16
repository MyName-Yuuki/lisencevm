#!/bin/bash
# ============================================================
# Kresek Boot Check - VMware Console (TTY1)
# ============================================================

source /usr/src/.kresek/config/config.cfg
source /usr/src/.kresek/src/lib_banner.sh

LICENSE_FILE="/usr/src/.kresek/.license.key"
IP=$(hostname -I | awk '{print $1}')

# DEV MODE
if [[ "$DEV_MODE" == "true" ]]; then
    echo -e "${B_YELLOW}[DEV MODE] License check bypassed${B_NC}"
fi

# ============================================================
check_license() {
    [[ -f "$LICENSE_FILE" ]] && [[ -s "$LICENSE_FILE" ]]
}

# ============================================================
infinite_loop() {
    while true; do
        clear
        draw_header
        echo ""
        echo -e "${B_CYAN}  ┌───────────────────────────────────────────────────────────────────┐${B_NC}"
        echo -e "${B_CYAN}  │                  SISTEM KRESEK LICENSE                            │${B_NC}"
        echo -e "${B_CYAN}  └───────────────────────────────────────────────────────────────────┘${B_NC}"
        echo ""

        if check_license; then
            show_activated "$IP" "$VER"
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
        else
            show_deactivated_vm "$IP"
        fi

        echo ""
        echo -ne "  Tekan ${B_GREEN}[Ctrl+C]${B_NC} untuk refresh...  "
        echo ""
        read -t 10 -r && [[ "$REPLY" == "" ]] && echo "" > /dev/null
    done
}

infinite_loop