#!/bin/bash

view_cert_chain() {
    local count=0
    local cert=""
    while IFS= read -r line || [ -n "$line" ]; do
        if [[ "$line" == "-----BEGIN CERTIFICATE-----" ]]; then
            count=$((count + 1))
            echo -e "\n==== Certificate $count ===="
            cert="$line"$'\n'
        elif [[ "$line" == "-----END CERTIFICATE-----" ]]; then
            cert+="$line"$'\n'

            echo "$cert" | openssl x509 -text -noout
            
            echo "==== End of Certificate $count ===="
            cert=""
        elif [ -n "$cert" ]; then
            cert+="$line"$'\n'
        fi
    done

    echo -e "\nTotal certificates in chain: $count"
}

if [ -t 0 ]; then
    # No input piped, check for file argument
    if [ $# -eq 0 ]; then
        echo "Usage: $0 <certificate_chain_file>"
        echo "       or pipe certificate chain to stdin"
        exit 1
    fi
    view_cert_chain < "$1"
else
    # Input is piped
    view_cert_chain
fi
