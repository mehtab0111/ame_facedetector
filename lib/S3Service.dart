import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:crypto/crypto.dart';

class AwsSigV4 {
  static String sign(
      String secretKey,
      String dateStamp,
      String regionName,
      String serviceName,
      String stringToSign,
      ) {
    final kDate = _hmacSha256(utf8.encode('AWS4$secretKey'), utf8.encode(dateStamp));
    final kRegion = _hmacSha256(kDate as List<int>, utf8.encode(regionName));
    final kService = _hmacSha256(kRegion as List<int>, utf8.encode(serviceName));
    final kSigning = _hmacSha256(kService as List<int>, utf8.encode('aws4_request'));
    final signature = _hmacSha256(kSigning as List<int>, utf8.encode(stringToSign)).toString();

    return signature;
  }

  static Digest _hmacSha256(List<int> key, List<int> data) {
    final hmac = Hmac(sha256, key);
    return hmac.convert(data);
  }

  static String hashHex(String payload) {
    final bytes = utf8.encode(payload);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
}

class S3Service {
  final String accessKey;
  final String secretKey;
  final String region;
  final String bucketName;

  S3Service({
    required this.accessKey,
    required this.secretKey,
    required this.region,
    required this.bucketName,
  });

  Future<List<String>> listImages() async {
    final host = '$bucketName.s3.$region.amazonaws.com';
    final endpoint = 'https://$host/';
    final method = 'GET';
    final service = 's3';
    final now = DateTime.now().toUtc();
    final date = DateFormat('yyyyMMdd').format(now);
    final amzDate = DateFormat('yyyyMMdd\'T\'HHmmss\'Z\'').format(now);

    final canonicalUri = '/';
    final canonicalQueryString = '';
    final canonicalHeaders = 'host:$host\nx-amz-date:$amzDate\n';
    final signedHeaders = 'host;x-amz-date';
    final payloadHash = AwsSigV4.hashHex('');

    final canonicalRequest = '$method\n$canonicalUri\n$canonicalQueryString\n$canonicalHeaders\n$signedHeaders\n$payloadHash';
    final algorithm = 'AWS4-HMAC-SHA256';
    final credentialScope = '$date/$region/$service/aws4_request';
    final stringToSign = '$algorithm\n$amzDate\n$credentialScope\n${AwsSigV4.hashHex(canonicalRequest)}';
    final signingKey = AwsSigV4.sign(secretKey, date, region, service, stringToSign);

    final authorizationHeader = '$algorithm Credential=$accessKey/$credentialScope, SignedHeaders=$signedHeaders, Signature=$signingKey';

    final headers = {
      'x-amz-date': amzDate,
      'Authorization': authorizationHeader,
    };

    final response = await http.get(Uri.parse(endpoint), headers: headers);

    if (response.statusCode == 200) {
      final xml = response.body;
      // Parse XML to extract image keys (assuming they are listed in <Key> tags)
      final keys = <String>[];
      final regExp = RegExp('<Key>(.*?)</Key>');
      for (final match in regExp.allMatches(xml)) {
        keys.add(match.group(1)!);
      }
      return keys;
    } else {
      throw Exception('Failed to list images');
    }
  }
}
