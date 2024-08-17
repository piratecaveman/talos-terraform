variable "kubenet" {
  type = list(string)
  default = [
    "kube-control-1",
    "kube-minion-1",
    "kube-minion-2"
  ]
}
