#!/usr/bin/env python3
import base64
import cv2
import numpy as np
from pyzbar.pyzbar import decode

# Load the image containing the QR code
image_path = 'qr_autogen.png'

# Read the image using OpenCV
image = cv2.imread(image_path)

# Decode the QR code using pyzbar
qr_codes = decode(image)

# Iterate over detected QR codes
for qr_code in qr_codes:
    # Extract the data from the QR code
    qr_data = qr_code.data.decode('utf-8')
    print("Decoded QR Code Data: ", qr_data)
    with open('app_loaded','wb') as f:
        f.write(base64.b64decode(qr_data))
    break


