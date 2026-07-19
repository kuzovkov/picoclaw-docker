FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

ARG user
ARG user_id
ARG group_id

# -----------------------------------------------------------------------------
# Base packages
# -----------------------------------------------------------------------------

RUN apt-get update && \
    apt-get install -y \
        sudo \
        wget \
        curl \
        gnupg2 \
        ca-certificates \
        software-properties-common \
        locales \
        tzdata \
        dbus \
        dbus-x11 \
        x11-xserver-utils \
        xauth \
        mesa-utils \
        mesa-vulkan-drivers \
        libgbm1 \
        libasound2 \
        libatk-bridge2.0-0 \
        libatk1.0-0 \
        libcups2 \
        libdrm2 \
        libgtk-3-0 \
        libnspr4 \
        libnss3 \
        libx11-xcb1 \
        libxcomposite1 \
        libxdamage1 \
        libxfixes3 \
        libxkbcommon0 \
        libxrandr2 \
        libxshmfence1 \
        libxss1 \
        libxtst6 \
        fonts-dejavu \
        fonts-liberation \
        fonts-noto \
        fonts-noto-cjk \
        fonts-noto-color-emoji \
        fonts-freefont-ttf \
        xserver-xorg-core \
        xserver-xorg-video-dummy \
    && rm -rf /var/lib/apt/lists/*

# -----------------------------------------------------------------------------
# Locale
# -----------------------------------------------------------------------------
# Install the locales package
RUN apt-get update && apt-get install -y locales

# Uncomment or generate the Russian locale
RUN sed -i '-e s/# ru_RU.UTF-8 UTF-8/ru_RU.UTF-8 UTF-8/' /etc/locale.gen && locale-gen

# Set environment variables for the system
ENV LANG=ru_RU.UTF-8
ENV LANGUAGE=ru_RU:ru
ENV LC_ALL=ru_RU.UTF-8


# -----------------------------------------------------------------------------
# Google Chrome Stable
# -----------------------------------------------------------------------------

RUN wget -qO- https://dl.google.com/linux/linux_signing_key.pub | \
    gpg --dearmor > /usr/share/keyrings/google.gpg && \
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/google.gpg] http://dl.google.com/linux/chrome/deb/ stable main" \
        > /etc/apt/sources.list.d/google.list && \
    apt-get update && \
    apt-get install -y google-chrome-stable && \
    rm -rf /var/lib/apt/lists/*

RUN apt-get update && \
    apt-get install -y socat && \
    rm -rf /var/lib/apt/lists/*

# -----------------------------------------------------------------------------
# User
# -----------------------------------------------------------------------------

RUN groupadd --gid ${group_id} ${user} && \
    useradd \
        --uid ${user_id} \
        --gid ${group_id} \
        --create-home \
        ${user} && \
    apt-get update && \
    apt-get install -y sudo && \
    echo "${user} ALL=(ALL) NOPASSWD:ALL" >/etc/sudoers.d/${user} && \
    chmod 0440 /etc/sudoers.d/${user}

USER ${user}

WORKDIR /home/${user}

RUN mkdir -p \
        /home/${user}/chrome-profile \
        /home/${user}/Downloads \
        /home/${user}/.config

ENV DISPLAY=:99

EXPOSE 9222

COPY --chown=${user}:${user} xorg.conf /etc/X11/xorg.conf
COPY --chown=${user}:${user} start.sh /usr/local/bin/start.sh

RUN chmod +x /usr/local/bin/start.sh

CMD ["/usr/local/bin/start.sh"]