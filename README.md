# Ruby AI Training - Exercises for the Course

This repository contains IRuby Jupyter notebooks and data for AI search training.

## Setup & Running

### Prerequisites
- Docker Desktop installed on your machine
- At least 4vCPUs, 6GB RAM, and 50GB disk allocated to Docker
- Git (to clone this repository)

### Running the Container

1. Clone the repository:
```bash
git clone https://github.com/thedayisntgray/ruby-ai-search-training
cd https://github.com/thedayisntgray/ruby-ai-search-training
```

2. Start the container:
```bash
docker compose up
```

### Accessing Jupyter Notebook

1. Get the Jupyter access token by running:
```bash
docker compose logs jupyter
```

2. Look for a line that looks like:
```
http://127.0.0.1:8888/lab?token=<your_token_here>
```

3. Open your browser and go to:
   - http://localhost:8888
   - Enter the token from the logs when prompted

### Project Structure
```
.
├── docker-compose.yml
├── notebooks/          # Jupyter notebooks
└── data/              # Data files
```

### Common Commands

```bash
# Start the containers while logging to the terminal
docker compose up

# Start the containers in daemon mode (everything will run in the background)
docker compose up -d

# Stop the container
docker compose down

# View logs
docker compose logs jupyter

# Restart the containers
docker compose restart

# Rebuild the containers
docker compose build
```

### Troubleshooting

If you can't access Jupyter:
1. Ensure the container is running:
```bash
docker compose ps
```

2. Check container logs:
```bash
docker compose logs jupyter
```

3. Verify port 8888 is available:
```bash
lsof -i :8888
```

## Adding Content

- Place notebooks in the `notebooks/` directory
- Place data files in the `data/` directory
- Files will automatically sync with the container
