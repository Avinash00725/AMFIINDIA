#!/bin/bash

URL="https://www.amfiindia.com/spages/NAVAll.txt"
INPUT_FILE="NAVAll.txt"
TSV_FILE="output.tsv"
JSON_FILE="output.json"

curl -s "$URL" -o "$INPUT_FILE" #-->to download the data

awk -F ';' '
$4 != "" && $5 != "" && $4 !~ /Scheme Name/ {
    print $4, $5 >> "'"$TSV_FILE"'";
    gsub(/"/, "\\\"", $4);
    gsub(/"/, "\\\"", $5);
    print "{\"Scheme Name\":\"" $4 "\", \"Asset Value\":\"" $5 "\"}," >> "'"$JSON_FILE"'.tmp"
}' "$INPUT_FILE"


echo "[" > "$JSON_FILE"
sed '$s/,$//' "$JSON_FILE.tmp" >> "$JSON_FILE"
echo "]" >> "$JSON_FILE"
rm "$JSON_FILE.tmp" "$INPUT_FILE"

