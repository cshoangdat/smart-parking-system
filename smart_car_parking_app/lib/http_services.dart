import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

class TrustAllCertificates {
  http.Client sslClient() {
    var ioClient = HttpClient() ..badCertificateCallback = (X509Certificate cert, String host, int port){ 
      return (host.compareTo("172.20.10.2") == 0); 
    };
    http.Client client = IOClient(ioClient); 
    return client; 
  } 
}

class HttpClientService extends http.BaseClient implements HttpUpdater {
  HttpClientService({
    required this.schema,
    required this.host,
    required http.Client inner,
  }) : _inner = inner;

  final String schema;
  final String host;

  final http.Client _inner;

  HttpUpdater get updater => this;

  static ErrorResponse parseErrorResponse(String data){
    var response = jsonDecode(data);
    return ErrorResponse(
      message: response["message"] as String?,
      error: response["error"] as String?,
      statusCode: response["statusCode"] as int?
    );
  }

  static AddParkingResponse parseAddParkingResponse(String data){
    var response = jsonDecode(data);
    return AddParkingResponse(
      message: response["message"] as String?,
      uuid: response["uuid"] as String?,
    );
  }

  static CheckParkingResponse parsecheckParkingResponse(String data){
    var response = jsonDecode(data);
    return CheckParkingResponse(
      message: response["message"] as String?,
      excessTime: response["excess_time"] as String?,
      time: response["time"] as String?,
      location: response["location"] as String?,
    );
  }

  static List<dynamic> parseGetParkingResponse(String data){
    final List<dynamic> dataList = jsonDecode(data);
    return dataList;
  }

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    // request.headers['User-Agent'] = userAgent;
    return _inner.send(request);
  }

  @override
  Future<CloudResponse> addVehicle({
    required String plate,
    required String date,
    required String endTime,
    required String startTime,
    required String parkingLocation,
  }) async {
    final uri = Uri(
      scheme: schema,
      host: host,
      path: "add_vehicle",
      port: 5000
    );
    // this.userAgent = userAgent;
    try{
    final rsp = await post(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: json.encode(
      {
        "plate": plate,
        "date": date,
        "startTime": startTime,
        "endTime": endTime,
        "parkingLocation" : parkingLocation
       }
      ) 
    ).timeout(const Duration(seconds: 20));
    if(rsp.statusCode != 200){
      return CloudResponse(rsp.statusCode, (rsp.body.isEmpty)? null : parseErrorResponse(rsp.body));
    }
    return CloudResponse(rsp.statusCode, (rsp.body.isEmpty)? null : parseAddParkingResponse(rsp.body));
    }
    catch(error){
      String errorString = error.toString();
      if(error.toString().contains("uri")){
        List<String> parts = error.toString().split(", ");
        parts.removeWhere((part) => part.startsWith("address ="));
        parts.removeWhere((part) => part.startsWith("port ="));
        parts.removeWhere((part) => part.startsWith("uri="));
        errorString = parts.join(", ");
        // Log.writeUpdateErrorLog(logSerialNumber, "check", errorString, write: true);
      }
      // else{
      //   Log.writeUpdateErrorLog(logSerialNumber, "check", error.toString(), write: true);
      // }
      throw Exception(errorString);
    }
  }
  @override
  Future<CloudResponse> checkOut({
    required String plate,
    required String time,
    required String uuid,
  }) async {
    final uri = Uri(
      scheme: schema,
      host: host,
      path: "check_out",
      port: 5000
    );
    // this.userAgent = userAgent;
    try{
    final rsp = await post(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: json.encode({
        "plate": plate,
        "time": time,
        "uuid": uuid,
      })
    ).timeout(const Duration(seconds: 20));
    if(rsp.statusCode != 200 && rsp.statusCode != 201){
      return CloudResponse(rsp.statusCode, (rsp.body.isEmpty)? null : parseErrorResponse(rsp.body));
    }
    return CloudResponse(rsp.statusCode, (rsp.body.isEmpty)? null : parsecheckParkingResponse(rsp.body));
    }
    catch(error){
      String errorString = error.toString();
      if(error.toString().contains("uri")){
        List<String> parts = error.toString().split(", ");
        parts.removeWhere((part) => part.startsWith("address ="));
        parts.removeWhere((part) => part.startsWith("port ="));
        parts.removeWhere((part) => part.startsWith("uri="));
        errorString = parts.join(", ");
        // Log.writeUpdateErrorLog(logSerialNumber, "check", errorString, write: true);
      }
      // else{
      //   Log.writeUpdateErrorLog(logSerialNumber, "check", error.toString(), write: true);
      // }
      throw Exception(errorString);
    }
  }
  @override
  Future<CloudResponse> getParking() async {
    final uri = Uri(
      scheme: schema,
      host: host,
      path: "get_parking",
      port: 5000
    );
    // this.userAgent = userAgent;
    try{
    final rsp = await get(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json',
      }
    ).timeout(const Duration(seconds: 20));
    if(rsp.statusCode != 200){
      return CloudResponse(rsp.statusCode, (rsp.body.isEmpty)? null : parseErrorResponse(rsp.body));
    }
    return CloudResponse(rsp.statusCode, (rsp.body.isEmpty)? null : parseGetParkingResponse(rsp.body));
    }
    catch(error){
      String errorString = error.toString();
      if(error.toString().contains("uri")){
        List<String> parts = error.toString().split(", ");
        parts.removeWhere((part) => part.startsWith("address ="));
        parts.removeWhere((part) => part.startsWith("port ="));
        parts.removeWhere((part) => part.startsWith("uri="));
        errorString = parts.join(", ");
        // Log.writeUpdateErrorLog(logSerialNumber, "check", errorString, write: true);
      }
      // else{
      //   Log.writeUpdateErrorLog(logSerialNumber, "check", error.toString(), write: true);
      // }
      throw Exception(errorString);
    }
  }
}

class CloudResponse<T> {
  final int status;
  final T data;

  CloudResponse(this.status, this.data);
}

abstract class HttpUpdater {
  Future<CloudResponse> getParking();
  Future<CloudResponse> addVehicle({
    required String plate,
    required String date,
    required String endTime,
    required String startTime,
    required String parkingLocation,
  });
  
  Future<CloudResponse> checkOut({
    required String plate,
    required String time,
    required String uuid,
  });
}

class ErrorResponse{
  ErrorResponse({
    required this.message,
    required this.error,
    required this.statusCode
  });
  final String? message;
  final String? error;
  final int? statusCode;
}

class AddParkingResponse{
  AddParkingResponse({
    required this.message,
    required this.uuid,
  });
  final String? message;
  final String? uuid;
}

class CheckParkingResponse{
  CheckParkingResponse({
    required this.message,
    required this.excessTime,
    required this.time,
    required this.location
  });
  final String? message;
  final String? excessTime;
  final String? time;
  final String? location;
}

class ParkingInfo{
  ParkingInfo({
    required this.plate,
    required this.date,
    required this.endTime,
    required this.startTime,
    required this.parkingLocation,
  });
  final String? plate;
  final String? date;
  final String? endTime;
  final String? startTime;
  final String? parkingLocation;
}