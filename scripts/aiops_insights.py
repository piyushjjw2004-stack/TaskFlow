#!/usr/bin/env python3
"""AIOps-ready incident triage helper for TaskFlow.

It consumes Prometheus alert JSON and produces prioritized, human-reviewable
investigation suggestions. It deliberately never changes infrastructure.
"""
import argparse
import json
import urllib.request


def fetch_alerts(url: str) -> list[dict]:
    with urllib.request.urlopen(url, timeout=5) as response:
        payload = json.load(response)
    return payload.get("data", {}).get("alerts", [])


def main() -> int:
    parser = argparse.ArgumentParser(description="Show safe TaskFlow incident triage suggestions.")
    parser.add_argument(
        "--url",
        default="http://localhost:9090/api/v1/alerts",
        help="Prometheus alerts API URL",
    )
    parser.add_argument(
        "--alert",
        help="Only show an alert by name or suffix, e.g. HighErrorRate",
    )
    args = parser.parse_args()

    alerts = fetch_alerts(args.url)
    if args.alert:
        requested = args.alert.lower()
        alerts = [
            a for a in alerts
            if a.get("labels", {}).get("alertname", "").lower() == requested
            or a.get("labels", {}).get("alertname", "").lower().endswith(requested)
        ]

    if not alerts:
        print("No matching active alerts. System is within the configured alert thresholds.")
        return 0

    severity_order = {"critical": 0, "warning": 1, "info": 2}
    alerts.sort(key=lambda a: severity_order.get(a.get("labels", {}).get("severity", "info").lower(), 3))

    for alert in alerts:
        labels = alert.get("labels", {})
        name = labels.get("alertname", "UnknownAlert")
        severity = labels.get("severity", "info").upper()
        print(f"[{severity}] {name}")
        print(f"  summary: {alert.get('annotations', {}).get('summary', 'n/a')}")
        if name.endswith("BackendDown"):
            next_step = "kubectl get pods -n taskflow; kubectl describe pod -n taskflow; kubectl logs -n taskflow --previous"
        elif name.endswith("HighErrorRate"):
            next_step = "inspect 5xx logs, dependency health and recent rollout history"
        elif name.endswith("HighLatency"):
            next_step = "inspect kubectl top pods, database latency and HPA status"
        else:
            next_step = "inspect related labels, logs, events and recent deployments"
        print(f"  next: {next_step}")

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
