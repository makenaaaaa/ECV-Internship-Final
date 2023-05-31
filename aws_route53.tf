data "aws_route53_zone" "example" {
  name = "internship.msppoc.com"
}

// Primary record
resource "aws_route53_record" "www1" {
  zone_id = data.aws_route53_zone.example.zone_id
  name    = "final.internship.msppoc.com"
  type    = "A"

  failover_routing_policy {
    type = "PRIMARY"
  }
  health_check_id = aws_route53_health_check.example1.id
  set_identifier  = "cloudfront"

  alias {
    name                   = aws_lb.example.dns_name
    zone_id                = aws_lb.example.zone_id
    evaluate_target_health = true
  }

  depends_on = [aws_route53_health_check.example1]
}

resource "aws_route53_health_check" "example1" {
  port              = 80
  request_interval  = 30
  failure_threshold = 3
  type              = "HTTP"
  resource_path     = "/"

  fqdn = aws_lb.example.dns_name

  depends_on = [aws_lb.example]

  tags = {
    Name = "aws"
  }
}

// Secondary record
resource "aws_route53_record" "www2" {
  zone_id = data.aws_route53_zone.example.zone_id
  name    = "final.internship.msppoc.com"
  type    = "A"
  // must have
  ttl = "60"

  set_identifier = "www2"

  records = [azurerm_public_ip.alb.ip_address]
  failover_routing_policy {
    type = "SECONDARY"
  }
  health_check_id = aws_route53_health_check.example2.id

  depends_on = [
    aws_route53_health_check.example2
  ]
}

resource "aws_route53_health_check" "example2" {

  port              = 80
  request_interval  = 30
  failure_threshold = 3
  type              = "HTTP"
  resource_path     = "/"
  ip_address        = azurerm_public_ip.alb.ip_address
  tags = {
    Name = "azure"
  }
  depends_on = [azurerm_network_interface_application_gateway_backend_address_pool_association.example]
}

output "test" {
  value = aws_lb.example.dns_name
}