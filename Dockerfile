FROM python:3.7-alpine
WORKDIR /app

COPY requirements.txt requirements.txt
RUN pip install -r requirements.txt

COPY . .

RUN python init_db.py
CMD [ "python", "app.py" ]

