FROM httpd:2.4.23
    
RUN apt-get update -y && \
    apt-get install -y curl && \
    apt-get autoremove --purge -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*