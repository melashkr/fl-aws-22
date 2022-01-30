module "podtatohead-1" {
  source               = "./modules/podtatohead"
  podtato_name         = "first"
  hats_version         = "v3"
  left_arm_version     = "v2"
  left_leg_version     = "v1"
  podtato_version      = "v0.1.0"
  right_arm_version    = "v4"
  right_leg_version    = "v1"
  app_name             = "my_first_potato_head_v6"
  GITHUB_USER = var.GITHUB_USER
  GITHUB_CLIENT_ID = var.GITHUB_CLIENT_ID
  GITHUB_CLIENT_SECRET = var.GITHUB_CLIENT_SECRET
}


output "first-url" {
  value = module.podtatohead-1.podtato-url
}

output "podtato-url" {
  value = module.podtatohead-1.app_url 
}

output "podtato-ip" {
  value = module.podtatohead-1.podtato-ip
}
# output "second-url" {
#   value = module.podtatohead-2.podtato-url
# }
