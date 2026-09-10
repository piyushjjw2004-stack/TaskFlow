# TaskFlow Reliability & SRE Practices

TaskFlow demonstrates practical SRE concepts alongside its Prometheus, Grafana and Kubernetes configuration.

## Service Level Indicators (SLIs)

- **Availability SLI:** successful API responses divided by total API responses over a measurement window.
- **Latency SLI:** percentage of API requests completed below the chosen latency threshold.
- **Error-rate SLI:** 5xx responses divided by total API responses.

The backend exposes request counters and latency histograms at `/api/metrics` for Prometheus collection.

## Example Service Level Objectives (SLOs)

These are example objectives for the capstone, not measured production commitments:

- **API availability SLO:** 99.5% per month.
- **API latency SLO:** 95% of requests complete in under 500 ms.
- **API error-rate SLO:** fewer than 1% 5xx responses.

## Error Budget

For a 99.5% availability SLO:

`Error budget = 100% - 99.5% = 0.5%`

The error budget represents the amount of unavailability that can be tolerated before reliability work should take priority over changes that increase operational risk.

## Scaling and Reliability

- Kubernetes resource requests support CPU/memory-based HPA decisions.
- Backend readiness uses `/api/ready` and checks database connectivity. `/api/ready/schema` separately verifies that the Alembic migration has completed.
- Backend liveness uses `/api/health` and does not require a database query.
- Prometheus alerts provide a starting point for operational response.

Live SLO measurements and HPA behavior require a running Kubernetes/monitoring environment and are not claimed as locally verified unless explicitly tested.


## Runtime verification
The deployed platform should derive availability, latency and error-rate SLIs from Prometheus metrics. SLOs are policy targets; Grafana should be used to compare observed values with those targets. Error-budget decisions remain human-owned.
