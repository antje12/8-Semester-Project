FROM python:3.9-slim

WORKDIR /app

COPY mqtt_thingspeak.py /app/
COPY requirements.txt /app/

RUN pip install --trusted-host pypi.python.org -r requirements.txt

CMD ["python", "-u", "mqtt_thingspeak.py"]
