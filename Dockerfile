# syntax=docker/dockerfile:1
FROM python:3
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
EXPOSE 8000/tcp
WORKDIR /code
COPY / /code/
RUN pip install -r requirements.txt
ENTRYPOINT ./entry_point.sh
