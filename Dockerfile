FROM python:3.7.4-slim-stretch as Python

COPY requirements.txt .

# install deps
RUN apt-get update
RUN pip install -r requirements.txt

# nodejs (optional)
# RUN apt-get update && apt-get install curl -y
# RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | bash -
# RUN apt-get install nodejs npm -y
# if we need yarn
# RUN npm install yarn -g

FROM python:3.7.4-slim-stretch

COPY --from=Python /root/.cache /root/.cache
COPY --from=Python requirements.txt .

RUN apt-get update
RUN pip install -r requirements.txt 
RUN rm -rf /root/.cache 
RUN rm -rf /var/lib/apt/lists/*

RUN mkdir app
WORKDIR /app

COPY ./ /app/

CMD python manage.py runserver 0.0.0.0:8000
