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

Enable OSIF's [TrafficID](https://github.com/OISF/suricata-trafficid/blob/master/rules/traffic-id.rules) and PTResearch's [AttackDetection](https://github.com/ptresearch/AttackDetection) rulesets.

```sh
sudo suricata-update enable-source osif/trafficid
sudo suricata-update enable-source ptresearch/attackdetection
sudo suricata-update   # Do not forget to update rules after activating source
```
