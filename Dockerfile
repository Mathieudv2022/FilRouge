FROM python:3.10.4-bullseye
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
EXPOSE 8000/tcp
WORKDIR /code
COPY / /code/
RUN pip install -r requirements.txt
ENTRYPOINT ./entry_point.sh