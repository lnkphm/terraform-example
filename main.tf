provider "aws" {
    region = "ap-southeast-1"
}

resource "aws_instance" "example" {
    ami = "ami-03b8ac6ede2380907"
    instance_type = "t2.micro"

    tags = {
        Name = "terraform-example"
    }
}
