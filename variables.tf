variable "release_sequence" {
  description = "The release sequence to install. Defaults to 0 (unpinned)."
  default     = 0
}

variable "os_type" {
  description = "The OS to use for instance(s). Defaults to ubuntu."
  default     = "ubuntu"
}
