#!/bin/bash
# init_game.sh - Initializes the HackTheTermux folder structure

echo "Initializing HackTheTermux game environment..."

# Create folder structure
mkdir -p HackTheTermux/{levels/{level1,level2,level3,level4},assets/{banners,tools},flags,scripts,config}

# Level 1 setup
cat > HackTheTermux/levels/level1/description.txt <<EOL
Level 1: File Enumeration
Objective: Find the hidden flag in the directory.
Hint: Use Linux commands to reveal hidden files.
EOL

echo "Welcome to Level 1! Find the hidden flag." > HackTheTermux/levels/level1/readme.txt
echo "FLAG{level1_flag}" > HackTheTermux/levels/level1/.hidden_flag
chmod 600 HackTheTermux/levels/level1/.hidden_flag

# Level 2 setup
cat > HackTheTermux/levels/level2/description.txt <<EOL
Level 2: Password Cracking
Objective: Crack the password-protected file using the provided wordlist and script.
EOL

echo "This is a password-protected file." > HackTheTermux/levels/level2/encrypted.txt
zip --password secret HackTheTermux/levels/level2/encrypted.zip HackTheTermux/levels/level2/encrypted.txt
rm HackTheTermux/levels/level2/encrypted.txt

cat > HackTheTermux/levels/level2/wordlist.txt <<EOL
password
123456
secret
hackthetermux
EOL

cat > HackTheTermux/levels/level2/crack_script.py <<EOL
import zipfile

def crack_zip(zip_path, wordlist_path):
    with open(wordlist_path, 'r') as wordlist:
        for word in wordlist:
            word = word.strip()
            try:
                with zipfile.ZipFile(zip_path) as zf:
                    zf.extractall(pwd=word.encode())
                    print(f"Password found: {word}")
                    return
            except:
                continue
    print("Password not found!")

crack_zip("encrypted.zip", "wordlist.txt")
EOL

# Level 3 setup
cat > HackTheTermux/levels/level3/description.txt <<EOL
Level 3: SQL Injection
Objective: Exploit the login form to bypass authentication.
EOL

cat > HackTheTermux/levels/level3/vulnerable_app.py <<EOL
from flask import Flask, request, render_template_string

app = Flask(__name__)

users = {"admin": "admin123"}

@app.route("/", methods=["GET", "POST"])
def login():
    if request.method == "POST":
        username = request.form.get("username")
        password = request.form.get("password")
        if username in users and users[username] == password:
            return "Welcome, admin! Flag: FLAG{level3_flag}"
        else:
            return "Invalid credentials"
    return render_template_string('''
        <form method="post">
            Username: <input type="text" name="username"><br>
            Password: <input type="password" name="password"><br>
            <button type="submit">Login</button>
        </form>
    ''')

if __name__ == "__main__":
    app.run(port=5000)
EOL

# Level 4 setup
cat > HackTheTermux/levels/level4/description.txt <<EOL
Level 4: Network Scanning
Objective: Find the open port and retrieve the flag.
EOL

cat > HackTheTermux/levels/level4/server.py <<EOL
import socket

server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
server.bind(("127.0.0.1", 9999))
server.listen(1)
print("Server running on port 9999...")

while True:
    conn, addr = server.accept()
    conn.send(b"Welcome to the server! Flag: FLAG{level4_flag}\n")
    conn.close()
EOL

# Assets
echo "HackTheTermux - Welcome to the Game" > HackTheTermux/assets/banners/welcome.txt

# Flags
cat > HackTheTermux/flags/flag_template.txt <<EOL
Level 1: Not Found
Level 2: Not Found
Level 3: Not Found
Level 4: Not Found
EOL

touch HackTheTermux/flags/collected_flags.txt

# Scripts
cat > HackTheTermux/scripts/validate_flag.sh <<EOL
#!/bin/bash
# validate_flag.sh - Validates flags for each level

LEVEL=\$1
FLAG=\$2

case \$LEVEL in
    1) [ "\$FLAG" == "FLAG{level1_flag}" ] && echo "Correct! Proceed to Level 2." || echo "Wrong flag." ;;
    2) [ "\$FLAG" == "FLAG{level2_flag}" ] && echo "Correct! Proceed to Level 3." || echo "Wrong flag." ;;
    3) [ "\$FLAG" == "FLAG{level3_flag}" ] && echo "Correct! Proceed to Level 4." || echo "Wrong flag." ;;
    4) [ "\$FLAG" == "FLAG{level4_flag}" ] && echo "Congratulations! You completed the game!" || echo "Wrong flag." ;;
    *) echo "Invalid level." ;;
esac
EOL
chmod +x HackTheTermux/scripts/validate_flag.sh

echo "Initialization complete! Run the game using 'bash start_game.sh'."
