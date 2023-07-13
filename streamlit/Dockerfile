FROM python:3.9-slim-buster

WORKDIR /app

COPY ./streamlit/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY ./streamlit .

EXPOSE 8501

CMD ["streamlit", "run", "--server.port", "8501", "app.py"]
