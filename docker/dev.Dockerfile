FROM python:3.10-slim

WORKDIR /app

# Install dependencies
RUN apt-get update && apt-get install -y gcc g++ curl build-essential postgresql-server-dev-all mysql-client

# Install Poetry
RUN curl -sSL https://install.python-poetry.org | python3 -

# Add Poetry to PATH
ENV PATH="${PATH}:/root/.local/bin"

# Copy the pyproject.toml and poetry.lock files
COPY poetry.lock pyproject.toml ./

# Install dependencies
RUN poetry config virtualenvs.create false && poetry install --no-interaction --no-ansi

# Copy the rest of the application code
COPY . .

# Install MySQL connector for Python
RUN pip install mysql-connector-python

# Ensure static files directory exists
RUN mkdir -p /app/static

# Command to run the application
CMD ["uvicorn", "--factory", "langflow.main:create_app", "--host", "0.0.0.0", "--port", "7860", "--reload", "--log-level", "debug", "--loop", "asyncio"]
