# 🛰️ Adventure 01: Echoes Lost in Orbit

Welcome to the first challenge in the **Open Ecosystem Challenge** series!  
Your mission: restore interstellar communication by fixing a broken GitOps setup.  
This is a hands-on troubleshooting exercise using **Kubernetes**, **Argo CD**, and **Kustomize**.

The entire **infrastructure is pre-provisioned in your Codespace** — Kubernetes cluster, Argo CD, and sample app are
ready to go.  
**You don’t need to set up anything locally. Just focus on solving the problem.**

## 🪐 The Backstory

Welcome aboard the GitOps Starliner, a multi-species engineering vessel orbiting the vibrant planet of Polaris-9. Life
in this quadrant is wonderfully diverse — from the whispering cloud-dwellers of Nebulon to the rhythmic click-speakers
of Crustacea Prime.

Communication between species used to be seamless, thanks to the Echo Server, a universal translator that instantly
echoed your words in the listener's native format.

But lately, something's off.

Messages are getting scrambled. Some transmissions never arrive. The Echo Server, deployed across the Staging Moonbase
and the Production Outpost, is no longer syncing properly. The Argo CD dashboard shows no active deployments, and
telemetry is suspiciously quiet.

**You've been assigned to restore interstellar communication before the next critical mission.**

## 🎮 Choose Your Level

Each level is a standalone challenge with its own Codespace that builds on the story while being technically
independent — pick your level and start wherever you feel comfortable!

> 💡 Not sure which level to choose? [Learn more about levels](/#how-it-works)

### 🟢 Beginner: Broken Echoes

**Status:** ✅ Available  
**Topics:** ArgoCD ApplicationSets, GitOps fundamentals

The Echo Server is misbehaving. Both environments seem to be down, and messages are silent. Your mission: investigate
the ArgoCD configuration and restore proper multi-environment delivery.

[**Start the Beginner Challenge**](./beginner.md){ .md-button .md-button--primary }

### 🟡 Intermediate: The Silent Canary

**Status:** ✅ Available  
**Topics:** Argo Rollouts, Progressive Delivery, Prometheus

After fixing the communication outage, the Intergalactic Union welcomed a new species: the Zephyrians. The communications
team attempted to deploy their language files using a progressive delivery system, but the rollout is failing. Your
mission: debug the broken canary deployment and bring the Zephyrians' voices online.

[**Start the Intermediate Challenge**](./intermediate.md){ .md-button .md-button--primary }

### 🔴 Expert: Echoes in the Dark

**Status:** ✅ Available  
**Topics:** Argo Rollouts, Progressive Delivery, Prometheus, Open Telemetry, Jaeger

After fixing the Zephyrian communications, word of your progressive release mastery spread across the galaxy. The **Bytari**, a highly advanced species from the Andromeda sector, were impressed. 🌟

They want to apply progressive delivery to their mission-critical service: **HotROD** (Hyperspace Operations & Transport - Rapid Orbital Dispatch), an interstellar ride-sharing service handling dispatch requests across thousands of star systems. Every millisecond of latency matters, and any error could strand travelers between dimensions.

[**Start the Expert Challenge**](./expert.md){ .md-button .md-button--primary }

