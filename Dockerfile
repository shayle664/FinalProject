FROM python:3.14.0b2-alpine3.22
WORKDIR /app
COPY App/ /app/
RUN pip install --no-cache-dir -r requirements.txt
EXPOSE 5007
CMD ["python","app.`py"]