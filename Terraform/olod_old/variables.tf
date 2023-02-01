################ Project ################
# Input variable: project_name
variable "project" {
  description = "OC Project/Namespace Name to be added to the project"
  type = string
  default = ""
}
################ ConfigPath ################
# Input variable: ConfigPath
variable "ConfigPath" {
  description = "OC configPath to be added to the project"
  type = string
  default = ""
}

################################################
################ resource_qouta ################
# Input variable: quota_pods
variable "quota_pods" {
  description = "quota_pods to be added to the project"
  type = string
  default = ""
}

# Input variable: quota_cpu_request
variable "quota_cpu_request" {
  description = "quota_cpu_request to be added to the project"
  type = string
  default = ""
}

# Input variable: quota_memory_request
variable "quota_memory_request" {
  description = "quota_memory_request to be added to the project"
  type = string
  default = ""
}

# Input variable: quota_cpu_limit
variable "quota_cpu_limit" {
  description = "quota_cpu_limit to be added to the project"
  type = string
  default = ""
}

# Input variable: quota_memory_limit
variable "quota_memory_limit" {
  description = "quota_memory_limit to be added to the project"
  type = string
  default = ""
}

# Input variable: quota_storage
variable "quota_storage" {
  description = "quota_storage to be added to the project"
  type = string
  default = ""
}
################################################
################ Network #######################
# Input variable: EgressIP
variable "EgressIP" {
  description = "EgressIP to be added to the project"
  type = string
  default = ""
}
# Input variable: EgressIP HA
variable "EgressIpHA" {
  description = "EgressIP to be added to the project HA"
  type = string
  default = ""
}

################################################
################ Network #######################
# Input variable: IngressIP
# no action will be taken on this Variable
variable "IngressIP" {
  description = "IngressIP to be added to the project"
  type = string
  default = ""
}
################################################

# Input Variable: Site 
variable "Site" {
  description = "Site to be selected from the portal"
  type = string
  default = ""
}
# Input Variable: Group
variable "GROUP" {
  description = "GROUP to be added to the project"
  type = string
  default = ""
}


