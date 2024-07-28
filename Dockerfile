FROM python:3.9

# Create a non-root user
RUN useradd -m -u 1000 user

# Set environment variables
ENV HOME=/home/user \
    VIRTUAL_ENV=/home/user/venv \
    PATH=/home/user/venv/bin:$PATH

# Switch to non-root user
USER user

# Create and activate virtual environment
RUN python -m venv $VIRTUAL_ENV

# Set working directory
WORKDIR $HOME/app

# Copy application code and requirements
COPY --chown=user . $HOME/app
COPY ./requirements.txt $HOME/app/requirements.txt
COPY .env $HOME/app/.env

# Install dependencies, including python-dotenv for .env file support
RUN pip install -r requirements.txt && pip install python-dotenv

# Copy the rest of the application code
COPY . .

# Define the default command
CMD ["chainlit", "run", "app.py", "--port", "7860"]
