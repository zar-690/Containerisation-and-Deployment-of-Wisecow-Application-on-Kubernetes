FROM python:3.9-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY . /app
RUN pip install --no-cache-dir -r requirements.txt
EXPOSE 8000
ENV NAME Wisecow
CMD ["python", "app.py"]