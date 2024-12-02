import 'package:TapBiz/subui/auth_b/subsignupdatePasswordOTP.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:fluttericon/typicons_icons.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';

import '../../subconfig/AppSettings.dart';
import '../../subdata/model/TapBizUIContent_model.dart';
import '../../subdata/network/api_provider.dart';
import '../../subdata/repository/authentication_repository.dart';
import '../../sublogic/bloc/logupdate/logupdate_bloc.dart';
import '../reusable/cache_image_network.dart';
import 'subsignin.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:universal_io/io.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SubSignupdatePage extends StatefulWidget {
  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => SubSignupdatePage());
  }

  @override
  _SubSignupdatePageState createState() => _SubSignupdatePageState();
}

class _SubSignupdatePageState extends State<SubSignupdatePage> {
  String UIimageURL = 'https://storage.googleapis.com/tapbiz/logo/LOGO%20tapbiz%20putih_%23f78d1e-02H100.png';
  bool _obscureText = true;

  // Color _gradientTop = Color(0xFF039be6);
  // Color _gradientBottom = Color(0xFF0299e2);
  // Color _mainColor = Color(0xFF0181cc);
  // Color _underlineColor = Color(0xFFCCCCCC);
  var _formKey = GlobalKey<FormState>();

  TextEditingController dataObjController = TextEditingController();
  String dataObj = '';

  TextEditingController dataPasswordObjController = TextEditingController();
  String dataPasswordObj = '';

  String dataOTPObj = '';

  String? forgotPassword_Status;

  String? actionQuery;
  String? actionTextQuery;
  String? userQueryActionFieldName;

  var loading = false;
  

  List<TapBizUIContentModel> listUI = [];
  int listUICount = 0;

  var _passwordVisible = false;

  
  @override
  void initState() {
    _passwordVisible = false;
    _listDb_UI();
    // dataObjController.text = 'buck769@gmail.com';
    // actionQuery = 'FormOTP';
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<Null> _listDb_UI() async {
    if (mounted) {
      setState(() {
        loading = true;
      });
    }
    late var postdata;
    late String apiUrl;

    // postdata = {Userid};
    postdata = {};
    apiUrl = 'UI/listUI_By_theme_bg';
    final response = await ApiProvider().postConnect(apiUrl, postdata);
    if (response.statusCode == 200) {
      //--- fetchdata
      final UIList_By_theme_bg = (response.data as Map<String, dynamic>)['UIList_By_theme_bg'];
      //--- Set State
      if (mounted) {
        setState(() {
          List<TapBizUIContentModel> _UIList_By_theme_bg = [];
          for (int i = 0; i < UIList_By_theme_bg.length; i++) _UIList_By_theme_bg.add(TapBizUIContentModel.fromJson(UIList_By_theme_bg[i]));
          listUI = _UIList_By_theme_bg;
          listUICount = _UIList_By_theme_bg.length;

          loading = false;
        });
      }
      // --- Set State

      //--------------------------------------------------------------
    } else {
      // --- DialogBox
      // if (_showAlertDialogStatus == 0) {
      //   _showAlertDialog('Status:', 'Check Connection');
      //   setState(() {
      //     _showAlertDialogStatus = 1;
      //   });
      // }
      // --- DialogBox
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: Platform.isIOS ? SystemUiOverlayStyle.light : SystemUiOverlayStyle(statusBarIconBrightness: Brightness.light),
          child: Stack(
            children: <Widget>[
              CarouselSlider(
                items: listUI
                    .map((item) => ClipPath(
                          clipper: WaveClipperOne(),
                          child: Container(
                            decoration: BoxDecoration(
                                image: DecorationImage(opacity: double.parse(item.UIimageOpacity), image: NetworkImage(item.UIimageURL)),
                                gradient: LinearGradient(colors: [Color(int.parse(item.UIColorBg1)), Color(int.parse(item.UIColorBg2))], begin: Alignment.centerLeft, end: Alignment.centerRight)),
                          ),
                        ))
                    .toList(),
                options: CarouselOptions(
                  height: MediaQuery.of(context).size.height / 2.5,
                  aspectRatio: 2,
                  viewportFraction: 1.0,
                  autoPlay: (listUI.length > 1) ? true : false,
                  autoPlayInterval: Duration(seconds: 6),
                  autoPlayAnimationDuration: Duration(milliseconds: 300),
                  enlargeCenterPage: false,
                ),
              ),
              Column(
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(0, MediaQuery.of(context).size.height / 20, 0, 0),
                    alignment: Alignment.topCenter,
                    child: Column(
                      children: [
                        Column(
                          children: [
                            buildCacheNetworkImage(height: 60, url: UIimageURL),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Text('Create Account? '),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
              ListView(
                children: <Widget>[
                  // create form logupdate
                  Card(
                    surfaceTintColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 5,
                    margin: EdgeInsets.fromLTRB(32, MediaQuery.of(context).size.height / 3.5 - 72, 32, 0),
                    color: Colors.white,
                    child: Column(
                      children: [
                        // Text(
                        //   'Version: ${AppSettings.AppVersion}',
                        //   style: TextStyle(fontSize: 14),
                        // ),
                        Container(
                            margin: EdgeInsets.fromLTRB(24, 0, 24, 20),
                            child: BlocProvider(
                              create: (context) {
                                return LogupdateBloc(
                                  authenticationRepository: RepositoryProvider.of<AuthenticationRepository>(context),
                                );
                              },
                              child: Column(
                                children: <Widget>[
                                  SizedBox(
                                    height: 40,
                                  ),
                                  Center(
                                    child: Text(
                                      'Reset/Forgot Password',
                                      style: TextStyle(color: AppSettings.ColorMain, fontSize: 18, fontWeight: FontWeight.w900),
                                    ),
                                  ),
                                  // Center(
                                  //   child: Text(
                                  //     'Kod Kawasan & Kod Keselamatan',
                                  //     style: TextStyle(
                                  //         color: AppSettings.ColorMain,
                                  //         fontSize: 18,
                                  //         fontWeight: FontWeight.w900),
                                  //   ),
                                  // ),

                                  // ------------
                                  // Text('$actionQuery'),
                                  (actionQuery == null) ? _addForm() : Container(),
                                  (actionQuery == 'FormOTP') ? _addFormOTP() : Container()
                                  // BlocListener<LogupdateBloc, LogupdateState>(
                                  //   listener: (context, state) {
                                  //     if (state.status.isFailure) {
                                  //       ScaffoldMessenger.of(context)
                                  //         ..hideCurrentSnackBar()
                                  //         ..showSnackBar(
                                  //           const SnackBar(content: Text('Pendaftaran Tidak Berjaya. Semak Kod Kawasan, Kod Keselamatan dan PIN. Sila cuba semula')),
                                  //         );
                                  //     }
                                  //   },
                                  //   child: Align(
                                  //     alignment: const Alignment(0, -1 / 3),
                                  //     child: Column(
                                  //       mainAxisSize: MainAxisSize.min,
                                  //       children: [
                                  //         _User_EmailInput(),
                                  //         const Padding(padding: EdgeInsets.all(2)),
                                  //         _LogupdateButton(),
                                  //       ],
                                  //     ),
                                  //   ),
                                  // ),
                                  // ------------
                                ],
                              ),
                            )),
                        (actionQuery != 'FormOTP')
                            ? Container()
                            : SizedBox(
                                height: 20,
                              ),
                        Container(
                          margin: EdgeInsets.fromLTRB(56, 0, 24, 20),
                          child: SizedBox(
                            width: double.maxFinite,
                            child: Center(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context) => SubSigninPage()));
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(Icons.arrow_back, size: 16, color: AppSettings.ColorMain),
                                    Text(
                                      ' Back to Sign In Screen',
                                      style: TextStyle(color: AppSettings.ColorMain, fontWeight: FontWeight.w700),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  // create sign up link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Text(
                            'Powered By',
                            style: TextStyle(color: AppSettings.ColorUnderline),
                          ),
                          Image.asset('${AppSettings.PoweredBy}', height: 40),
                          Text(
                            '${AppSettings.AppPoweredBy2}',
                            style: TextStyle(color: AppSettings.ColorUnderline),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              )
            ],
          ),
        ));
  }

  Widget _addForm() {
    userQueryActionFieldName = 'Email';
    dataObj = dataObjController.text;
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Please enter your registered email',
            style: TextStyle(fontSize: 12),
          ),
          SizedBox(
            height: 16,
          ),
          Padding(
            padding: EdgeInsets.only(top: 30.0, bottom: 5.0),
            child: TextFormField(
              controller: dataObjController,
              // validator: (value) => value!.isEmpty ? 'Enter $userQueryActionFieldName' : null,
              validator: (value) => EmailValidator.validate(value!) ? null : "Please enter a valid email",
              onFieldSubmitted: (value) {
                if (_formKey.currentState!.validate()) {
                  // _updateHadir(dataICNOSIRI!);
                }
              },
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(8.0),
                labelText: '$userQueryActionFieldName',
                // border: OutlineInputBorder(
                //   borderRadius: BorderRadius.circular(5.0),
                // ),
              ),
              onChanged: (value) {
                updateObj();
              },
            ),
          ),
          (actionTextQuery == null) ? Container() : Text('$actionTextQuery'),
          Text('  '),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 25,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith((states) {
                        return AppSettings.ColorMain;
                        // return Colors.grey;
                      }),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Next", style: TextStyle(color: Colors.white, fontSize: 12.0, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    onPressed: () {
                      // Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context) => SubSignupdatePasswordOTPPage()));
                      if (_formKey.currentState!.validate()) {
                        setState(() {});
                        _sendOTPToEmail();
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _addFormOTP() {
    userQueryActionFieldName = 'Email';
    dataObj = dataObjController.text;
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // SizedBox(height: 30),
          // Text('$userQueryActionField'),
          (forgotPassword_Status == null || forgotPassword_Status == 'OTP Invalid')
              ? Card(
                  elevation: 4.0,
                  color: Colors.white,
                  margin: EdgeInsets.only(left: 4, right: 4),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Email Verification',
                          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Your temporary 4-digit password has been sent to your registered email address.', style: TextStyle(fontSize: 12)),
                                  Text(dataObj != null ? dataObj : '', style: TextStyle(fontSize: 12)),
                                ],
                              ),
                            ),
                            Spacer(),
                            Expanded(
                              flex: 2,
                              child: (forgotPassword_Status == null || forgotPassword_Status == 'OTP Invalid')
                                  ? Card(
                                      color: Colors.white,
                                      surfaceTintColor: Colors.white,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    actionQuery = null;
                                                  });
                                                },
                                                child: Column(
                                                  children: [
                                                    Text(
                                                      'Resend',
                                                      style: TextStyle(fontSize: 12, color: AppSettings.ColorMain, fontWeight: FontWeight.w700),
                                                    ),
                                                    Text(
                                                      'code',
                                                      style: TextStyle(fontSize: 12, color: AppSettings.ColorMain, fontWeight: FontWeight.w700),
                                                    ),
                                                    Text(
                                                      'again',
                                                      style: TextStyle(fontSize: 12, color: AppSettings.ColorMain, fontWeight: FontWeight.w700),
                                                    ),
                                                  ],
                                                )),
                                          ],
                                        ),
                                      ),
                                    )
                                  : Container(),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        OTPTextField(
                          length: 4,
                          width: MediaQuery.of(context).size.width,
                          fieldWidth: 40,
                          style: TextStyle(fontSize: 17),
                          textFieldAlignment: MainAxisAlignment.spaceAround,
                          fieldStyle: FieldStyle.box,
                          onCompleted: (pin) {
                            dataOTPObj = pin;
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          'Enter your new Password',
                          style: TextStyle(fontSize: 12),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 8.0, bottom: 5.0),
                          child: TextFormField(
                            // obscureText: true,
                            obscureText: !_passwordVisible,
                            controller: dataPasswordObjController,
                            validator: (value) => value!.isEmpty ? 'Enter valid Password' : null,
                            // validator: (value) => EmailValidator.validate(value!) ? null : "Please enter a valid email",
                            onFieldSubmitted: (value) {
                              if (_formKey.currentState!.validate()) {
                                // _updateHadir(dataICNOSIRI!);
                              }
                            },
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(8.0),
                              labelText: 'New Password',
                              // border: OutlineInputBorder(
                              //   borderRadius: BorderRadius.circular(5.0),
                              // ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _passwordVisible ? Icons.visibility : Icons.visibility_off,
                                  color: _passwordVisible ? AppSettings.ColorMain : Colors.black,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _passwordVisible = !_passwordVisible;
                                  });
                                },
                              ),
                            ),
                            onChanged: (value) {
                              updatePasswordObj();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : Container(),
          Text('  '),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              (forgotPassword_Status == null) ? Container() : Text('$forgotPassword_Status'),
            ],
          ),
          Text('  '),
          (forgotPassword_Status == null || forgotPassword_Status == 'OTP Invalid')
              ? Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 25,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.resolveWith((states) {
                              return AppSettings.ColorMain;
                              // return Colors.grey;
                            }),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Verify", style: TextStyle(color: Colors.white, fontSize: 12.0, fontWeight: FontWeight.bold)),
                            ],
                          ),
                          onPressed: () {
                            _updateDb_UserProfile(dataObj, dataOTPObj, dataPasswordObj);
                          },
                        ),
                      ),
                    ),
                  ],
                )
              : Container(),
        ],
      ),
    );
  }

  updateObj() {
    setState(() {
      dataObj = dataObjController.text;
    });
  }

  updatePasswordObj() {
    setState(() {
      dataPasswordObj = dataPasswordObjController.text;
    });
  }

  Future<Null> _sendOTPToEmail() async {
    if (mounted) {
      setState(() {
        loading = true;
      });
    }
    late var postdata;
    late String apiUrl;

    postdata = {"checkcode": dataObj, "email": dataObj};
    apiUrl = 'sendotp';
    final response = await ApiProvider().postConnect(apiUrl, postdata);
    if (response.statusCode == 200) {
      //--- fetchdata
      //--- Set State
      if (mounted) {
        if (response.data['success'] == true) {
          actionQuery = 'FormOTP';
        } else {
          _showAlertDialog(context, 'Status:', 'Your e-mail address is not registered. Please use the email that was registered or click register to register a new account.');
        }

        setState(() {
          loading = false;
        });
      }
      // --- Set State

      //--------------------------------------------------------------
    } else {
      // --- DialogBox
      // if (_showAlertDialogStatus == 0) {
      // _showAlertDialog(context, 'Status:', 'Check Connection');
      // setState(() {
      //   _showAlertDialogStatus = 1;
      // });
      // }
      // --- DialogBox
    }
  }

  Future<Null> _updateDb_UserProfile(String dataObj, String dataOTPObj, String dataPasswordObj) async {
    if (mounted) {
      setState(() {
        loading = true;
      });
    }
    // late var postdata;
    late String apiUrl;
    FormData postdata = FormData.fromMap({"userId": '', "nedField": 'userUser_Password', "dataEmail": dataObj, "dataOTP": dataOTPObj, "dataPassword": dataPasswordObj});

    apiUrl = 'userPasswordEdit';
    final response = await ApiProvider().postConnect(apiUrl, postdata);
    if (response.statusCode == 200) {
      //--------------------------------------------------------------

      if (response.data['success'] == true) {
        print('Success');
        setState(() {
          forgotPassword_Status = 'New Password Updated';
        });
      } else {
        print('OTP Invalid');
        setState(() {
          forgotPassword_Status = 'OTP Invalid';
        });
      }
    } else {
      // --- DialogBox
      // if (_showAlertDialogStatus == 0) {
      //   _showAlertDialog('Status:', 'Check Connection');
      //   setState(() {
      //     _showAlertDialogStatus = 1;
      //   });
      // }
      // --- DialogBox
    }
  }

  void _showAlertDialog(BuildContext context, String title, String content) {
    // set up the buttons
    Widget cancelButton = TextButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: Text('No', style: TextStyle(color: AppSettings.SOFT_BLUE)));
    Widget continueButton = TextButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: Text('Yes', style: TextStyle(color: AppSettings.SOFT_BLUE)));
    Widget okButton = TextButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: Text('OK', style: TextStyle(color: AppSettings.SOFT_BLUE)));

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text('$title'),
      content: Text('$content'),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
