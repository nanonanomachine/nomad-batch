# nomad-batch

Experimentation run multiple Docker container with different parameters on Nomad

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

## Trouble shooting

`error="API error (500): error while creating mount source path '/host_mnt/private/tmp/NomadClient1`

=> If you run Nomad Cluster locally with sudo, it happened (confirmed with M1 mac). In that case do not use `sudo` to execute `nomad agent`

## Todo

- [ ] PaaS support

