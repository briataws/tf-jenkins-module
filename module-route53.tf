#
# Module: fg-hello-world-app:route53
#

#
# Route 53
#

resource "aws_route53_record" "selected" {
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = "${var.app_name}.${var.route53_zone_name}"
  type    = "CNAME"
  ttl     = "300"
  records = ["${aws_alb.selected.dns_name}"]
}
