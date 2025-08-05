# * Module Local Variables for internal state configuration
# * ----------------------------------------------------------

locals {
  prefix          = "${var.env}-${var.project}-${var.module}"
  global_suffix   = "${var.region}-${var.account_id}"
  function_name   = local.prefix
}
