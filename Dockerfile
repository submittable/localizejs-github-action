FROM python:3
COPY entrypoint.sh /entrypoint.sh
RUN pip install --ignore-installed localize
RUN mkdir ~/.localize
ENTRYPOINT ["/entrypoint.sh"]
