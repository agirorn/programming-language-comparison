FROM python:3.10.14

WORKDIR /code

COPY ./requirements.txt /code/requirements.txt

RUN pip install --no-cache-dir --upgrade -r /code/requirements.txt

COPY ./app /code/app
WORKDIR /code/app

# CMD ["fastapi", "run", "app/main.py", "--port", "8080"]
# CMD uvicorn main:app --port 8080 --host 0.0.0.0 --lifespan=on
CMD uvicorn main:app --port 8080 --host 0.0.0.0
