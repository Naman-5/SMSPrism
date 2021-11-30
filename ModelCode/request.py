import requests
import json
url = 'http://127.0.0.1:5000/predict'
# myobj = {'key': 'Rs.2193.40 spent on POS/Ecom using ICICI Debit card on 26/10/21 18:05 at PAYTM                  NOIDA   from Ac:XXXXXXXXX. Bal:XXXXX CR -ICICI Bank'}

payload = {'key': 'OTP for Aadhaar (XX9694) is 777487 (valid for 10 mins). Lock/Unlock your biometrics by sending SMS to 1947.For more details visit uidai.gov.in'}
headers = {'content-type': 'application/json'}

response = requests.post(url, json=payload)
print(response.text)