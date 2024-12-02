/*
This is api provider
This page is used to get data from API
 */
import 'dart:async';
import 'dart:convert';

import '../../subconfig/AppSettings.dart';
import '../../subconfig/constant.dart';
import '../../subconfig/static.dart';
import '../../subdata/model/user_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../subconfig/auth.dart';

class ApiProvider {
  final String _url = AppSettings.urlAPI;
  Dio dio = Dio();
  late Response response;
  // late UserModel userModel;

  String connErr = 'Please check your internet connection and try again';

  Future<Response> postConnect_NonBloc(apiUrl, data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    CancelToken cancelToken = CancelToken();

    var fullUrl = _url + apiUrl;
    // print('fullUrl : ' + fullUrl.toString());
    // print('postData : ' + data.toString());
    try {
      // dio.options.headers['content-Type'] = 'application/x-www-form-urlencoded';

      dio.options.headers['content-Type'] = 'application/json';
      dio.options.connectTimeout = Duration(seconds: 60);
      dio.options.receiveTimeout = Duration(seconds: 60);
      // --------------------
      String token = prefs.getString('token') ?? '';
      dio.options.headers["Accept"] = "application/json";
      dio.options.headers["app-token"] = prefs.getString('AppToken') ?? '';
      dio.options.headers["app-id"] = prefs.getString('AppId') ?? '';
      dio.options.headers["fcm-token"] = prefs.getString('fcmToken') ?? '';

      UserModel userCls;
      final userJson = prefs.getString('user') ?? '';
      if (userJson.isNotEmpty) {
        Map<String, dynamic> map = jsonDecode(userJson);
        userCls = UserModel.fromJson(map);
        dio.options.headers["X-AppVersionBuilt"] = AppSettings.AppVersionBuilt;
        dio.options.headers["X-user-kodkawasan"] = userCls.userUser_Kod_Kawasan;
        dio.options.headers["X-user-kodkeselamatan"] = userCls.userUser_Kod_Keselamatan;
        if (AppSettings.AppKey == 'myJR') {
          dio.options.headers["X-user-kodkeselamatanSub"] = '201myjr';
          dio.options.headers["X-user-kodkeselamatanSubNama"] = '201myjr';
        } else {
          if (AppSettings.Auth_Type == 'PIN') {
            dio.options.headers["X-user-kodkeselamatanSub"] = userCls.userUser_Kod_KeselamatanSub;
            dio.options.headers["X-user-kodkeselamatanSubNama"] = userCls.userUser_Kod_KeselamatanSubNama;
          } else {
            dio.options.headers["X-user-kodkeselamatanSub"] = '';
            dio.options.headers["X-user-kodkeselamatanSubNama"] = '';
          }
        }
      }

      if (token.isNotEmpty) {
        // print(token);
        dio.options.headers["Authorization"] = "Bearer " + token;
      }
      // --------------------
      var response = await dio.post(fullUrl, data: data, cancelToken: cancelToken);

      String newToken = response.headers.value("new-token") ?? "";
      String isDDay = response.headers.value("is-dday") ?? '0';

      if (newToken.isNotEmpty) {
        // print("New Token: " + newToken);
        prefs.setString('token', newToken);
      }

      return response;
    } on DioError catch (e) {
      //print(e.toString()+' | '+url.toString());

      if ((e.response!.statusCode) == 401) {
        print("401");
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.remove("token");
        prefs.remove("user");
        StaticVarMethod.navKey.currentState?.pushReplacement(new MaterialPageRoute(builder: (context) => SubSigninPage()));
      }

      if (e.type == DioException.badResponse) {
        int? statusCode = e.response!.statusCode;
        if (statusCode == STATUS_NOT_FOUND) {
          throw "Api not found";
        } else if (statusCode == STATUS_INTERNAL_ERROR) {
          throw "Internal Server Error";
        } else {
          throw e.message.toString();
        }
      } else if (e.type == DioException.connectionTimeout) {
        throw e.message.toString();
      }
      throw connErr;
    } finally {
      dio.close();
    }
  }

  Future<Response> postConnect(apiUrl, data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    CancelToken cancelToken = CancelToken();

    var fullUrl = _url + apiUrl;
    // print('fullUrl : ' + fullUrl.toString());
    // print('postData : ' + data.toString());
    try {
      // dio.options.headers['content-Type'] = 'application/x-www-form-urlencoded';

      dio.options.headers['content-Type'] = 'application/json';
      dio.options.connectTimeout = Duration(seconds: 60);
      dio.options.receiveTimeout = Duration(seconds: 60);
      // --------------------
      String token = prefs.getString('token') ?? '';
      dio.options.headers["Accept"] = "application/json";
      dio.options.headers["app-token"] = prefs.getString('AppToken') ?? '';
      dio.options.headers["app-id"] = prefs.getString('AppId') ?? '';
      dio.options.headers["fcm-token"] = prefs.getString('fcmToken') ?? '';

      UserModel userCls;
      final userJson = prefs.getString('user') ?? '';
      if (userJson.isNotEmpty) {
        Map<String, dynamic> map = jsonDecode(userJson);
        userCls = UserModel.fromJson(map);
        dio.options.headers["X-AppVersionBuilt"] = AppSettings.AppVersionBuilt;
        dio.options.headers["X-user-kodkawasan"] = userCls.userUser_Kod_Kawasan;
        dio.options.headers["X-user-kodkeselamatan"] = userCls.userUser_Kod_Keselamatan;
        if (AppSettings.AppKey == 'myJR') {
          dio.options.headers["X-user-kodkeselamatanSub"] = '201myjr';
          dio.options.headers["X-user-kodkeselamatanSubNama"] = '201myjr';
        } else {
          if (AppSettings.Auth_Type == 'PIN') {
            dio.options.headers["X-user-kodkeselamatanSub"] = userCls.userUser_Kod_KeselamatanSub;
            dio.options.headers["X-user-kodkeselamatanSubNama"] = userCls.userUser_Kod_KeselamatanSubNama;
          } else {
            dio.options.headers["X-user-kodkeselamatanSub"] = '';
            dio.options.headers["X-user-kodkeselamatanSubNama"] = '';
          }
        }
      }

      if (token.isNotEmpty) {
        // print(token);
        dio.options.headers["Authorization"] = "Bearer " + token;
      }
      // --------------------
      var response = await dio.post(fullUrl, data: data, cancelToken: cancelToken);

      String newToken = response.headers.value("new-token") ?? "";
      String isDDay = response.headers.value("is-dday") ?? '0';

      if (newToken.isNotEmpty) {
        // print("New Token: " + newToken);
        prefs.setString('token', newToken);
      }

      return response;
    } on DioError catch (e) {
      //print(e.toString()+' | '+url.toString());

      if ((e.response!.statusCode) == 401) {
        print("401");
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.remove("token");
        prefs.remove("user");
        StaticVarMethod.navKey.currentState?.pushReplacement(new MaterialPageRoute(builder: (context) => SubSigninPage()));
      }

      if (e.type == DioException.badResponse) {
        int? statusCode = e.response!.statusCode;
        if (statusCode == STATUS_NOT_FOUND) {
          throw "Api not found";
        } else if (statusCode == STATUS_INTERNAL_ERROR) {
          throw "Internal Server Error";
        } else {
          throw e.message.toString();
        }
      } else if (e.type == DioException.connectionTimeout) {
        throw e.message.toString();
      }
      throw connErr;
    } finally {
      dio.close();
    }
  }

  Future<bool> refreshToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String fcmToken = prefs.getString('fcmToken') ?? '';

    var postdata = {"fcm_token": fcmToken};
    final response = await postConnect('refresh', postdata);
    if (response.data['success'] == true) {
      final token = response.data['token'];
      final isDDay = response.data['isDDay'];
      final userModel = (response.data as Map<String, dynamic>)['user'];
      // -----
      Map<String, dynamic> map = userModel;
      String user = jsonEncode(map);

      final SharedPreferences prefs = await SharedPreferences.getInstance();

      await prefs.setString('token', token);
      await prefs.setBool('isDDay', isDDay);
      await prefs.setString('user', user);

      return true;
    } else {
      return false;
    }
  }
}
