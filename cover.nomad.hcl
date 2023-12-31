variable "version" {
  type = string
}

job "cover" {
  region      = "id"
  datacenters = ["id-dpk"]

  group "cover" {
    network {
      mode = "bridge"

      port "healthcheck" {}
    }

    service {
      name = "cover"
      port = "80"

      connect {
        sidecar_service {}
      }

      check {
        name = "Cover HTTP Check"
        type = "http"
        port = "healthcheck"
        path = "/ping"

        interval = "30s"
        timeout  = "10s"
        expose   = true
      }
    }

    task "cover" {
      driver = "docker"
      
      config {
        image = "ilmannafian/cover:${var.version}"
      }

      resources {
        cpu    = 50
        memory = 20
      }
    }
  }
}
