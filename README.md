# Running the Dashboard
## Cloning the repository
Clone this GitHub repository and navigate to the project folder using the following commands in the terminal:

```bash
git clone https://github.com/Roccolee18/practice-r-shiny-dashboard.git
cd practice-r-shiny-dashboard
```

## Installing dependancies
Install the required R packages using the following command in the terminal:

```bash
Rscript requirements.R
```

## Running the dashboard
Run the dashboard locally with this command in the terminal:

```bash
Rscript -e "shiny::runApp('src/app.R', launch.browser=TRUE)"
```