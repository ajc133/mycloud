variable "location" {}

variable "tags" {
  type = map(string)

  default = {
    Environment = "Getting Started with TF"
    Dept        = "Enginerding"
  }
}
