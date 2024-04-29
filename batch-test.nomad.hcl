# variable "param1" {}

job "batch-test" {
  type = "batch"

  parameterized {
    meta_required = ["batch_task_input"]
  }

  group "batch-group" {
    count = 1

    task "batch-task" {
      template {
        data        = <<EOH
        BATCH_TASK_INPUT={{ env "NOMAD_META_batch_task_input" }}
        EOH
        destination = "local/env.txt"
        env         = true
      }

      restart {
        attempts = 2
        delay    = "15s"
        interval = "10s"
        mode     = "fail"
      }
      driver = "docker"

      config {
        image = "ghcr.io/nanonanomachine/batch-test:94d3b6b"
      }
    }
  }
}
