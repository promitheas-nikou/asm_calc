import base64

with open('./app', 'rb') as file:
    encoded_string = base64.b64encode(file.read()).decode('utf-8')

with open('./appb64', 'w') as output:
    output.write(encoded_string)

