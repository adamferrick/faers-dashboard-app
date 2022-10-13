FROM rocker/r-ver:4.2.1

# install system dependencies
RUN apt-get update -qq && apt-get install -y --no-install-recommends \
    wget \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    zlib1g-dev \
    libxt6

RUN install2.r --error --skipinstalled --ncpus -1 \
    tidyverse \
    plotly \
    shiny \
    shinydashboard \
    duckdb \
    pool \
    DT \
    && rm -rf /tmp/downloaded_packages \
    && strip /usr/local/lib/R/site-library/*/libs/*.so

RUN mkdir /home/faers-app
WORKDIR /home/faers-app

EXPOSE 3838

CMD ["R", "-e", "shiny::runApp('/home/faers-app/app', host = '0.0.0.0', port = 3838)"]
