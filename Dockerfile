FROM python:3.7.10-slim-stretch as Python

COPY requirements.txt .

# install deps
RUN apt-get update
RUN pip install -r requirements.txt

#theme
RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - && apt-get install -y nodejs

FROM python:3.7.10-slim-stretch

COPY --from=Python /root/.cache /root/.cache
COPY --from=Python requirements.txt .

RUN apt-get update
RUN pip install -r requirements.txt 
RUN rm -rf /root/.cache 
RUN rm -rf /var/lib/apt/lists/*

RUN mkdir app
WORKDIR app

COPY ./ /app/

CMD python manage.py runserver 0.0.0.0:8000
