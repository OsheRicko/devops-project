# Use an official Python runtime as a parent image
FROM python:3.9-slim-buster

# Set the working directory to /app
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Install curl
RUN apt-get update && \
    apt-get install -y curl && \
    rm -rf /var/lib/apt/lists/*

# Install Visual C++ Redistributable Packages
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        build-essential \
        ca-certificates \
        cpp \
        gcc \
        libc6-dev \
        make \
        wget \
        && rm -rf /var/lib/apt/lists/*

# Install msodbcsql18 driver package
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        gnupg \
        && curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - && \
        curl https://packages.microsoft.com/config/debian/10/prod.list > /etc/apt/sources.list.d/mssql-release.list && \
        apt-get update && \
        ACCEPT_EULA=Y apt-get install -y --no-install-recommends \
        msodbcsql18 \
        && rm -rf /var/lib/apt/lists/*

# Install any needed packages specified in requirements.txt
RUN pip install --trusted-host pypi.python.org -r requirements.txt

# Install jinja2 for the flask app
RUN pip install jinja2

# Expose the port that the app will be running on
EXPOSE 5000

# Define the ARG for storageAccountKey
ARG storageAccountKey

# Define environment variables for Azure Storage and SQL Server credentials
ENV account_name=otprojectsa \
    storageAccountKey=$storageAccountKey \
    sqlusername=osher \
    sqlpassword=Password1234

# Run app.py when the container launches
CMD ["python", "webapp-v2.py"]
