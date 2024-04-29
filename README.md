# nomad-batch

Experimentation run multiple Docker container with different parameters on Nomad

## Why Nomad?

**Easy to set up**

There's a requirement that we want to run Docker job with a large scale. Nomad is a lightweight orchestration tool, so instead of setting up a complex orchestration tool like Kubernetes, it can reduce the time set up and maintenance it.

**Effective resource usage**

Nomad operates within the constraints of the resources available to it. When you run a lot of jobs with Nomad, it will attempt to schedule them onto available client nodes based on various factors like resource requirements, job priorities, and constraints.
If all available client nodes are busy executing other jobs, Nomad will queue the pending jobs until resources become available. Nomad has a queuing mechanism that allows it to hold jobs in a queue until resources are freed up. Once resources become available, Nomad will start executing the queued jobs in the order of their priority or other scheduling policies configured.

**Retry**

Nomad supports job retries through the use of the "restart" block in job specifications. The "restart" block allows you to specify how many times a task should be retried upon failure and the delay between each retry attempt.

https://developer.hashicorp.com/nomad/docs/job-specification/restart

**Enviornment agnostic**

It can support both local machine (dev mode) and other Cloud platform, e.g. AWS https://aws.amazon.com/jp/quickstart/architecture/nomad/
.

NOTE: however there's a manual infrastructure setup required. If we want to try to avoid infrastructure set up, [AWS Batch](https://aws.amazon.com/batch/) may be more suitable.

## How Nomad is used in this repo

```
terminal: batch request to run nomad jobs -> Nomad cluster -> Docker job (including retry on failure)
                                                           -> Docker job
                                                           -> Docker job
```

Dockerfile runs very simple ruby script:

1. Stdout input argument (passed via BATCH_TASK_INPUT env var)
2. Sleep 5 seconds
3. Raise an error with a probability of 1 in 10, otherwise stdout "Successfully finished"

## Prequisites

- Docker Desktop is installed (Docker Desktop alternatives may not work, e.g., Orb stack)
- Nomad is installed

## How-to run Nomad cluster

- Install: https://developer.hashicorp.com/nomad/tutorials/get-started/gs-install
- Create cluster: https://developer.hashicorp.com/nomad/tutorials/get-started/gs-start-a-cluster

Create the cluster on local

```zsh
$ nomad agent -dev \
  -bind 0.0.0.0 \
  -network-interface='{{ GetDefaultInterfaces | attr "name" }}'
```

Access http://localhost:4646 to see Nomad UI

## How-to run

- nomad job run: register job
- nomad job dispatch: schedule the job with parmaeter

```zsh
$ nomad job run batch-test.nomad.hcl
$ nomad job dispatch -meta batch_task_input="test input" batch-test
```

To stop the job

```zsh
$ nomad job stop -purge batch-test
```

## How-to run multiple jobs

```zsh
for i in {1..100..1}; do nomad job dispatch -meta batch_task_input="$(openssl rand -base64 12)" batch-test &; done
```

## Trouble shooting

`error="API error (500): error while creating mount source path '/host_mnt/private/tmp/NomadClient1`

=> If you run Nomad Cluster locally with sudo, it happened (confirmed with M1 mac). In that case do not use `sudo` to execute `nomad agent`

## Todo

- [ ] PaaS support

