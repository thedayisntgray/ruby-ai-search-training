Yes, you can install gems through a Docker Compose file. Here's how you can modify your docker-compose.yml to install the transformers-rb gem:

```yaml
version: '3'
services:
  notebook:
    image: jupyter/datascience-notebook  # or whatever base image you're using
    build:
      context: .
      dockerfile: Dockerfile
    ports:
      - "8888:8888"
    volumes:
      - .:/home/jovyan/work
```

And create a Dockerfile in the same directory:

```dockerfile
FROM jupyter/datascience-notebook

USER root

# Install system dependencies
RUN apt-get update && \
    apt-get install -y build-essential ruby-dev

# Install the gem
RUN gem install transformers-rb

# Switch back to notebook user
USER ${NB_UID}
```

Then you can rebuild and run your container:

```bash
docker-compose down
docker-compose build --no-cache
docker-compose up
```

If you're using a different base image or have specific requirements, let me know and I can adjust the configuration accordingly. Also, if you're getting any specific errors during the build process, please share them.