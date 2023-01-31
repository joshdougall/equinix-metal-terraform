remote_state {
  backend = "gcs"
  config = {
    bucket   = "equinix-metal-demo-terraform-state"
    location = "us-central1"
    prefix   = "terraform/state"
    project  = "equinix-metal"
  }
}

terraform {
  before_hook "before_hook_1" {
    commands = [
      "apply",
      "destroy",
      "plan",
      "refresh",
    ]
    execute = ["sops", "-d", "--output", "vars.json", "vars.enc.json"]
  }

  after_hook "after_hook_1" {
    commands = [
      "apply",
      "destroy",
      "plan",
      "refresh",
    ]
    execute      = ["rm", "-f", "vars.json"]
    run_on_error = true
  }
  extra_arguments "custom_vars" {
    commands = [
      "apply",
      "destroy",
      "plan",
      "refresh",
    ]
    arguments = [
      "-var=project_name=${basename(get_terragrunt_dir())}",
    ]

    required_var_files = [
      "${get_terragrunt_dir()}/../common.tfvars",
      "${get_terragrunt_dir()}/vars.json",
    ]
  }
}