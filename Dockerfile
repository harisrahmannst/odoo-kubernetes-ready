FROM odoo:19
USER root

# Salin dan install dependencies sekaligus
COPY requirements.txt ./
RUN apt-get update && \
    apt-get install -y python3-venv && \
    python3 -m venv /opt/venv && \
    . /opt/venv/bin/activate && \
    pip install --upgrade pip && \
    pip install -r requirements.txt && \
    apt-get --no-install-recommends install -y libreoffice && \
    apt-get clean && \
    rm -rf /root/.cache/pip && \
    rm -rf /var/lib/apt/lists/*


USER odoo

# Set direktori kerja untuk enterprise-addons
WORKDIR /mnt/enterprise-addons
COPY enterprise-addons/ ./

# Set direktori kerja untuk extra-addons
WORKDIR /mnt/extra-addons
COPY extra-addons/ ./

# Salin konfigurasi Odoo
COPY odoo.conf /etc/odoo