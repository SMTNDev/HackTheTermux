#!/bin/bash
# start_game.sh - Main script to play HackTheTermux

echo "Welcome to HackTheTermux!"
cat assets/banners/welcome.txt

while true; do
    echo "Select a level to play:"
    echo "1. Level 1: File Enumeration"
    echo "2. Level 2: Password Cracking"
    echo "3. Level 3: SQL Injection"
    echo "4. Level 4: Network Scanning"
    echo "5. Exit"
    read -p "Enter your choice: " choice

    case $choice in
        1) echo "Starting Level 1..."; cat levels/level1/description.txt ;;
        2) echo "Starting Level 2..."; cat levels/level2/description.txt ;;
        3) echo "Starting Level 3..."; python3 levels/level3/vulnerable_app.py ;;
        4) echo "Starting Level 4..."; python3 levels/level4/server.py ;;
        5) echo "Exiting game. Goodbye!"; break ;;
        *) echo "Invalid choice. Try again." ;;
    esac
done
