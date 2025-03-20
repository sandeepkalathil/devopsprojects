#!/bin/bash
set -eux  # Enable debugging and exit on error

# Update the system
sudo apt update -y && sudo apt upgrade -y

# Install Apache
sudo apt install -y apache2

# Start and enable Apache service
sudo systemctl start apache2
sudo systemctl enable apache2

# Ensure permissions for Apache
sudo chmod -R 755 /var/www/html

# Create an HTML page with colorful LED effect
sudo tee /var/www/html/index.html > /dev/null <<EOT
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Welcome to My Website</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: Arial, sans-serif;
        }
        body {
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            height: 100vh;
            background: linear-gradient(135deg, #ff9a9e, #fad0c4);
            text-align: center;
        }
        h1 {
            font-size: 3rem;
            color: white;
            text-shadow: 2px 2px 10px rgba(0, 0, 0, 0.2);
            animation: fadeIn 2s ease-in-out;
        }
        footer {
            position: absolute;
            bottom: 20px;
            font-size: 1rem;
            color: white;
            opacity: 0.8;
        }
        @keyframes fadeIn {
            0% { opacity: 0; transform: translateY(-20px); }
            100% { opacity: 1; transform: translateY(0); }
        }
    </style>
</head>
<body>
    <h1>Welcome to My Website</h1>
    <footer>
        Copyright &copy; Sandeep
    </footer>
</body>
</html>

EOT

# Change ownership and permissions of the file
sudo chown www-data:www-data /var/www/html/index.html
sudo chmod 644 /var/www/html/index.html

# Restart Apache to apply changes
sudo systemctl restart apache2
