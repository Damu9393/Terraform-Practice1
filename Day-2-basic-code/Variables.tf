variable "ami_id" {
  description = "inserting ec2 instance"
  type = string
  default = "ami-085ad6ae776d8f09c"
}


variable "type" {
  type = string
  default = "t2.micro"

}


variable "key" {
   type = string
   default = "MyKeyPair"
} 