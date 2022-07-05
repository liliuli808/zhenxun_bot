FROM python:3.9

ENV TZ=Asia/Shanghai
ENV LANG zh_CN.UTF-8
ENV LANGUAGE zh_CN.UTF-8
ENV LC_ALL zh_CN.UTF-8
ENV TZ Asia/Shanghai
ENV DEBIAN_FRONTEND noninteractive

RUN apt update && apt install -y libzbar0 locales locales-all fonts-noto

RUN apt-get install -y libnss3-dev libxss1 libasound2 libxrandr2\
  libatk1.0-0 libgtk-3-0 libgbm-dev libxshmfence1

# RUN python3 -m pip config set global.index-url https://mirrors.aliyun.com/pypi/simple \
#   && pip install poetry \
#   && poetry config virtualenvs.create false

RUN pip install poetry \
  && poetry config virtualenvs.create false

COPY  pyproject.toml /
COPY  poetry.lock /

RUN poetry lock --no-update && poetry export --without-hashes -f requirements.txt \
  | poetry run pip install -r /dev/stdin

RUN playwright install chromium && playwright install-deps


WORKDIR /nonebot

CMD ["python3", "bot.py"]