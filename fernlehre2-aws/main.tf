module "frontend-1" {
  source        = "./modules/dealstore"
  frontend_name = "dealstore"

}

# module "frontend-2" {
#   source        = "./modules/dealstore"
#   frontend_name = "dealstore_s2"

# }


output "first-url" {
  value = module.frontend-1.main-url
}

