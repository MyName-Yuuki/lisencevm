#!/bin/bash
# ============================================================
# Kresek License Activation System
# ============================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../config/config.cfg"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

HWID=$(cat /sys/class/dmi/id/product_uuid 2>/dev/null | tr '[:lower:]' '[:upper:]')
IP=$(hostname -I | awk '{print $1}')

API_ACTIVATE_URL=$(eval echo "$API_ACTIVATE")

# ============================================================
draw_header() {
    echo -e "${CYAN}${BOLD}"
    echo -e "��+  ��+ �����+ ���+   ��+��������+ ������+ ���+   ��+ ������+ "
    echo -e "��� ��++��+--��+����+  ���+--��+--+��+---��+����+  �����+----+ "
    echo -e "�����++ ����������+��+ ���   ���   ���   �����+��+ ������  ���+"
    echo -e "��+-��+ ��+--������+��+���   ���   ���   ������+��+������   ���"
    echo -e "���  ��+���  ������ +�����   ���   +������++��� +�����+������++"
    echo -e "+-+  +-++-+  +-++-+  +---+   +-+    +-----+ +-+  +---+ +-----+ "
    echo -e ""
    echo -e "��+  ��+������+ �������+�������+�������+��+  ��+"
    echo -e "��� ��++��+--��+��+----+��+----+��+----+��� ��++"
    echo -e "�����++ ������++�����+  �������+�����+  �����++ "
    echo -e "��+-��+ ��+--��+��+--+  +----�����+--+  ��+-��+ "
    echo -e "���  ��+���  ����������+���������������+���  ��+"
    echo -e "+-+  +-++-+  +-++------++------++------++-+  +-+"
    echo -e ""
    echo -e "${NC}VM Activation System � Kantong Activation${CYAN}"
    echo -e "${NC}"
}
# ============================================================
banner() {
    clear
    draw_header
}

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
    echo -e "  ${GREEN}  ✓ ROOT SSH   : Open${NC}"
    echo -e "  ${GREEN}  ✓ SCP        : Open{NC}"
    echo -e "  ${GREEN}  ✓ SFTP       : Open${NC}"
}

# ============================================================
do_login() {
    banner
    echo -e "${CYAN}┌───────────────────────────────────────────────────────────────────┐${NC}"
    echo -e "${CYAN}│                     STEP 1 : INPUT API KEY                             │${NC}"
    echo -e "${CYAN}└───────────────────────────────────────────────────────────────────┘${NC}"
    echo ""
    echo -e "  ${YELLOW}  Dapatkan API Key di ${NC}"
    echo -e "  ${CYAN}    https://kresek.my.id${NC}"
    echo ""
    echo -ne "  Masukkan ${GREEN}API Key${NC}: "
    read -r API_KEY

    if [[ -z "$API_KEY" ]]; then
        echo -e "\n  ${RED}✗ API Key tidak boleh kosong!${NC}"
        sleep 2
        return 1
    fi

    echo "$API_KEY" > "$SCRIPT_DIR/../config/.api_key"
    chmod 600 "$SCRIPT_DIR/../config/.api_key"

    echo ""
    echo -e "  ${GREEN}✓ API Key disimpan!${NC}"
    echo -e "  ${GREEN}  Lanjut ke Step 2.${NC}"
    sleep 2
    return 0
}

# ============================================================
do_activate() {
    banner
    echo -e "${CYAN}┌───────────────────────────────────────────────────────────────────┐${NC}"
    echo -e "${CYAN}│                     STEP 2 : AKTIVASI LICENSE                         │${NC}"
    echo -e "${CYAN}└───────────────────────────────────────────────────────────────────┘${NC}"
    echo ""

    API_KEY_FILE="$SCRIPT_DIR/../config/.api_key"
    if [[ ! -f "$API_KEY_FILE" ]]; then
        echo -e "  ${RED}✗ Jalankan STEP 1 terlebih dahulu!${NC}"
        echo ""
        echo -ne "  Tekan ${GREEN}[Enter]${NC}..."
        read
        return 1
    fi

    API_KEY=$(cat "$API_KEY_FILE")

    echo -e "  ${CYAN}  ► IP Address  : ${YELLOW}${IP}${NC}"
    echo -e "  ${CYAN}  ► HWID        : ${YELLOW}${HWID}${NC}"
    echo -e "  ${CYAN}  ► Version     : ${YELLOW}${VER}${NC}"
    echo ""

    echo -ne "  Masukkan ${GREEN}Activation Code${NC}: "
    read -r ACTIVATION_CODE

    if [[ -z "$ACTIVATION_CODE" ]]; then
        echo -e "\n  ${RED}✗ Activation Code tidak boleh kosong!${NC}"
        sleep 2
        return 1
    fi

    echo ""
    echo -e "  ${YELLOW}⟳ Menghubungi server...${NC}"

    RESPONSE=$(curl -s -k -X POST "$API_ACTIVATE_URL" \
        -H "Content-Type: application/json" \
        -H "X-API-Key: $API_KEY" \
        -d "{
            \"activation_code\": \"$ACTIVATION_CODE\",
            \"ver\": \"$VER\",
            \"hwid\": \"$HWID\"
        }" 2>&1)

    echo ""
    echo -e "  ${CYAN}Server Response:${NC}"
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
        echo -e "${GREEN}  ┌───────────────────────────────────────────────────────────────────┐${NC}"
        echo -e "${GREEN}  │                    ✓ AKTIVASI BERHASIL!                             │${NC}"
        echo -e "${GREEN}  └───────────────────────────────────────────────────────────────────┘${NC}"
        echo ""
        echo -e "  ${GREEN}  ✓ Token disimpan: $LICENSE_FILE${NC}"
        echo ""
        echo -ne "  Tekan ${GREEN}[Enter]${NC}..."
        read
        return 0
    else
        echo ""
        echo -e "${RED}  ┌───────────────────────────────────────────────────────────────────┐${NC}"
        echo -e "${RED}  │                    ✗ AKTIVASI GAGAL!                              │${NC}"
        echo -e "${RED}  └───────────────────────────────────────────────────────────────────┘${NC}"
        echo ""
        echo -e "  ${RED}  Error: $ERROR${NC}"
        echo ""
        echo -ne "  Tekan ${GREEN}[Enter]${NC}..."
        read
        return 1
    fi
}

# ============================================================
do_status() {
    banner
    echo -e "${CYAN}┌───────────────────────────────────────────────────────────────────┐${NC}"
    echo -e "${CYAN}│                        STATUS LICENSE                               │${NC}"
    echo -e "${CYAN}└───────────────────────────────────────────────────────────────────┘${NC}"
    echo ""

    if check_license; then
        echo -e "  ${GREEN}✓ Status      : Activated${NC}"
        echo -e "  ${GREEN}✓ ROOT SSH   : Open{NC}"
        echo -e "  ${GREEN}✓ SCP        : Open${NC}"
        echo -e "  ${GREEN}✓ SFTP       : Open${NC}"
    else
        echo -e "  ${RED}✗ Status      : Deactivated${NC}"
        echo -e "  ${RED}✗ ROOT SSH   : Close${NC}"
        echo -e "  ${RED}✗ SCP        : Close${NC}"
        echo -e "  ${RED}✗ SFTP       : Close${NC}"
    fi

    echo ""
    echo -e "  ${CYAN}  ► IP Address : ${IP}${NC}"
    echo -e "  ${CYAN}  ► HWID       : ${HWID}${NC}"
    echo -e "  ${CYAN}  ► Version    : ${VER}${NC}"
    echo ""
    echo -ne "  Tekan ${GREEN}[Enter]${NC}..."
    read
}

# ============================================================
main_menu() {
    while true; do
        banner

        if check_license; then
            echo -e "  ${GREEN}✓ Status License : Activated${NC}"
            echo -e "  ${GREEN}  ✓ ROOT SSH : Open${NC}"
            echo -e "  ${GREEN}  ✓ SCP/SFTP : Open${NC}"
        else
            echo -e "  ${RED}✗ Status License : Deactivated${NC}"
            echo -e "  ${RED}  ✗ ROOT SSH  : Closed${NC}"
            echo -e "  ${RED}  ✗ SCP/SFTP  : Closed${NC}"
        fi

        echo ""
        echo -e "  ${CYAN}┌───────────────────────────────────────────────────────────────────┐${NC}"
        echo -e "  ${CYAN}│                          MENU AKTIVASI                              │${NC}"
        echo -e "  ${CYAN}└───────────────────────────────────────────────────────────────────┘${NC}"
        echo ""
        echo -e "    ${GREEN}[1]${NC}  Step 1 - Input API Key"
        echo -e "    ${GREEN}[2]${NC}  Step 2 - Aktivasi License"
        echo -e "    ${GREEN}[3]${NC}  Cek Status"
        echo ""
        echo -e "    ${RED}[0]${NC}  Keluar"
        echo ""
        echo -ne "  Pilih [0-3]: "
        read -r CHOICE

        case "$CHOICE" in
            1) while ! do_login; do :; done ;;
            2) while ! do_activate; do :; done ;;
            3) do_status ;;
            0) echo ""; exit 0 ;;
            *) echo -e "\n  ${RED}Pilihan tidak valid!${NC}"; sleep 1 ;;
        esac
    done
}

# ============================================================
if [[ $EUID -ne 0 ]]; then
    echo -e "${RED}Gunakan sudo!${NC}"
    echo -e "  sudo /usr/src/.kresek/src/activation.sh"
    exit 1
fi

main_menu
