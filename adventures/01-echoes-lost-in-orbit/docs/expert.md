# 🔴 Expert: Hyperspace Operations & Transport

After fixing the Zephyrian communications, word of your progressive release mastery spread across the galaxy. The **Bytari**, a highly advanced species from the Andromeda sector, were impressed. 🌟

They want to apply progressive delivery to their mission-critical service: **HotROD** (Hyperspace Operations & Transport - Rapid Orbital Dispatch), an interstellar ride-sharing service handling dispatch requests across thousands of star systems. Every millisecond of latency matters, and any error could strand travelers between dimensions.

Here's the catch: a previous engineer started instrumenting HotROD with OpenTelemetry and configured Argo Rollouts for automated validation, but left the setup incomplete. The observability pipeline is broken.

The Bytari don't use staging/production environments—they believe in **single-environment progressive delivery** validated purely by **trace-derived metrics** and automated health checks.

Your mission: Fix the observability pipeline and canary validation. Make HotROD deployment-ready with proper distributed tracing.

## ⏰ Deadline

Wednesday, 14 January 2026 at 09:00 CET
> ℹ️ You can still complete the challenge after this date, but points will only be awarded for submissions before the
> deadline.

## 💬 Join the discussion

Share your solutions and questions in
the [challenge thread](TODO)
in the Open Ecosystem Community.

## 🎯 Objective

By the end of this level, you should have:

- **Automated rollout progression** to HotROD version `1.76.0` driven by observability signals
- **OpenTelemetry Collector** configured with:
    - OTLP receiver for traces from HotROD
    - Spanmetrics connector converting traces as metrics
    - Trace export to Jaeger, metrics export to Prometheus
- **Canary analysis** validating deployments with 3 queries:
    - Traffic detection ensuring minimum request rate (**>= 0.05 req/s**) to the canary to prevent "idle canaries" that get promoted but never had real traffic. You can use the `hotrod_requests_total` metric to verify this
    - Error rate thresholds (< 5%)
    - Latency thresholds for the 95th percentile (< 1000ms)

The Bytari engineer who started this setup left an architecture diagram that should help you getting started:

![HotROD Architecture](./images/expert-architecture.png)

## 🧠 What You'll Learn

- Configure [OpenTelemetry Collector](https://opentelemetry.io/docs/collector/) pipelines (receivers, connectors, exporters)
- Use the [Span Metrics Connector](https://github.com/open-telemetry/opentelemetry-collector-contrib/tree/main/connector/spanmetricsconnector) to convert traces into metrics
- Prevent "idle canaries" that deploy successfully but were never really tested because they received no traffic
- Integrate distributed tracing for automated rollout decisions
- Write [PromQL](https://prometheus.io/docs/prometheus/latest/querying/basics/) queries based on app and trace-derived metrics

## 🧰 Toolbox

Your Codespace comes pre-configured with the following tools to help you solve the challenge:

- [`kubectl`](https://kubernetes.io/docs/reference/kubectl/): The Kubernetes command-line tool for interacting with the
  cluster
- [`kubens`](https://github.com/ahmetb/kubectx): Fast way to switch between Kubernetes namespaces
- [`k9s`](https://k9scli.io/): A terminal-based UI to interact with your Kubernetes clusters
- [Argo CD CLI](https://argo-cd.readthedocs.io/en/latest/user-guide/commands/argocd/): Manage Argo CD applications from
  the command line
- [Argo Rollouts kubectl plugin](https://argo-rollouts.readthedocs.io/en/stable/features/kubectl-plugin/): Extended
  kubectl commands for managing Argo rollouts

## ✅ How to Play

### 1. Start Your Challenge

> 📖 **First time?** Check out the [Getting Started Guide](../../start-a-challenge) for detailed instructions on
> forking, starting a Codespace, and waiting for infrastructure setup.

Quick start:

- Fork the repo
- Create a Codespace
- Select "Adventure 01 | 🔴 Expert (Hyperspace Operations & Transport)"
- Wait ~5-10 minutes for all infrastructure to deploy (`Cmd/Ctrl + Shift + P` → `View Creation Log` to view progress)

> ⚠️ After the infrastructure deploys, the setup script automatically starts port
> forwarding to the Argo Rollouts dashboard. This keeps the terminal busy, which is expected behavior. Your environment
> is fully ready when you see the terminal output shown below. Just open a new terminal to run commands.

![Codespace ready state](./images/codespace-post-start.png)

### 2. Access the UIs

- Open the **Ports** tab in the bottom panel to access the following UIs

> 💡 **Not a fan of user interfaces?** No problem, you can also use the CLI tools to complete the challenge. But if
> you're new(ish) to these tools, the UIs can help you get familiar faster.

#### Argo CD (Port 30100)

The Argo CD UI shows the sync status of your applications and allows you to refresh them after pushing new commits.

- Find the Argo CD row (port 30100) and click the forwarded address
- Log in using:
  ```
  Username: readonly
  Password: a-super-secure-password
  ```

#### Argo Rollouts (Port 30101)

The Argo Rollouts dashboard shows canary deployment progress and analysis status.

- Find the Argo Rollouts row (port 30101) and click the forwarded address

#### Prometheus (Port 30102)

The Prometheus UI helps you explore available metrics and test your PromQL queries.

- Find the Prometheus row (port 30102) and click the forwarded address

#### Jaeger (Port 30103)

The Jaeger UI shows distributed traces from HotROD. You can use it to verify that tracing is working end-to-end.

- Find the Jaeger row (port 30103) and click the forwarded address

### 3. Fix the Configuration

The Bytari are counting on you. The HotROD service is deployed but the observability pipeline is broken, preventing new releases. Your task is to investigate, identify, and fix the issues.

Review the [🎯 Objective](#objective) section to understand what a successful solution looks like. The architecture diagram above shows how the components should connect. Use the [Argo Rollouts dashboard](#argo-rollouts-port-30101), [Prometheus UI](#prometheus-port-30102), and [Jaeger UI](#jaeger-port-30103) to debug and validate your changes.

#### Where to Look

All manifests are located in:

```
adventures/01-echoes-lost-in-orbit/expert/manifests/
```

#### Deploy Your Changes

After making your fixes, commit and push them to trigger the deployment:

```bash
git add adventures/01-echoes-lost-in-orbit/expert/manifests/
git commit -m "Fix configuration"
git push
```

> 💡 **Tip:** If you're pushing to a branch other than `main`, make sure to also update the `ApplicationSet` in
> `adventures/01-echoes-lost-in-orbit/expert/manifests/appset.yaml` to point to your branch.

Argo CD will automatically sync your changes after some time. You can speed things up by refreshing the applications
manually:

```bash
argocd app get hotrod --refresh
```

After ArgoCD syncs your changes, trigger a new rollout:

```bash
kubectl argo rollouts retry rollout hotrod -n hotrod
```

If you made changes to the Open Telemetry Collector Config, make sure to restart the collector for them to take effect:

```bash
kubectl rollout restart daemonset/collector -n otel
```

#### Monitor the Rollout

Watch the canary deployment progress in the [Argo Rollouts dashboard](#argo-rollouts-port-30101) or use the CLI:

```bash
kubectl argo rollouts get rollout hotrod -n hotrod --watch
```

The rollout should automatically progress through the canary stages based on the analysis metrics validation.

#### Helpful Documentation

- [OpenTelemetry Collector Configuration](https://opentelemetry.io/docs/collector/configuration/)
- [Span Metrics Connector](https://github.com/open-telemetry/opentelemetry-collector-contrib/tree/main/connector/spanmetricsconnector)
- [Argo Rollouts Analysis](https://argo-rollouts.readthedocs.io/en/stable/features/analysis/)
- [PromQL Basics](https://prometheus.io/docs/prometheus/latest/querying/basics/)

### 4. Verify Your Solution

Once you think you've solved the challenge, it's time to verify!

#### Run the Smoke Test

Run the provided smoke test script from the repo root:

```bash
adventures/01-echoes-lost-in-orbit/expert/smoke-test.sh
```

If the test passes, your solution is very likely correct! 🎉

#### Complete Full Verification

For comprehensive validation and to officially claim completion:

1. **Commit and push your changes** to your fork
2. **Manually trigger the verification workflow** on GitHub Actions
3. **Share your success** with the [community](TODO)

> 📖 **Need detailed verification instructions?** Check out the [Verification Guide](../../verification) for
> step-by-step instructions on both smoke tests and GitHub Actions workflows.