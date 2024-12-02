import 'dart:async';


import 'package:TapBiz/subconfig/AppSettings.dart';

import 'onboarding1.dart';
import 'splash.dart';
import 'subconfig/constant.dart';
import 'subconfig/static.dart';
import 'subdata/repository/authentication_repository.dart';
import 'subdata/repository/user_repository.dart';
import 'sublogic/bloc/auth/authentication_bloc.dart';

import 'sublogic/bloc/dbnotifikasi/dbnotifikasi_bloc.dart';
import 'sublogic/bloc/dbpenggunaLog/bloc.dart';
import 'sublogic/bloc/profil/profil_bloc.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'devkit/cubit/firestore/firestore_cubit.dart';
import 'devkit/cubit/language/language_cubit.dart';
import 'devkit/cubit/theme/theme_cubit.dart';

import 'subconfig/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'subui_tapbiz/home.dart' as tapbiz;
import 'subui_tapbiz/home_PageGroups.dart';
import 'subui_tapbiz/home_PageThemes.dart';
import 'subui_tapbiz/home_Users.dart';
import 'subui_tapbiz/home_Users_user.dart';

class MainMaterialApp extends StatefulWidget {
  const MainMaterialApp({super.key});

  @override
  State<MainMaterialApp> createState() => _MainMaterialAppState();
}

class _MainMaterialAppState extends State<MainMaterialApp> {
  late final AuthenticationRepository _authenticationRepository;
  late final UserRepository _userRepository;

  @override
  void initState() {
    super.initState();
    _authenticationRepository = AuthenticationRepository();
    _userRepository = UserRepository();
  }

  @override
  void dispose() {
    _authenticationRepository.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: _authenticationRepository,
      child: BlocProvider(
        create: (_) => AuthenticationBloc(
          authenticationRepository: _authenticationRepository,
          userRepository: _userRepository,
        ),
        child: const AppView(),
      ),
    );
  }
}

class AppView extends StatefulWidget {
  const AppView({super.key});

  @override
  State<AppView> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  final _navigatorKey = GlobalKey<NavigatorState>();
  NavigatorState get _navigator => _navigatorKey.currentState!;
  late String appRunning;

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    // _checkLoggedIn(context);
    context.read<AuthenticationBloc>().add(OnSetAuthenticationStatus());

    return MultiBlocProvider(
      providers: [
        // this bloc used for feature - change language
        BlocProvider<LanguageCubit>(
          create: (BuildContext context) => LanguageCubit(),
        ),
        // this bloc used to change theme on feature list
        BlocProvider<ThemeCubit>(
          create: (BuildContext context) => ThemeCubit(),
        ),
        BlocProvider<FirestoreCubit>(
          create: (BuildContext context) => FirestoreCubit(),
        ),


        BlocProvider<DbNotifikasiBloc>(
          create: (BuildContext context) => DbNotifikasiBloc(),
        ),
        
        // BlocProvider<DbPenggunaLogBloc>(
        //   create: (BuildContext context) => DbPenggunaLogBloc(),
        // ),



        BlocProvider<DbDataProfilBloc_Profil>(
          create: (BuildContext context) => DbDataProfilBloc_Profil(),
        ),
        


        
      ],
      child: MaterialApp(
        title: APP_NAME,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          // primarySwatch: Colors.orange,
          colorScheme: ColorScheme.fromSeed(seedColor: AppSettings.ColorMain),
          visualDensity: VisualDensity.adaptivePlatformDensity,
          pageTransitionsTheme: PageTransitionsTheme(builders: {
            /*
              Below is the example to change MaterialPageRoute default transition in iOS and Android :
               FadeUpwardsPageTransitionsBuilder() <= Default MaterialPageRoute Transition
               OpenUpwardsPageTransitionsBuilder()
               ZoomPageTransitionsBuilder()
               CupertinoPageTransitionsBuilder()
              */

            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
            TargetPlatform.android: ZoomPageTransitionsBuilder(),
          }),
        ),
        // navigatorKey: _navigatorKey,
        navigatorKey: StaticVarMethod.navKey,
        builder: (context, child) {
          return BlocListener<AuthenticationBloc, AuthenticationState>(
            listener: (context, state) {
              switch (state.status) {
                // case AuthenticationStatus.authenticated:
                //   StaticVarMethod.navKey.currentState?.pushAndRemoveUntil<void>(
                //     tapbiz.HomePage.route(),
                //     (route) => false,
                //   );
                //   break;
                
                // case AuthenticationStatus.authenticated:
                //   StaticVarMethod.navKey.currentState?.pushAndRemoveUntil<void>(
                //     PageGroups.route(),
                //     (route) => false,
                //   );
                //   break;

                case AuthenticationStatus.authenticated:
                  StaticVarMethod.navKey.currentState?.pushAndRemoveUntil<void>(
                    PageUsers_User.route(),
                    (route) => false,
                  );
                  break;

                  
                // case AuthenticationStatus.unauthenticated:
                //   StaticVarMethod.navKey.currentState?.pushAndRemoveUntil<void>(
                //     SubSigninPage.route(),
                //     (route) => false,
                //   );
                //   break;
                case AuthenticationStatus.unauthenticated:
                  StaticVarMethod.navKey.currentState?.pushAndRemoveUntil<void>(
                    Onboarding1Page.route(),
                    (route) => false,
                  );
                  break;  
                  
                case AuthenticationStatus.unknown:
                  break;
              }
            },
            child: child,
          );
        },
        onGenerateRoute: (_) => SplashDevKit.route(),
      ),
    );
  }
}
