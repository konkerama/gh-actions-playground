''' Using flask to make an api '''
# import necessary libraries and functions
import json
import logging
from flask import Flask, jsonify, request
import helper
import boto3
from sys import stdout

logging.basicConfig(level=logging.INFO, format="[%(asctime)s] %(name)-12s %(levelname)-8s %(filename)s:%(funcName)s %(message)s")

logFormatter = logging.Formatter("[%(asctime)s] %(name)-12s %(levelname)-8s %(filename)s:%(funcName)s %(message)s")


logger = logging.getLogger('werkzeug')
logger.setLevel(logging.INFO)
consoleHandler = logging.StreamHandler(stdout) #set streamhandler to stdout
consoleHandler.setFormatter(logFormatter)
logger.addHandler(consoleHandler)

# client = boto3.client('ssm', region_name="eu-west-1", 
#     aws_access_key_id=os.environ['aws_access_key_id'],
#     aws_secret_access_key=os.environ['aws_secret_access_key'])

client = boto3.client('ssm', region_name="eu-west-1")
client_lambda = boto3.client('lambda', region_name="eu-west-1")
config = helper.read_config()

def get_lambda_response():
    if config['Lambda']['type'] == "mock":
        return "mock response from lambda"

    logger.info("Getting SSM Parameter Value: %s",{config['Lambda']['ssm-param-name']})
    ssm_param = client.get_parameter(Name=config['Lambda']['ssm-param-name'])
    lambda_name=ssm_param['Parameter']['Value']
    logger.info ("Invoking Lambda: %s",{lambda_name})
    response = client_lambda.invoke(FunctionName=lambda_name)
    payload = json.loads(response['Payload'].read().decode("utf-8"))
    return payload

# creating a Flask app
app = Flask(__name__)

# on the terminal type: curl http://127.0.0.1:5000/
# returns hello world when we use GET.
# returns the data that we send when we use POST.
@app.route('/', methods = ['GET', 'POST'])
def home():
    if(request.method == 'GET'):
        logger.info('sample log')
        response = get_lambda_response()
        data = f"hello github actions from {config['General']['stage']}"
        return jsonify({'data': data,'lambda-response': response})
    return jsonify({'request': 'POST'})

# A simple function to calculate the square of a number
# the number to be squared is sent in the URL when we use GET
# on the terminal type: curl http://127.0.0.1:5000 / home / 10
# this returns 100 (square of 10)
@app.route('/home/<int:num>', methods = ['GET'])
def disp(num):
    return jsonify({'data': num**2})

@app.route('/health', methods = ['GET'])
def health():
    return jsonify({'status': 'healthy'})


# driver function
if __name__ == '__main__':
    app.run(debug = True,  host="0.0.0.0", port = config['General']['port'])