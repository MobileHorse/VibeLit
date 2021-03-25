import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vibelit/screen/bluetooth_pair_screen.dart';

import 'bloc/app_bloc.dart';
import 'bloc/bloc.dart';
import 'config/routes.dart';
import 'screen/screen.dart';

class VibeLitApp extends StatefulWidget {
  @override
  _VibeLitAppState createState() => _VibeLitAppState();
}

class _VibeLitAppState extends State<VibeLitApp> {

  final routes = Routes();

  @override
  void initState() {
    super.initState();
    AppBloc.applicationBloc.add(ApplicationStartupEvent());
  }

  @override
  void dispose() {
    AppBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.light,
      systemNavigationBarColor: Colors.black,
      systemNavigationBarDividerColor: Colors.grey,
      systemNavigationBarIconBrightness: Brightness.light,
    ));
    return MultiBlocProvider(
        providers: AppBloc.blocProviders,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          onGenerateRoute: routes.generateRoute,
          theme: ThemeData(
            primarySwatch: Colors.blue,
            platform: TargetPlatform.iOS,
          ),
          home: BlocBuilder<ApplicationBloc, ApplicationState>(
            builder: (context, state) {
              if (state is ApplicationSetupState) {
                return BlocBuilder<BluetoothBloc, BluetoothAppState>(
                    builder: (bleContext, bleState) {
                      if (bleState is BluetoothPairState) {
                        return BluetoothPairScreen();
                      }
                      return HomeScreen();
                    });
              }
              return SplashScreen();
            },
          ),
        ));
  }
}
