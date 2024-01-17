FROM python:2
COPY entrypoint.sh /entrypoint.sh
RUN pip install --ignore-installed localize==1.0.9
ENTRYPOINT ["/entrypoint.sh"]
