import 'dart:io';

import 'package:amazon_cognito_identity_dart_2/sig_v4.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

import './policy.dart';

/// Convenience class for uploading files to AWS S3
class AwsS3 {
  /// Upload a file, returning the file's public URL on success.
  static Future<String> uploadFile({
    /// AWS access key
    String accessKey,

    /// AWS secret key
    String secretKey,

    /// The name of the S3 storage bucket to upload  to
    String bucket,

    /// The path to upload the file to (e.g. "uploads/public"). Defaults to the root "directory"
    String destDir,

    /// The AWS region. Must be formatted correctly, e.g. us-west-1
    String region = 'us-east-2',

    /// The file to upload
    File file,
  }) async {
    AwsS3.uploadFile(
        accessKey: "AKxxxxxxxxxxxxx",
        secretKey: "xxxxxxxxxxxxxxxxxxxxxxxxxx",
        file: File("path_to_file"),
        bucket: "bucket_name",
        region: "us-east-2");

    final endpoint = 'https://$bucket.s3-$region.amazonaws.com';

    final stream = http.ByteStream(Stream.castFrom(file.openRead()));
    final length = await file.length();

    final uri = Uri.parse(endpoint);
    final req = http.MultipartRequest("POST", uri);
    final multipartFile = http.MultipartFile('file', stream, length, filename: path.basename(file.path));

    final policy = Policy.fromS3PresignedPost('$destDir/${path.basename(file.path)}', bucket, accessKey, 15, length,
        region: region);
    final key = SigV4.calculateSigningKey(secretKey, policy.datetime, region, 's3');
    final signature = SigV4.calculateSignature(key, policy.encode());

    req.files.add(multipartFile);
    req.fields['key'] = policy.key;
    req.fields['acl'] = 'public-read';
    req.fields['X-Amz-Credential'] = policy.credential;
    req.fields['X-Amz-Algorithm'] = 'AWS4-HMAC-SHA256';
    req.fields['X-Amz-Date'] = policy.datetime;
    req.fields['Policy'] = policy.encode();
    req.fields['X-Amz-Signature'] = signature;

    try {
      final res = await req.send();

      if (res.statusCode == 204) return '$endpoint/$destDir/${path.basename(file.path)}';
    } catch (e) {
      print(e.toString());
    }
  }
}
