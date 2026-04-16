#!/bin/bash
# ============================================================
# Kresek License Activation System
# ============================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../config/config.cfg"
source "$SCRIPT_DIR/lib_banner.sh"

HWID=$(cat /sys/class/dmi/id/product_uuid 2>/dev/null | tr '[:lower:]' '[:upper:]')
IP=$(hostname -I | awk '{print $1}')

API_ACTIVATE_URL=$(eval echo "$API_ACTIVATE")

# ============================================================
check_license() { [[ -f "$LICENSE_FILE" ]] && [[ -s "$LICENSE_FILE" ]]; }

# ============================================================
unlock_all() {
    sed -i 's/^PermitRootLogin.*/PermitRootLogin prohibit-password/' /etc/ssh/sshd_config
    sed -i '/# KRESEK BLOCK SFTP/d' /etc/ssh/sshd_config
    if ! grep -q "^Subsystem.*sftp" /etc/ssh/sshd_config; then
        echo "Subsystem sftp /usr/lib/openssh/sftp-server" >> /etc/ssh/sshd_config
    fi
    if [[ ! -d /run/sshd ]]; then mkdir -p /run/sshd; fi
    systemctl reload sshd 2>/dev/null || systemctl reload ssh

    echo ""
    echo -e "  ${B_GREEN}  ✓ ROOT SSH   : Open${B_NC}"
    echo -e "  ${B_GREEN}  ✓ SCP        : Open${B_NC}"
    echo -e "  ${B_GREEN}  ✓ SFTP       : Open${B_NC}"
}

# ============================================================
do_login() {
    clear
    draw_header
    echo -e "${B_CYAN}┌───────────────────────────────────────────────────────────────────┐${B_NC}"
    echo -e "${B_CYAN}│                     STEP 1 : INPUT API KEY                             │${B_NC}"
    echo -e "${B_CYAN}└───────────────────────────────────────────────────────────────────┘${B_NC}"
    echo ""
    echo -e "  ${B_YELLOW}  Dapatkan API Key di ${B_NC}"
    echo -e "  ${B_CYAN}    https://kresek.my.id${B_NC}"
    echo ""
    echo -ne "  Masukkan ${B_GREEN}API Key${B_NC}: "
    read -r API_KEY

    if [[ -z "$API_KEY" ]]; then
        echo -e "\n  ${B_RED}✗ API Key tidak boleh kosong!${B_NC}"
        sleep 2
        return 1
    fi

    echo "$API_KEY" > "$SCRIPT_DIR/../config/.api_key"
    chmod 600 "$SCRIPT_DIR/../config/.api_key"

    echo ""
    echo -e "  ${B_GREEN}✓ API Key disimpan!${B_NC}"
    echo -e "  ${B_GREEN}  Lanjut ke Step 2.${B_NC}"
    sleep 2
    return 0
}

# ============================================================
do_activate() {
    clear
    draw_header
    echo -e "${B_CYAN}┌───────────────────────────────────────────────────────────────────┐${B_NC}"
    echo -e "${B_CYAN}│                     STEP 2 : AKTIVASI LICENSE                         │${B_NC}"
    echo -e "${B_CYAN}└───────────────────────────────────────────────────────────────────┘${B_NC}"
    echo ""

    API_KEY_FILE="$SCRIPT_DIR/../config/.api_key"
    if [[ ! -f "$API_KEY_FILE" ]]; then
        echo -e "  ${B_RED}✗ Jalankan STEP 1 terlebih dahulu!${B_NC}"
        echo ""
        echo -ne "  Tekan ${B_GREEN}[Enter]${B_NC}..."
        read
        return 1
    fi

    API_KEY=$(cat "$API_KEY_FILE")

    echo -e "  ${B_CYAN}  ► IP Address  : ${B_YELLOW}${IP}${B_NC}"
    echo -e "  ${B_CYAN}  ► HWID        : ${B_YELLOW}${HWID}${B_NC}"
    echo -e "  ${B_CYAN}  ► Version     : ${B_YELLOW}${VER}${B_NC}"
    echo ""

    echo -ne "  Masukkan ${B_GREEN}Activation Code${B_NC}: "
    read -r ACTIVATION_CODE

    if [[ -z "$ACTIVATION_CODE" ]]; then
        echo -e "\n  ${B_RED}✗ Activation Code tidak boleh kosong!${B_NC}"
        sleep 2
        return 1
    fi

    echo ""
    echo -e "  ${B_YELLOW}⟳ Menghubungi server...${B_NC}"

    RESPONSE=$(curl -s -k -X POST "$API_ACTIVATE_URL" \
        -H "Content-Type: application/json" \
        -H "X-API-Key: $API_KEY" \
        -d "{
            \"activation_code\": \"$ACTIVATION_CODE\",
            \"ver\": \"$VER\",
            \"hwid\": \"$HWID\"
        }" 2>&1)

    echo ""
    echo -e "  ${B_CYAN}Server Response:${B_NC}"
    echo "$RESPONSE" | python3 -m json.tool 2>/dev/null || echo "$RESPONSE"
    echo ""

    SUCCESS=$(echo "$RESPONSE" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('success', False))" 2>/dev/null)
    TOKEN=$(echo "$RESPONSE" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('token', ''))" 2>/dev/null)
    ERROR=$(echo "$RESPONSE" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('error', ''))" 2>/dev/null)

    if [[ "$SUCCESS" == "True" && -n "$TOKEN" ]]; then
        printf '%s' "$TOKEN" > "$LICENSE_FILE"
        chmod 600 "$LICENSE_FILE"
        rm -f "$API_KEY_FILE"

        unlock_all

        echo ""
        echo -e "${B_GREEN}  ┌───────────────────────────────────────────────────────────────────┐${B_NC}"
        echo -e "${B_GREEN}  │                    ✓ AKTIVASI BERHASIL!                             │${B_NC}"
        echo -e "${B_GREEN}  └───────────────────────────────────────────────────────────────────┘${B_NC}"
        echo ""
        echo -e "  ${B_GREEN}  ✓ Token disimpan: $LICENSE_FILE${B_NC}"
        echo ""
        echo -ne "  Tekan ${B_GREEN}[Enter]${B_NC}..."
        read
        return 0
    else
        echo ""
        echo -e "${B_RED}  ┌───────────────────────────────────────────────────────────────────┐${B_NC}"
        echo -e "${B_RED}  │                    ✗ AKTIVASI GAGAL!                              │${B_NC}"
        echo -e "${B_RED}  └───────────────────────────────────────────────────────────────────┘${B_NC}"
        echo ""
        echo -e "  ${B_RED}  Error: $ERROR${B_NC}"
        echo ""
        echo -ne "  Tekan ${B_GREEN}[Enter]${B_NC}..."
        read
        return 1
    fi
}

# ============================================================
do_status() {
    clear
    draw_header
    echo -e "${B_CYAN}┌───────────────────────────────────────────────────────────────────┐${B_NC}"
    echo -e "${B_CYAN}│                        STATUS LICENSE                               │${B_NC}"
    echo -e "${B_CYAN}└───────────────────────────────────────────────────────────────────┘${B_NC}"
    echo ""

    if check_license; then
        echo -e "  ${B_GREEN}✓ Status      : Activated${B_NC}"
        echo -e "  ${B_GREEN}✓ ROOT SSH   : Open${B_NC}"
        echo -e "  ${B_GREEN}✓ SCP        : Open${B_NC}"
        echo -e "  ${B_GREEN}✓ SFTP       : Open${B_NC}"
    else
        echo -e "  ${B_RED}✗ Status      : Deactivated${B_NC}"
        echo -e "  ${B_RED}✗ ROOT SSH   : Close${B_NC}"
        echo -e "  ${B_RED}✗ SCP        : Close${B_NC}"
        echo -e "  ${B_RED}✗ SFTP       : Close${B_NC}"
    fi

    echo ""
    echo -e "  ${B_CYAN}  ► IP Address : ${IP}${B_NC}"
    echo -e "  ${B_CYAN}  ► HWID       : ${HWID}${B_NC}"
    echo -e "  ${B_CYAN}  ► Version    : ${VER}${B_NC}"
    echo ""
    echo -ne "  Tekan ${B_GREEN}[Enter]${B_NC}..."
    read
}

# ============================================================
main_menu() {
    while true; do
        clear
        draw_header

        if check_license; then
            echo -e "  ${B_GREEN}✓ Status License : Activated${B_NC}"
            echo -e "  ${B_GREEN}  ✓ ROOT SSH : Open${B_NC}"
            echo -e "  ${B_GREEN}  ✓ SCP/SFTP : Open${B_NC}"
        else
            echo -e "  ${B_RED}✗ Status License : Deactivated${B_NC}"
            echo -e "  ${B_RED}  ✗ ROOT SSH  : Closed${B_NC}"
            echo -e "  ${B_RED}  ✗ SCP/SFTP  : Closed${B_NC}"
        fi

        echo ""
        echo -e "  ${B_CYAN}┌───────────────────────────────────────────────────────────────────┐${B_NC}"
        echo -e "  ${B_CYAN}│                          MENU AKTIVASI                              │${B_NC}"
        echo -e "  ${B_CYAN}└───────────────────────────────────────────────────────────────────┘${B_NC}"
        echo ""
        echo -e "    ${B_GREEN}[1]${B_NC}  Step 1 - Input API Key"
        echo -e "    ${B_GREEN}[2]${B_NC}  Step 2 - Aktivasi License"
        echo -e "    ${B_GREEN}[3]${B_NC}  Cek Status"
        echo ""
        echo -e "    ${B_RED}[0]${B_NC}  Keluar"
        echo ""
        echo -ne "  Pilih [0-3]: "
        read -r CHOICE

        case "$CHOICE" in
            1) while ! do_login; do :; done ;;
            2) while ! do_activate; do :; done ;;
            3) do_status ;;
            0) echo ""; exit 0 ;;
            *) echo -e "\n  ${B_RED}Pilihan tidak valid!${B_NC}"; sleep 1 ;;
        esac
    done
}

# ============================================================
if [[ $EUID -ne 0 ]]; then
    echo -e "${B_RED}Gunakan sudo!${B_NC}"
    echo -e "  sudo /usr/src/.kresek/src/activation.sh"
    exit 1
fi

main_menu