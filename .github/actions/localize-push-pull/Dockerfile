FROM python:2
COPY entrypoint.sh /entrypoint.sh
RUN curl -L -o /usr/bin/jq https://github.com/jqlang/jq/releases/download/jq-1.7.1/jq-linux-amd64 && chmod +x /usr/bin/jq
RUN pip install --ignore-installed localize==1.0.9
ENTRYPOINT ["/entrypoint.sh"]
