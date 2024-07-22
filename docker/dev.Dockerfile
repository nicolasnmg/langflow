WORKDIR /app

# Install Poetry and MySQL connector dependencies
RUN apt-get update && apt-get install -y gcc g++ curl build-essential postgresql-server-dev-all mysql-client

# Install Poetry
	@@ -14,14 +14,17 @@ ENV PATH="${PATH}:/root/.local/bin"
# Copy the pyproject.toml and poetry.lock files
COPY poetry.lock pyproject.toml ./

# Copy the rest of the application code
COPY ./ ./

# Install dependencies
RUN poetry config virtualenvs.create false && poetry install --no-interaction --no-ansi

# Install MySQL connector for Python
RUN pip install mysql-connector-python

# Command to run the application
CMD ["uvicorn", "--factory", "langflow.main:create_app", "--host", "0.0.0.0", "--port", "7860", "--reload", "--log-level", "debug", "--loop", "asyncio"]
