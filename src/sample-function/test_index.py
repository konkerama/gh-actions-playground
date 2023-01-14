import index

def test_lambda_handler():
    '''Verify the output of lambda_handler function'''
    output = index.lambda_handler("","")
    assert output == "Hello World"
