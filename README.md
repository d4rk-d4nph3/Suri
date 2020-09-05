# Suri
[![Made with](https://img.shields.io/static/v1?label=Suricata&message=5.0.3&color=orange)](https://www.suricata-ids.org)

![image](https://user-images.githubusercontent.com/61026070/92301448-cb5f5c00-ef83-11ea-98f9-b8829ff5b3dd.png)

My Suricata setup consisting of using ET Open, TrafficID, AttackDetection, and Protocol Anomaly rulesets.

Tip - There is a useful *Snort* extension in VSCode for rule highlighting.

## Contents

- Installing and Starting Suricata
- Testing Suricata rules
- Activating Rule sets
- Generate Analytics from Suricata Logs
- Shell Script for Generating Analytics

## Installation

```sh
brew install suricata    # For MacOS
apt install suricata     # For Linux
```

## Starting Suricata

```sh
suricata -i eth0                    # Run Suricata in IDS mode in interface eth0
suricata -D -i eth0                 # Run Suricata as a daemon
suricata -r traffic.pcap            # Feed the pcap file to Suricata for offline processing
suricata --simulate-ips -i eth0     # Run Suricata in IPS mode.
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

# ** To disable rulesets, just relace *enable* by *disable* then, re-run the above steps. **
```

## Protocol Anomaly Detection

Suricata is also capable of performing [protocol anomaly detection](https://redmine.openinfosecfoundation.org/projects/suricata/wiki/Protocol_Anomalies_Detection).
These anomaly detection rules are also activated.

## Viewing Logs

To find out Suricata's default log directory,

```sh
suricata --dump-config | grep 'log-dir'
```
Note: You can change this default log directory using the '-l' switch.

By changing to that log directory, we can find many log files such as fast.log, stats.log, etc.

#### The most important ones are the **fast.log** and **eve.json**.

### fast.log

```sh
08/28/2020-23:00:20.533352  [**] [1:2002157:12] ET CHAT Skype User-Agent detected [**] [Classification: Potential Corporate Privacy Violation] [Priority: 1] {TCP} 192.168.1.106:62303 -> 113.107.4.52:80
08/29/2020-11:35:22.581441  [**] [1:2260000:1] SURICATA Applayer Mismatch protocol both directions [**] [Classification: Generic Protocol Command Decode] [Priority: 3] {TCP} 10.22.1.7:49181 -> 192.168.100.1:135
```

### eve.json

```sh
{
  "timestamp": "2020-09-02T10:22:19.494843+0545",
  "flow_id": 1830017407373997,
  "in_iface": "en0",
  "event_type": "http",
  "src_ip": "192.168.100.1",
  "src_port": 52800,
  "dest_ip": "100.12.21.89",
  "dest_port": 80,
  "proto": "TCP",
  "tx_id": 0,
  "metadata": {
    "flowbits": [
      "FB180732_0"
    ]
  },
  "http": {
    "hostname": "driveonweb.de",
    "url": "/robots.txt",
    "http_user_agent": "Mozilla/5.0 (Macintosh; Intel Win 10; rv:80.0) Gecko/20100101 Firefox/80.0",
    "http_content_type": "text/html",
    "http_method": "GET",
    "protocol": "HTTP/1.1",
    "status": 301,
    "redirect": "https://www.driveonweb.de/robots.txt",
    "length": 162
  }
}
```

As you can see, fast.log only provides information on alerts generated whereas, eve.json in addition to alerts, will also provide logs for DNS, HTTP, HTTPS, etc. 

> *Thus, by diving in on eve.json, we can paint a complete picture of the network traffic.*

## Generating Analytics

Suricata logs can be forwarded to SIEMs for analytics. However, we can create our own analytics without using SIEMs.

For this, we can use [*jq*](https://stedolan.github.io/jq/) command-line JSON parser. *jq* as described in their website as being *sed* for JSON data.

> For easy tutorial or refresher on *jq*, you can see visit this [site](https://programminghistorian.org/en/lessons/json-and-jq).

### jq Queries

GenerateAnalytics.sh script will use jq queries to generate useful analytics.

```sh
chmod +x GenerateAnalytics.sh
./GenerateAnalytics.sh
```

Top 10 Alerts

```sh
cat eve.json | jq '. | select(.event_type == "alert") | .alert.signature' | sort | uniq -c | sort -nr | head -10 | tr -d '"'
```
Top 10 DNS Queries

```sh
cat eve.json | jq '. | select(.event_type == "dns") | .dns.rrname' | sort | uniq -c | sort -nr | head -10 | tr -d '"'
```

NXDOMAIN DNS Queries

```sh
cat eve.json | jq 'select(.dns.rcode == "NXDOMAIN") | .dns.rrname' | sort | uniq -u | tr -d '"'
```

Top 10 Destination IPs

```sh
cat eve.json | jq -c 'select(.event_type=="flow") | [.dest_ip]' | sort | uniq -c | sort -nr | head -10 | tr -d '"[]'
```

Top 10 Destination Ports

```sh
cat eve.json | jq -c 'select(.event_type=="flow") | [.proto, .dest_port]' | sort | uniq -c | sort -nr | head -10 | tr -d '"[]'
```

Top 10 Source IPs

```sh
cat eve.json | jq -c 'select(.event_type=="flow") | [.proto, .src_ip]' | sort | uniq -c | sort -nr | head -10 | tr -d '"[]'
```

Top 10 User Agents

```sh
cat eve.json | jq '. | select(.event_type == "http") | .http.http_user_agent' | sort | uniq -u | sort -nr | head -10 | tr -d '"'
```

Top 10 Least Common User Agents

```sh
cat eve.json | jq '. | select(.event_type == "http") | .http.http_user_agent' | sort | uniq -u | sort -nr | tail -10 | tr -d '"'
```
