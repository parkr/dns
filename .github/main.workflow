workflow "Test on push" {
  on = "push"
  resolves = ["octodns test"]
}

action "octodns test" {
  uses = "docker://parkr/octodns:v0.9.4"
  args = "octodns-sync --config-file ./config/production.yaml"
}
