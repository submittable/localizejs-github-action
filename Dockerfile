FROM python:2
COPY entrypoint.sh /entrypoint.sh
RUN pip install --ignore-installed localize
ENTRYPOINT ["/entrypoint.sh"]
