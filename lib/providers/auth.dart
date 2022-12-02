import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/models/http_exception.dart';

class Auth with ChangeNotifier {
  String? _token;
  String? _userId;
  DateTime? _expiryDate;
  Timer? _authTimer;

  bool get isAuth {
    return token != null;
  }

  String? get userId {
    return _userId;
  }

  String? get token {
    if (_expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now()) &&
        _token != null) {
      return _token!;
    } else {
      return null;
    }
  }

  Future<void> _authenticate(Map authData, String urlSegment) async {
    try {
      String url =
          'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyB-CUIiRoiiqrIDnwAoIvU422IYJh_BdOE';
      http.Response response = await http.post(
        Uri.parse(url),
        body: json.encode({
          'email': authData['email'],
          'password': authData['password'],
          'returnSecureToken': true,
        }),
      );
      final resData = json.decode(response.body);

      if (resData['error'] != null) {
        throw HttpException(resData['error']['message']);
      }

      _token = resData['idToken'];
      _expiryDate = DateTime.now()
          .add(Duration(seconds: int.parse(resData['expiresIn'])));
      _userId = resData['localId'];

      notifyListeners();
      // _autoLogout();
      SharedPreferences _sharedPreferences =
          await SharedPreferences.getInstance();
      String allData = json.encode({
        'token': _token,
        'expiryDate': _expiryDate!.toIso8601String(),
        'userId': _userId,
      });
      print(allData);
      print('+++++++==SharedPrefrences===+++++++');
      _sharedPreferences.setString('allData', allData);
    } catch (error) {
      rethrow;
    }
  }

  Future<void> signUp(Map authDataToSignUp) async {
    return _authenticate(authDataToSignUp, 'signUp');
  }

  Future<void> signIn(Map authDataToSignIn) async {
    return _authenticate(authDataToSignIn, 'signInWithPassword');
  }

  Future<bool> tryAutoLogin() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    if (!sharedPreferences.containsKey('allData')) {
      return false;
    }
    var extractedData =
        json.decode(sharedPreferences.getString('allData').toString())
            as Map<String, dynamic>;
    final expiryDataFromSharedPref =
        DateTime.parse(extractedData['expiryDate'].toString());
    if (expiryDataFromSharedPref.isBefore(DateTime.now())) return false;
    _token = extractedData['token'];
    _userId = extractedData['userId'];
    _expiryDate = expiryDataFromSharedPref;
    notifyListeners();
    // _autoLogout();
    return true;
  }

  logout() async {
    _token = null;
    _expiryDate = null;
    _userId = null;
    if (_authTimer != null) {
      _authTimer!.cancel();
      _authTimer = null;
    }
    notifyListeners();
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.clear();
  }

  // _autoLogout() {
  //   if (_authTimer != null) {
  //     _authTimer!.cancel();
  //   }
  //   int timeToExpiry = _expiryDate!.difference(DateTime.now()).inSeconds;
  //   _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  // }
}
