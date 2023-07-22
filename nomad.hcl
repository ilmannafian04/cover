variable "version" {
  type = string
}

job "cover" {
  datacenters = ["ln-sg"]

  group "cover" {
    network {
      port "http" {}
    }

    service {
      name = "cover"
      port = "http"
      tags = [
        "traefik.enable=true",
        "traefik.http.routers.cover.rule=Host(`ilmannfn.com`)",
        "traefik.http.routers.cover.entrypoints=websecure",
        "traefik.http.routers.cover.tls=true",
        "traefik.http.routers.cover.tls.certResolver=cloudflareResolver",
      ]

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
        ports = ["http"]
      }

      resources {
        cpu    = 10
        memory = 10
      }
    }
  }
}
