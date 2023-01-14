# pylint: disable=line-too-long

''' Sample lambda function '''
import os
import requests

ENV = os.environ['ENV']

URL = "https://raw.githubusercontent.com/konkerama/konkerama.github.io/master/contact-info/index.json"

def lambda_handler(event, context):
    ''' Lambda Handler '''
    response = requests.get(url=URL, timeout=10)
    print (ENV)
    print (response.text)
    print (event)
    print (context)
    return "env="+ENV

if __name__=="__main__":
    lambda_handler("","")
