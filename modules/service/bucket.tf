#https://docs.aws.amazon.com/ko_kr/elasticloadbalancing/latest/classic/enable-access-logs.html
variable "elb_account_ids" {
  type = map
  default = {
    "us-east-1"      = "127311923021",
    "us-east-2"      = "033677994240",
    "us-west-1"      = "027434742980",
    "us-west-2"      = "797873946194",
    "ca-central-1"   = "985666609251",
    "eu-central-1"   = "054676820928",
    "eu-west-1"      = "156460612806",
    "eu-west-2"      = "652711504416",
    "eu-west-3"      = "009996457667",
    "eu-north-1"     = "897822967062",
    "ap-east-1"      = "754344448648",
    "ap-northeast-1" = "582318560864",
    "ap-northeast-2" = "600734575887",
    "ap-northeast-3" = "383597477331",
    "ap-southeast-1" = "114774131450",
    "ap-southeast-2" = "783225319266",
    "ap-south-1"     = "718504428378",
    "me-south-1"     = "076674570225",
    "sa-east-1"      = "507241528517",
    "us-gov-west-1"  = "048591011584",
    "us-gov-east-1"  = "190560391635",
    "cn-north-1"     = "638102146993",
    "cn-northwest-1" = "037604701340"
  }
}

resource "aws_s3_bucket" "this" {
  bucket        = "${local.log_bucket}"
  acl    = "private"

  lifecycle_rule {
    id      = "${local.log_bucket}/${local.log_prefix}/"
    enabled = true

    prefix = "${local.log_prefix}/"

    tags = {
      "rule"      = "log"
      "autoclean" = "true"
    }

    transition {
      days          = "${local.log_expiration_days}"
      storage_class = "STANDARD_IA"
    }

    transition {
      days          = "${local.log_expiration_days*2}"
      storage_class = "GLACIER"
    }

    expiration {
      days = "${local.log_expiration_days*3}"
    }
  }
  force_destroy = true
}

resource "aws_s3_bucket_policy" "this" {
  bucket = "${aws_s3_bucket.this.id}"

  policy = <<POLICY
{
  "Id": "Policy1429136655940",
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "Stmt1429136633762",
      "Action": [
        "s3:PutObject"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::${local.log_bucket}/${local.log_prefix}/*",
      "Principal": {
        "AWS": [
          "${var.elb_account_ids[var.region]}"
        ]
      }
    }
  ]
}
POLICY
}
