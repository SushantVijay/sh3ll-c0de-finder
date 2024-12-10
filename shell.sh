#!/bin/bash

# URL of Exploit-DB shellcode section
BASE_URL="https://www.exploit-db.com/shellcodes"

# Function to fetch shellcode page
fetch_shellcode_page() {
    page=$1
    curl -s "$BASE_URL?page=$page" \
        -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36"
}

# Function to search for shellcode
search_shellcode() {
    search_query=$1
    echo "Searching for shellcode with query: $search_query"
    results=$(curl -s "$BASE_URL" \
        -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36" |
        grep -i "$search_query" |
        awk -F '"' '/\/exploit\/\d+/ {print "https://www.exploit-db.com"$2}')
    if [ -z "$results" ]; then
        echo "No results found for query: $search_query"
    else
        echo "Found the following results:"
        echo "$results"
    fi
}

# Function to download a shellcode by URL
download_shellcode() {
    url=$1
    echo "Downloading shellcode from: $url"
    file_name=$(echo "$url" | awk -F '/' '{print $NF}')
    curl -O "$url" -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36"
    if [ -f "$file_name" ]; then
        echo "Downloaded $file_name"
    else
        echo "Failed to download shellcode."
    fi
}

# Main menu
echo "Sh3llcode Script"
echo "1. Search for shellcode"
echo "2. Download shellcode by URL"
echo "3. Exit"

read -p "Choose an option: " option

case $option in
    1)
        read -p "Enter search query: " query
        search_shellcode "$query"
        ;;
    2)
        read -p "Enter shellcode URL: " url
        download_shellcode "$url"
        ;;
    3)
        echo "Exiting script."
        exit 0
        ;;
    *)
        echo "Invalid option."
        ;;
esac
