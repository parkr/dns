workflow "Test on push" {
  on = "push"
  resolves = ["octodns test"]
}

action "octodns test" {
  uses = "docker://parkr/octodns:v0.9.4"
  args = "octodns-sync --config-file ./config/production.yaml"
  secrets = ["CLOUDFLARE_TOKEN", "CLOUDFLARE_EMAIL"]
}

workflow "Deploy on push" {
  on = "push"
  resolves = "octodns sync"
}

action "octodns sync" {
  uses = "docker://parkr/octodns:v0.9.4"
  args = "octodns-sync --config-file ./config/production.yaml --doit"
  secrets = ["CLOUDFLARE_TOKEN", "CLOUDFLARE_EMAIL"]
  needs = ["On branch master"]
}

action "On branch master" {
  uses = "actions/bin/filter@3c0b4f0e63ea54ea5df2914b4fabf383368cd0da"
  args = "branch master"
}
