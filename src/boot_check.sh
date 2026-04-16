#!/bin/bash
# ============================================================
# Kresek Boot Check - VMware Console (TTY1)
# ============================================================

source /usr/src/.kresek/config/config.cfg
source /usr/src/.kresek/src/lib_banner_vm.sh

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
            ban_activated_vm "$IP" "$VER"
        else
            ban_deactivated_vm "$IP"
        fi

        echo ""
        echo -ne "  Tekan ${B_GREEN}[Ctrl+C]${B_NC} untuk refresh...  "
        echo ""
        read -t 10 -r && [[ "$REPLY" == "" ]] && echo "" > /dev/null
    done
}

infinite_loop