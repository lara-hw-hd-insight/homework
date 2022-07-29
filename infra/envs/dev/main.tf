module "infra" {
    source = "../.."
    project_name = "demo-project"
    regions = ["us-east1", "us-central1"]
    service_account_name = "demo-sa" # !!!! we would create a service account in terraform, but we would get its email back from GCP as requested, this is of course not a good approach but acceptable as a part of technical challenge for interview

    vm_names_append = ["vm1", "vm2"]  # these are parts to "append" to names - full name would be project_name+vm_names_append[0] or vm_names_append[1]
    bucket_name = "test-bucket" 
}