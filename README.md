# aws_s3_upload

A simple, convenient package for uploading to S3.

_Heavily_ inspired by [this stackoverflow answer](https://stackoverflow.com/a/54983831/2330228)

## Motivation / Disclaimer

There already exists a number of Flutter plugins for interacting with S3, some of which are more actively maintained. This small library was built because the few I tried either failed to work out of the box, or required the use of a Pool ID and AWS Cognito, which my project doesn't use. YMMV. 

Added ACL configuration so you can choose the permissions you want when uploading a file.

## Getting Started

Having created credentials on AWS, upload a file like so:
```dart
AwsS3.uploadFile(
  accessKey: "AKxxxxxxxxxxxxx",
  secretKey: "xxxxxxxxxxxxxxxxxxxxxxxxxx",
  file: File("path_to_file"),
  bucket: "bucket_name",
  region: "us-east-2"
);
```