#!/usr/bin/env python3
import base64

with open('./app', 'rb') as file:
    encoded_string = base64.b64encode(file.read()).decode('utf-8')

with open('./appb64', 'w') as output:
    output.write(encoded_string)
import qrcode

qr = qrcode.QRCode(
    version=40,  # Maximum version (1-40)
    error_correction=qrcode.constants.ERROR_CORRECT_L,  # Lowest error correction for max data storage
    box_size=10,
    border=4,
)

qr.add_data(encoded_string)
qr.make(fit=False)  # Disable automatic compression/adjustment

# Generate and save QR code
img = qr.make_image(fill="black", back_color="white")
img.save("qr_autogen.png")
