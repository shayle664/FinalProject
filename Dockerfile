FROM python:3.12-alpine3.20

WORKDIR /app

COPY App/requirements.txt /app/requirements.txt

RUN pip install --no-cache-dir -r requirements.txt

COPY App/ /app/

EXPOSE 5007
CMD ["python","app.py"]
