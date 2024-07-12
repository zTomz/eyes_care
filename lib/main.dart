import 'package:eyes_care/constants.dart';
import 'package:eyes_care/countdown_screen.dart';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initalizeWindow();

  runApp(const CareYourEyes());
}

/// Initializes the window with the settings below
Future<void> initalizeWindow() async {
  await windowManager.ensureInitialized();

  WindowOptions windowOptions = const WindowOptions(
    windowButtonVisibility: false,
    size: kWindowSize,
    minimumSize: kWindowSize,
    maximumSize: kWindowSize,
    center: true,
    backgroundColor: Colors.transparent,
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.hidden,
  );

  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });
}

final themeNotifier = ValueNotifier(ThemeMode.light);

class CareYourEyes extends StatelessWidget {
  const CareYourEyes({super.key});
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: themeNotifier,
      builder: (context, _, __) {
        return MaterialApp(
          title: 'Eyes Care',
          debugShowCheckedModeBanner: false,
          themeMode: themeNotifier.value,
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          home: const CountdownScreen(),
        );
      },
    );
  }
}
