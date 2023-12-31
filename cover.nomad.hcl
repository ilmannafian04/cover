variable "version" {
  type = string
}

job "cover" {
  datacenters = ["id-dpk"]

  group "cover" {
    network {
      mode = "bridge"

      port "http" {
        to = 80
      }
    }

    service {
      name = "cover"
      port = "http"

      check {
        name = "Cover HTTP Check"
        type = "http"
        port = "http"
        path = "/ping"

        interval = "30s"
        timeout  = "10s"
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
