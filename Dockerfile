FROM python:3.11-slim

WORKDIR /docs

# Install mkdocs and material theme on debian-slim
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    && rm -rf /var/lib/apt/lists/*

RUN pip install --no-cache-dir mkdocs-material

COPY mkdocs.yml .
COPY docs/ docs/

EXPOSE 8000

ENTRYPOINT ["mkdocs"]
CMD ["serve", "--dev-addr", "0.0.0.0:8000"]
