# Suri
My Suricata setup

# Installation Procedure

```sh
brew install suricata
apt install suricata
```

## List Rules

```sh
sudo suricata-update list-sources
```

## Update Rules

```sh
sudo suricata-update 
```

## Enable New Rules Source

```sh
sudo suricata-update enable-source osif/trafficid
sudo suricata-update enable-source ptresearch/attackdetection
sudo suricata-update   # Donot forget to update rules after activating source
```
