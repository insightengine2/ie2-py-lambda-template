FROM public.ecr.aws/lambda/python:3.12

ENV IE2-ENV="DEV"

COPY . .

RUN pip install -r requirements.txt

CMD ["lambda_function.handler"]
