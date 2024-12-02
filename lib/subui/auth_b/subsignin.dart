import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:fluttericon/typicons_icons.dart';

import '../../onboarding1.dart';
import '../../subconfig/AppSettings.dart';
import '../../subdata/model/TapBizUIContent_model.dart';
import '../../subdata/network/api_provider.dart';
import '../../subdata/repository/authentication_repository.dart';
import '../../sublogic/bloc/login/login_bloc.dart';
import '../reusable/cache_image_network.dart';
import 'subsignup.dart';
import 'subsignupdate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:universal_io/io.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SubSigninPage extends StatefulWidget {
  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => SubSigninPage());
  }

  @override
  _SubSigninPageState createState() => _SubSigninPageState();
}

class _SubSigninPageState extends State<SubSigninPage> {
  String UIimageURL = 'https://storage.googleapis.com/tapbiz/logo/LOGO%20tapbiz%20putih_%23f78d1e-02H100.png';
  bool _obscureText = true;
  String? logintype = 'Main';
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
                            // Image.asset('${AppSettings.AppLogoAppBarTr}', height: 60),
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
                  (logintype == 'Main') ? _buildLoginMain() : Container(),
                  SizedBox(height: 20.0),
                  Container(
                    margin: EdgeInsets.fromLTRB(56, 0, 24, 20),
                    child: SizedBox(
                      width: double.maxFinite,
                      child: Row(
                        children: [
                          Spacer(),
                          Flexible(
                            flex: 3,
                            child: Wrap(
                              children: <Widget>[
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context) => Onboarding1Page(parentQuery: '')));
                                      },
                                      child: Row(
                                        children: [
                                          Icon(
                                            Typicons.home_outline,
                                            size: 24,
                                            color: AppSettings.ColorMain,
                                          ),
                                          Text(
                                            '  Home',
                                            style: TextStyle(fontSize: 20, color: AppSettings.ColorMain, fontWeight: FontWeight.w700),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Spacer(),
                          Flexible(
                            flex: 3,
                            child: Wrap(
                              children: <Widget>[
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(context, new MaterialPageRoute(builder: (context) => SubSignupPage()));
                                      },
                                      child: Text(
                                        'Register',
                                        style: TextStyle(fontSize: 20, color: AppSettings.ColorMain, fontWeight: FontWeight.w700),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Spacer(),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
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

  //-----------------------------
  Widget _buildLoginMain() {
    return Card(
      surfaceTintColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 5,
      margin: EdgeInsets.fromLTRB(32, MediaQuery.of(context).size.height / 3.5 - 72, 32, 0),
      color: Colors.white,
      child: Column(
        children: [
          Container(
              margin: EdgeInsets.fromLTRB(24, 0, 24, 20),
              child: BlocProvider(
                create: (context) {
                  return LoginBloc(
                    authenticationRepository: RepositoryProvider.of<AuthenticationRepository>(context),
                  );
                },
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: Text(
                        'SIGN IN',
                        style: TextStyle(color: AppSettings.ColorMain, fontSize: 18, fontWeight: FontWeight.w900),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),

                    // ------------
                    BlocListener<LoginBloc, LoginState>(
                      listener: (context, state) {
                        if (state.status.isFailure) {
                          ScaffoldMessenger.of(context)
                            ..hideCurrentSnackBar()
                            ..showSnackBar(
                              const SnackBar(content: Text('Invalid Access. Please try again')),
                            );
                        }
                      },
                      child: Align(
                        alignment: const Alignment(0, -1 / 3),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _User_EmailInput(),
                            const Padding(padding: EdgeInsets.all(2)),
                            _User_PasswordInput(),
                            SizedBox(
                              height: 20,
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(context, new MaterialPageRoute(builder: (context) => SubSignupdatePage()));
                                },
                                child: Text(
                                  'Reset/Forgot Password',
                                  style: TextStyle(color: AppSettings.ColorMain, fontWeight: FontWeight.w700),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 40,
                            ),
                            _LoginButton(),
                          ],
                        ),
                      ),
                    ),
                    // ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  //-----------------------------
  Widget _User_PasswordInput() {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) => previous.user_KodKawasan != current.user_KodKawasan,
      builder: (context, state) {
        return TextField(
          obscureText: !_passwordVisible,
          enableSuggestions: false,
          autocorrect: false,
          key: const Key('logupForm_user_KodKawasanInput_textField'),
          onChanged: (user_KodKawasan) => context.read<LoginBloc>().add(LoginUser_KodKawasanChanged(user_KodKawasan)),
          decoration: InputDecoration(
            labelText: 'Password',
            errorText: state.user_KodKawasan.displayError != null ? 'invalid password' : null,
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
class _User_EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) => previous.user_IC != current.user_IC,
      builder: (context, state) {
        return TextField(
          key: const Key('logupForm_user_ICInput_textField'),
          onChanged: (user_IC) => context.read<LoginBloc>().add(LoginUser_ICChanged(user_IC)),
          decoration: InputDecoration(
            labelText: 'Email/Username',
            errorText: state.user_IC.displayError != null ? 'invalid email' : null,
          ),
        );
      },
    );
  }
}




// class _User_PasswordInput extends StatelessWidget {
//   var _passwordVisible = false;
//   @override
//   Widget build(BuildContext context) {
//     return 
//     BlocBuilder<LoginBloc, LoginState>(
//       buildWhen: (previous, current) => previous.user_KodKawasan != current.user_KodKawasan,
//       builder: (context, state) {
//         return TextField(
//           obscureText: !_passwordVisible,
//           enableSuggestions: false,
//           autocorrect: false,
//           key: const Key('logupForm_user_KodKawasanInput_textField'),
//           onChanged: (user_KodKawasan) => context.read<LoginBloc>().add(LoginUser_KodKawasanChanged(user_KodKawasan)),
//           decoration: InputDecoration(
//             labelText: 'Password',
//             errorText: state.user_KodKawasan.displayError != null ? 'invalid password' : null,
//             suffixIcon: IconButton(
//               icon: Icon(
//                 _passwordVisible ? Icons.visibility : Icons.visibility_off,
//                 color: _passwordVisible ? AppSettings.ColorMain : Colors.black,
//               ),
//               onPressed: () {
//                 setState(() {
//                 _passwordVisible = !_passwordVisible;
//                 });
//               },
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

// class _User_PinInput extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<LoginBloc, LoginState>(
//       buildWhen: (previous, current) => previous.user_Pin != current.user_Pin,
//       builder: (context, state) {
//         return TextField(
//           key: const Key('logupForm_user_PinInput_textField'),
//           onChanged: (user_Pin) => context.read<LoginBloc>().add(LoginUser_PinChanged(user_Pin)),
//           decoration: InputDecoration(
//             labelText: 'PIN',
//             errorText: state.user_Pin.displayError != null ? 'invalid user_PinSub' : null,
//           ),
//         );
//       },
//     );
//   }
// }

class _User_KataLaluanInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) => previous.user_KataLaluan != current.user_KataLaluan,
      builder: (context, state) {
        return TextField(
          key: const Key('logupForm_user_KataLaluanInput_textField'),
          onChanged: (user_KataLaluan) => context.read<LoginBloc>().add(LoginUser_KataLaluanChanged(user_KataLaluan)),
          decoration: InputDecoration(
            labelText: 'Password',
            errorText: state.user_KataLaluan.displayError != null ? 'invalid user_KataLaluan' : null,
          ),
        );
      },
    );
  }
}

class _LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        return state.status.isInProgress
            ? const CircularProgressIndicator()
            : SizedBox(
                width: double.maxFinite,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: AppSettings.ColorMain),
                  key: const Key('loginForm_continue_raisedButton'),
                  onPressed: state.isValid
                      ? () {
                          context.read<LoginBloc>().add(LoginSubmitted(user_IC: state.user_IC.value, user_KodKawasan: state.user_KodKawasan.value, user_Pin: state.user_Pin.value, user_KataLaluan: state.user_KataLaluan.value));
                        }
                      : null,
                  // : () {
                  //     context.read<LoginBloc>().add(LoginSubmitted(
                  //         user_IC: '690504086524',
                  //         user_KodKawasan: state.user_KodKawasan.value,
                  //         user_Pin: state.user_Pin.value,
                  //         user_KataLaluan: '6524'));
                  //   },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Text(
                      'Sign In',
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
