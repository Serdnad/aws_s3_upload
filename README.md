# aws_s3_upload

A simple, convenient package for uploading to S3.

_Heavily_ inspired by [this stackoverflow answer](https://stackoverflow.com/a/54983831/2330228)

## Getting Started

Having created credentials on AWS, upload a file like so:
```dart
S3.uploadFile(
  accessKey: "AKxxxxxxxxxxxxx",
  secretKey: "xxxxxxxxxxxxxxxxxxxxxxxxxx",
  file: File("path_to_file"),
  bucket: "bucket_name",
  region: "us-east-2"
);
```