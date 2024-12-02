import 'package:TapBiz/subui/auth_b/subsignupdate.dart';
import 'package:fluttericon/typicons_icons.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';

import '../../subconfig/AppSettings.dart';
import '../../subdata/repository/authentication_repository.dart';
import '../../sublogic/bloc/logupdate/logupdate_bloc.dart';
import 'subsignin.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:universal_io/io.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SubSignupdatePasswordOTPPage extends StatefulWidget {
  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => SubSignupdatePasswordOTPPage());
  }

  @override
  _SubSignupdatePasswordOTPPageState createState() => _SubSignupdatePasswordOTPPageState();
}

class _SubSignupdatePasswordOTPPageState extends State<SubSignupdatePasswordOTPPage> {
  bool _obscureText = true;

  // Color _gradientTop = Color(0xFF039be6);
  // Color _gradientBottom = Color(0xFF0299e2);
  // Color _mainColor = Color(0xFF0181cc);
  // Color _underlineColor = Color(0xFFCCCCCC);
  var _formKey = GlobalKey<FormState>();

  TextEditingController dataObjController = TextEditingController();
  String dataObj = '';

  String? actionQuery;
  String? actionTextQuery;
  String? userQueryActionFieldName;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: Platform.isIOS ? SystemUiOverlayStyle.light : SystemUiOverlayStyle(statusBarIconBrightness: Brightness.light),
          child: Stack(
            children: <Widget>[
              // top blue background gradient
              Container(
                height: MediaQuery.of(context).size.height / 3.5,
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                  Colors.white, Colors.white
                  // AppSettings.ColorGradientTop,
                  // AppSettings.ColorBradientBottom
                ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
              ),
              // set your logo here
              Column(
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(0, MediaQuery.of(context).size.height / 15, 0, 0),
                    alignment: Alignment.topCenter,
                    child: Column(
                      children: [
                        Image.asset('${AppSettings.AppLogo}', height: 150),
                        // SizedBox(
                        //   height: 10,
                        // ),
                        // Text(
                        //   '{ ${AppSettings.AppKey} ${AppSettings.AppKey2} }',
                        //   style: TextStyle(
                        //       fontSize: 25,
                        //       fontWeight: FontWeight.bold,
                        //       color: Colors.black),
                        // ),
                      ],
                    ),
                  )
                ],
              ),
              ListView(
                children: <Widget>[
                  // create form logupdate
                  Card(
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
                                      'Forgot Password',
                                      style: TextStyle(color: AppSettings.ColorMain, fontSize: 18, fontWeight: FontWeight.w900),
                                    ),
                                  ),

                                  SizedBox(
                                    height: 16,
                                  ),
                                  // Card(
                                  //   elevation: 4.0,
                                  //   color: Colors.white,
                                  //   margin: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
                                  //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  //   child: Container(
                                  //     padding: EdgeInsets.only(left: 15, top: 10, bottom: 10),
                                  //     width: MediaQuery.of(context).size.width,
                                  //     child: Column(
                                  //       crossAxisAlignment: CrossAxisAlignment.start,
                                  //       children: <Widget>[
                                  //         Column(
                                  //           children: [
                                  //             Row(
                                  //               children: <Widget>[
                                  //                 Padding(
                                  //                   padding: const EdgeInsets.only(right: 10),
                                  //                   child: Icon(
                                  //                     Icons.check_circle,
                                  //                     color: Colors.green,
                                  //                   ),
                                  //                 ),
                                  //                 Text(
                                  //                   userNoTel != null ? userNoTel : '',
                                  //                   textAlign: TextAlign.left,
                                  //                   style: TextStyle(
                                  //                     color: Color(0xFF9b9b9b),
                                  //                     fontSize: 15.0,
                                  //                     decoration: TextDecoration.none,
                                  //                     fontWeight: FontWeight.normal,
                                  //                   ),
                                  //                 ),
                                  //                 Spacer(),
                                  //                 Column(
                                  //                   children: [
                                  //                     (otpRun == "0" || otpRun == "2")
                                  //                         ? Padding(
                                  //                             padding: const EdgeInsets.all(10.0),
                                  //                             child: FlatButton(
                                  //                               child: Padding(
                                  //                                 padding: EdgeInsets.only(top: 8, bottom: 8, left: 10, right: 10),
                                  //                                 child: Text(
                                  //                                   //_isLoading? 'Loging...' : 'Login',
                                  //                                   (otpRun == "0")
                                  //                                       ? 'Get OTP'
                                  //                                       : (otpRun == "2")
                                  //                                           ? 'Resend OTP'
                                  //                                           : '',
                                  //                                   textDirection: TextDirection.ltr,
                                  //                                   style: TextStyle(
                                  //                                     color: Colors.black,
                                  //                                     fontSize: 12.0,
                                  //                                     decoration: TextDecoration.none,
                                  //                                     fontWeight: FontWeight.normal,
                                  //                                   ),
                                  //                                 ),
                                  //                               ),
                                  //                               color: Colors.green,
                                  //                               disabledColor: Colors.white,
                                  //                               shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(20.0)),
                                  //                               // onPressed: _getOTP,
                                  //                             ),
                                  //                           )
                                  //                         : Padding(
                                  //                             padding: const EdgeInsets.all(10.0),
                                  //                             child: FlatButton(
                                  //                               child: Padding(
                                  //                                 padding: EdgeInsets.only(top: 8, bottom: 8, left: 10, right: 10),
                                  //                                 child: Row(
                                  //                                   children: [
                                  //                                     Icon(Icons.lock_clock),
                                  //                                     Text(
                                  //                                       //_isLoading? 'Loging...' : 'Login',
                                  //                                       '$_start',
                                  //                                       textDirection: TextDirection.ltr,
                                  //                                       style: TextStyle(
                                  //                                         color: Colors.black,
                                  //                                         fontSize: 12.0,
                                  //                                         decoration: TextDecoration.none,
                                  //                                         fontWeight: FontWeight.normal,
                                  //                                       ),
                                  //                                     ),
                                  //                                   ],
                                  //                                 ),
                                  //                               ),
                                  //                               color: Colors.grey,
                                  //                               disabledColor: Colors.white,
                                  //                               shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(20.0)),
                                  //                               // onPressed: _getOTP,
                                  //                             ),
                                  //                           ),
                                  //                   ],
                                  //                 ),
                                  //               ],
                                  //             ),
                                  //             InkWell(
                                  //               child: Text('Cancel'),
                                  //               onTap: () {
                                  //                 Navigator.push(context, new MaterialPageRoute(builder: (context) => SubSignupdatePage()));
                                  //               },
                                  //             ),
                                  //           ],
                                  //         ),
                                  //       ],
                                  //     ),
                                  //   ),
                                  // ),
                                  // SizedBox(height: 16.0),

                                  // ------------
                                  Card(
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
                                            'Email Varification',
                                            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text('Enter the code sent to: '),
                                              // Text(userNoTel != null ? userNoTel : '',),
                                            ],
                                          ),
                                          Text(''),
                                          OTPTextField(
                                            length: 6,
                                            width: MediaQuery.of(context).size.width,
                                            fieldWidth: 40,
                                            style: TextStyle(fontSize: 17),
                                            textFieldAlignment: MainAxisAlignment.spaceAround,
                                            fieldStyle: FieldStyle.box,
                                            onCompleted: (pin) {
                                              // _verifyOTP(pin, userNoTel);
                                              // _resetPassword(pin);
                                              //print(pin);
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  // ------------
                                ],
                              ),
                            )),
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
                                      ' Back to Log In Screen',
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
                          Text(
                            '${AppSettings.AppPoweredBy}',
                            style: TextStyle(color: AppSettings.ColorUnderline),
                          ),
                          Text(
                            '(B)',
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
    dataObj = dataObjController.text;
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // SizedBox(height: 30),
          // Text('$userQueryActionField'),
          Padding(
            padding: EdgeInsets.only(top: 30.0, bottom: 5.0),
            child: TextFormField(
              controller: dataObjController,
              validator: (value) => value!.isEmpty ? 'Enter $userQueryActionFieldName' : null,
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
                      // if (_formKey.currentState!.validate()) {
                      //   if (actionQuery == 'AddGroup') {
                      //     _addDb_Group();
                      //   }
                      //   if (actionQuery == 'AddCard') {
                      //     _addDb_UserDemo();
                      //   }
                      // }
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

  updateObj() {
    setState(() {
      dataObj = dataObjController.text;
    });
  }
}

// ----------------------------Form Content

class _User_EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LogupdateBloc, LogupdateState>(
      buildWhen: (previous, current) => previous.user_IC != current.user_IC,
      builder: (context, state) {
        return TextField(
          key: const Key('logupdateForm_user_ICInput_textField'),
          onChanged: (user_IC) => context.read<LogupdateBloc>().add(LogupdateUser_ICChanged(user_IC)),
          decoration: InputDecoration(
            labelText: 'Email',
            errorText: state.user_IC.displayError != null ? 'invalid user_IC' : null,
          ),
        );
      },
    );
  }
}

class _LogupdateButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LogupdateBloc, LogupdateState>(
      builder: (context, state) {
        return state.status.isInProgress
            ? const CircularProgressIndicator()
            : SizedBox(
                width: double.maxFinite,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: AppSettings.ColorMain),
                  key: const Key('logupdateForm_continue_raisedButton'),
                  onPressed: state.isValid
                      ? () {
                          context.read<LogupdateBloc>().add(LogupdateSubmitted(
                                user_IC: state.user_IC.value,
                              ));
                        }
                      : null,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Text(
                      'Next',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              );
      },
    );
  }
}
// ----------------------------Form Content
