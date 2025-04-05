locals {
  custom_script_content= templatefile("${path.module}/scripts/build_agent.sh", # Path to script
  {
    # Parameters for script
    AGENT_HOSTNAME= var.vm_name
    AZDO_ORG_URL= var.azdo_org_url
    AZDO_PAT= var.azdo_pat
    AZDO_POOL= var.azdo_pool
  }
  )
}