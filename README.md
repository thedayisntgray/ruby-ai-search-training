
```markdown
# AI Search Training Project

This repository contains Jupyter notebooks and data for AI search training.

## Setup & Running

### Prerequisites
- Docker and Docker Compose installed on your machine
- Git (to clone this repository)

### Running the Container

1. Clone the repository:
```bash
git clone [your-repository-url]
cd [repository-name]
```

2. Start the container:
```bash
docker-compose up -d
```

### Accessing Jupyter Notebook

1. Get the Jupyter access token by running:
```bash
docker-compose logs jupyter
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
# Start the container
docker-compose up -d

# Stop the container
docker-compose down

# View logs
docker-compose logs jupyter

# Restart the container
docker-compose restart
```

### Troubleshooting

If you can't access Jupyter:
1. Ensure the container is running:
```bash
docker-compose ps
```

2. Check container logs:
```bash
docker-compose logs jupyter
```

3. Verify port 8888 is available:
```bash
lsof -i :8888
```

## Adding Content

- Place notebooks in the `notebooks/` directory
- Place data files in the `data/` directory
- Files will automatically sync with the container
```

Would you like me to add any additional sections or information to this README?