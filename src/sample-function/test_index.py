'''Python Tests'''
import index
import os

ENV = os.environ['ENV']

def test_lambda_handler():
    '''Verify the output of lambda_handler function'''
    output = index.lambda_handler("","")
    assert output == "env="+ENV
