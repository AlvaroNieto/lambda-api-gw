#Storage variables

variable "html_path" {
  description = "Path to the HTML files"
  type        = string
}

variable "upload_bucket_id" {
  description = "Bucket name"
  type        = string
}

# WORKS1 variable "script_js_file" {
# WORKS1   description = "Just to force the dependency. Path"
# WORKS1   type        = string
# WORKS1 }

variable "script_js_name" {
  description = "Just to force the dependency. Name api.js"
  type        = string
}

variable "script_jscontent" {
  description = "Just to force the dependency. Content of file"
  type        = string
}