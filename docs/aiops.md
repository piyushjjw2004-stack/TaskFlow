# AIOps / Intelligent Operations

The capstone treats AIOps as an assisted-operations layer over real operational telemetry. The current implementation is deliberately safe: it provides deterministic incident triage and a clear interface for optional AI-assisted analysis without granting an AI agent destructive cluster access.

## Operational data path

```text
Application metrics + Kubernetes events + logs
                    |
                    v
             Prometheus alerts
                    |
                    v
          scripts/aiops_insights.py
                    |
          +---------+---------+
          |                   |
          v                   v
   symptom classification   suggested kubectl checks
          |                   |
          +---------+---------+
                    v
          human-approved action
```

## Demonstration

```bash
python scripts/aiops_insights.py --alert HighErrorRate
python scripts/aiops_insights.py --alert HighLatency
python scripts/aiops_insights.py --alert BackendDown
```

The deterministic layer is the fallback. An approved AI service can consume the same alert context to summarize symptoms, correlate related signals and propose investigation steps. It must not execute destructive infrastructure actions without human approval.
