# Use the official Python image as the base image
FROM python:3.9-slim

# Set the working directory
WORKDIR /app

# Copy the Python script and requirements.txt into the working directory
COPY publisher.py /app/
COPY requirements.txt /app/

# Install required packages
RUN pip install --trusted-host pypi.python.org -r requirements.txt

# Start the application
CMD ["python", "publisher.py"]
