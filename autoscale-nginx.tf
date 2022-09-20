resource "kubernetes_horizontal_pod_autoscaler" "nginx" {
        metadata {
          name = "nginx-autoscale"
        }

        spec {
          min_replicas = 1
          max_replicas = 8

          scale_target_ref {
                kind = "Deployment"
                name = "nginx"
          }

          behavior {
                scale_down {
                  stabilization_window_seconds = 120
                  select_policy                = "Min"
                  policy {
                        period_seconds = 60
                        type           = "Pods"
                        value          = 1
                  }

                  policy {
                        period_seconds = 240
                        type           = "Percent"
                        value          = 100
                  }
                }
                scale_up {
                  stabilization_window_seconds = 180
                  select_policy                = "Max"
                  policy {
                        period_seconds = 120
                        type           = "Percent"
                        value          = 100
                  }
                  policy {
                        period_seconds = 300
                        type           = "Pods"
                        value          = 5
                  }
                }
          }
        }
  }
