import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:new_app/data/models/user_model.dart';

Future<UserModel> fetchDataFromNetwork() async {
  Response response;

  // perform the connection check

  if (await InternetConnectionChecker().hasConnection) {
    try {
      response = await Dio().get('https://randomuser.me/api/?results=100');

      debugPrint(response.toString());
    } catch (e) {
      debugPrint(e.toString());
      return UserModel.withError('Server Error Occured');
    }

    int? statusCode = response.statusCode;

    if (statusCode == 200) {
      return UserModel.fromJson(response.data);
    } else {
      return UserModel.withError('Error Occured while fetching the data');
    }
  }
  return UserModel.withError('Check the network connection');
}
