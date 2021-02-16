FROM python:3

RUN pip install pandas matplotlib

COPY test.py /test.py

COPY load-test.csv /load-test.csv


