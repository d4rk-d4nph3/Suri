# Suri
[![Made with](https://img.shields.io/static/v1?label=Suricata&message=5.0.3&color=orange)](https://www.suricata-ids.org)

My Suricata (v5.0.3) setup consists of using ET Open, TrafficID, AttackDetection, and Protocol Anomaly rulesets.

Tip - There is a useful *Snort* extension in VSCode for rule highlighting.

# Installation Procedure

```sh
brew install suricata    # For MacOS
apt install suricata     # For Linux
```

## Test Rules Validity

```sh
suricata -T
```

## Update Rules

```sh
sudo suricata-update 
```

## List Rules

```sh
sudo suricata-update list-sources
```

## Available Sources

```yaml
Name: et/open
  Vendor: Proofpoint
  Summary: Emerging Threats Open Ruleset
  License: MIT
Name: et/pro
  Vendor: Proofpoint
  Summary: Emerging Threats Pro Ruleset
  License: Commercial
  Replaces: et/open
  Parameters: secret-code
  Subscription: https://www.proofpoint.com/us/threat-insight/et-pro-ruleset
Name: oisf/trafficid
  Vendor: OISF
  Summary: Suricata Traffic ID ruleset
  License: MIT
Name: ptresearch/attackdetection
  Vendor: Positive Technologies
  Summary: Positive Technologies Attack Detection Team ruleset
  License: Custom
Name: scwx/enhanced
  Vendor: Secureworks
  Summary: Secureworks suricata-enhanced ruleset
  License: Commercial
  Parameters: secret-code
  Subscription: https://www.secureworks.com/contact/ (Please reference CTU Countermeasures)
Name: scwx/malware
  Vendor: Secureworks
  Summary: Secureworks suricata-malware ruleset
  License: Commercial
  Parameters: secret-code
  Subscription: https://www.secureworks.com/contact/ (Please reference CTU Countermeasures)
Name: scwx/security
  Vendor: Secureworks
  Summary: Secureworks suricata-security ruleset
  License: Commercial
  Parameters: secret-code
  Subscription: https://www.secureworks.com/contact/ (Please reference CTU Countermeasures)
Name: sslbl/ssl-fp-blacklist
  Vendor: Abuse.ch
  Summary: Abuse.ch SSL Blacklist
  License: Non-Commercial
Name: sslbl/ja3-fingerprints
  Vendor: Abuse.ch
  Summary: Abuse.ch Suricata JA3 Fingerprint Ruleset
  License: Non-Commercial
Name: etnetera/aggressive
  Vendor: Etnetera a.s.
  Summary: Etnetera aggressive IP blacklist
  License: MIT
Name: tgreen/hunting
  Vendor: tgreen
  Summary: Threat hunting rules
  License: GPLv3
```

## Enable New Rules Source

Enable OSIF's [TrafficID](https://github.com/OISF/suricata-trafficid/blob/master/rules/traffic-id.rules) and PTResearch's [AttackDetection](https://github.com/ptresearch/AttackDetection) rulesets.

```sh
sudo suricata-update enable-source osif/trafficid
sudo suricata-update enable-source ptresearch/attackdetection
sudo suricata-update   # Do not forget to update rules after activating source
```

## Protocol Anomaly Detection

Suricata is also capable of performing [protocol anomaly detection](https://redmine.openinfosecfoundation.org/projects/suricata/wiki/Protocol_Anomalies_Detection).
These anomaly detection rules are also activated.
