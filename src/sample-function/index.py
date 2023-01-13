import requests

def lambda_handler(event, context):
    response = requests.get("https://raw.githubusercontent.com/konkerama/konkerama.github.io/master/contact-info/index.json")
    print (response.text)
    return "Hello World"

if __name__=="__main__":
    lambda_handler("","")
