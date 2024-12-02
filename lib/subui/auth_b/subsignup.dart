import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';

import '../../onboarding1.dart';
import '../../subconfig/AppSettings.dart';
import '../../subdata/model/TapBizUIContent_model.dart';
import '../../subdata/network/api_provider.dart';
import '../../subdata/repository/authentication_repository.dart';
import '../../sublogic/bloc/logup/logup_bloc.dart';
import '../reusable/cache_image_network.dart';
import 'subsignin.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:universal_io/io.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SubSignupPage extends StatefulWidget {
  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => SubSignupPage());
  }

  @override
  _SubSignupPageState createState() => _SubSignupPageState();
}

class _SubSignupPageState extends State<SubSignupPage> {
  String UIimageURL = 'https://storage.googleapis.com/tapbiz/logo/LOGO%20tapbiz%20putih_%23f78d1e-02H100.png';
  bool _obscureText = true;

  var loading = false;

  List<TapBizUIContentModel> listUI = [];
  int listUICount = 0;

  var _passwordVisible = false;

  @override
  void initState() {
    _passwordVisible = false;
    _listDb_UI();
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
                  autoPlay: (listUI.length>1)?true:false,
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
                  // create form logup
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
                        SizedBox(
                          height: 10,
                        ),
                        Center(
                          child: Text(
                            'CREATE ACCOUNT',
                            style: TextStyle(color: AppSettings.ColorMain, fontSize: 18, fontWeight: FontWeight.w900),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                            margin: EdgeInsets.fromLTRB(24, 0, 24, 20),
                            child: BlocProvider(
                              create: (context) {
                                return LogupBloc(
                                  authenticationRepository: RepositoryProvider.of<AuthenticationRepository>(context),
                                );
                              },
                              child: Column(
                                children: <Widget>[
                                  // ------------
                                  BlocListener<LogupBloc, LogupState>(
                                    listener: (context, state) {
                                      if (state.status.isFailure) {
                                        ScaffoldMessenger.of(context)
                                          ..hideCurrentSnackBar()
                                          ..showSnackBar(
                                            const SnackBar(content: Text('Registration Failed. Check Activation Code. Please try again')),
                                          );
                                      }
                                    },
                                    child: Align(
                                      alignment: const Alignment(0, -1 / 3),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          _User_NameInput(),
                                          const Padding(padding: EdgeInsets.all(2)),
                                          _User_EmailInput(),
                                          const Padding(padding: EdgeInsets.all(2)),
                                          _User_PasswordInput(),
                                          const Padding(padding: EdgeInsets.all(8)),
                                          _User_ActivationCodeInput(),
                                          const Padding(padding: EdgeInsets.all(2)),
                                          _LogupButton(),
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

  Widget _User_PasswordInput() {
    return BlocBuilder<LogupBloc, LogupState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return TextField(
          obscureText: !_passwordVisible,
          enableSuggestions: false,
          autocorrect: false,
          key: const Key('logupForm_passwordInput_textField'),
          onChanged: (password) => context.read<LogupBloc>().add(LogupPasswordChanged(password)),
          decoration: InputDecoration(
            labelText: 'Password',
            errorText: state.password.displayError != null ? 'invalid password' : null,
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
        );
      },
    );
  }
}

// ----------------------------Form Content
class _User_NameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LogupBloc, LogupState>(
      buildWhen: (previous, current) => previous.user_Name != current.user_Name,
      builder: (context, state) {
        return TextField(
          key: const Key('logupForm_user_NameInput_textField'),
          onChanged: (user_Name) => context.read<LogupBloc>().add(LogupUser_NameChanged(user_Name)),
          decoration: InputDecoration(
            labelText: 'Name',
            errorText: state.user_Name.displayError != null ? 'invalid user_Name' : null,
          ),
        );
      },
    );
  }
}

class _User_ActivationCodeInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LogupBloc, LogupState>(
      buildWhen: (previous, current) => previous.user_Name != current.user_Name,
      builder: (context, state) {
        return TextField(
          key: const Key('logupForm_ActivationCodeInput_textField'),
          onChanged: (ActivationCode) => context.read<LogupBloc>().add(LogupActivationCodeChanged(ActivationCode)),
          decoration: InputDecoration(
            labelText: 'Activation Code',
            errorText: state.user_Name.displayError != null ? 'invalid Activation Code' : null,
          ),
        );
      },
    );
  }
}


class _User_EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LogupBloc, LogupState>(
      buildWhen: (previous, current) => previous.user_Email != current.user_Email,
      builder: (context, state) {
        return TextField(
          key: const Key('logupForm_user_EmailInput_textField'),
          onChanged: (user_Email) => context.read<LogupBloc>().add(LogupUser_EmailChanged(user_Email)),
          decoration: InputDecoration(
            labelText: 'Email/Username',
            errorText: state.user_Email.displayError != null ? 'invalid user_Email' : null,
          ),
        );
      },
    );
  }
}

// class _User_PasswordInput extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<LogupBloc, LogupState>(
//       buildWhen: (previous, current) => previous.password != current.password,
//       builder: (context, state) {
//         return TextField(
//           obscureText: true,
//           enableSuggestions: false,
//           autocorrect: false,
//           key: const Key('logupForm_passwordInput_textField'),
//           onChanged: (password) => context.read<LogupBloc>().add(LogupPasswordChanged(password)),
//           decoration: InputDecoration(
//             labelText: 'Password',
//             errorText: state.password.displayError != null ? 'invalid password' : null,
//           ),
//         );
//       },
//     );
//   }
// }

class _LogupButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LogupBloc, LogupState>(
      builder: (context, state) {
        return state.status.isInProgress
            ? const CircularProgressIndicator()
            : SizedBox(
                width: double.maxFinite,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: AppSettings.ColorMain),
                  key: const Key('logupForm_continue_raisedButton'),
                  onPressed: state.isValid
                      ? () {
                          context.read<LogupBloc>().add(LogupSubmitted(
                                activationCode: state.activationCode.value,
                                user_Name: state.user_Name.value,
                                user_Email: state.user_Email.value,
                                password: state.password.value,
                              ));
                        }
                      : null,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Text(
                      'Create Account',
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
