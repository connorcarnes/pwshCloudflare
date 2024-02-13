FROM mcr.microsoft.com/devcontainers/base:ubuntu
# https://learn.microsoft.com/en-us/powershell/scripting/install/install-ubuntu?view=powershell-7.4
COPY bootstrap.ps1 bootstrap.ps1
RUN apt-get update \
    && apt-get install -y wget apt-transport-https software-properties-common \
    && wget -q https://packages.microsoft.com/config/ubuntu/22.04/packages-microsoft-prod.deb \
    && dpkg -i packages-microsoft-prod.deb \
    && rm packages-microsoft-prod.deb \
    && apt-get update \
    && apt-get install -y powershell \
    && pwsh -File bootstrap.ps1
COPY profile.ps1 /opt/microsoft/powershell/7/profile.ps1