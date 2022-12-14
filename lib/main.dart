import 'dart:async';

import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:provider/provider.dart';
import 'package:y_storiers/bloc/story/story_bloc.dart';
import 'package:y_storiers/bloc/user/user_bloc.dart';
import 'package:y_storiers/ui/add_post/widgets/standart_snackbar.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:y_storiers/ui/main/check/check.dart';
import 'package:y_storiers/ui/provider/app_data.dart';

late List<CameraDescription> cameras;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  cameras = await availableCameras();
  var appData = await AppData.init();
  final PermissionState ps = await PhotoManager.requestPermissionExtend();
  Firebase.initializeApp();
  // appData.logOut();
  // appData.setUserNickname('maximum_charisma');
  // appData.setUser(User(
  //     userId: 68,
  //     userToken:
  //         'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJuaWNrbmFtZSI6IlNhcmlrX0FuZHJlYXN5YW4iLCJ0aW1lc3RhbXAiOiIxNjU1OTExODAyLjM0OTQ3MjgifQ.gKP2NVOPxR78e-k1sIk38RZJmzetQFF1LHv3yC0ymw8',
  //     nickName: 'sarik_andreasyan'));
  print(appData.user.userToken);
  appData.openStories(false);
  appData.stopVideo(false);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => appData,
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _subscription;
  var hasConnection = false;
  bool isAlert = false;
  bool wasLost = false;

  @override
  void initState() {
    super.initState();

    getConnectivity();
  }

  getConnectivity() => _subscription = Connectivity()
          .onConnectivityChanged
          .listen((ConnectivityResult result) async {
        hasConnection = await InternetConnectionChecker().hasConnection;
        if (!hasConnection && result != ConnectivityResult.none) {
          StandartSnackBar.show(context, '???????????????? ???????????????? ????????????????????',
              SnackBarStatus.warning());
          setState(() => wasLost = true);
        } else if (wasLost) {
          StandartSnackBar.show(context, 'C?????????????????? ??????????????????????????',
              SnackBarStatus.internetResultSuccess());
          setState(() => wasLost = false);
        }
      });

  @override
  void dispose() {
    super.dispose();
    _subscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<UserBloc>(create: (context) {
          return UserBloc();
        }),
        BlocProvider<StoryBloc>(create: (context) {
          return StoryBloc();
        }),
      ],
      child: const OverlaySupport.global(
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Check(),
        ),
      ),
    );
  }
}
