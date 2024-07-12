import 'package:eyes_care/constants.dart';
import 'package:eyes_care/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:rocket_timer/rocket_timer.dart';
import 'package:window_manager/window_manager.dart';
import 'package:eyes_care/shared_pref.dart';
import 'package:eyes_care/widgets/force_mode_check_box.dart';
import 'package:eyes_care/widgets/rule_text.dart';
import 'package:eyes_care/widgets/rule_timer.dart';
import 'package:local_notifier/local_notifier.dart';

class CountdownScreen extends StatefulWidget {
  const CountdownScreen({super.key});

  @override
  CountdownScreenState createState() => CountdownScreenState();
}

class CountdownScreenState extends State<CountdownScreen> with WindowListener {
  late RocketTimer _timer;
  bool inProgress = false;
  late ValueNotifier<bool> forceModeEnabled = ValueNotifier(false);
  int followed = 0;

  @override
  void initState() {
    setUpForceMode();

    // Add a listener to the window events
    windowManager.addListener(this);

    // Set up the local notifier
    localNotifier.setup(
      appName: 'CareYourEyes',
      shortcutPolicy: ShortcutPolicy.requireCreate,
    );

    // Initialize the timer
    initTimer();

    super.initState();
  }

  /// Initialize and start the timer with the `timerRuleDuration`
  void initTimer() {
    _timer = RocketTimer(
      type: TimerType.countdown,
      duration: kTimerRuleDuration,
    );

    // Add a listener to the timer, when it reaches 0, show a notification and change the state
    _timer.addListener(() {
      if (_timer.kDuration == 0) {
        // Show a notification
        showNotification();

        // Change the state
        _timer.kDuration = inProgress ? kTimerRuleDuration.inSeconds : kRule;
        inProgress = !inProgress;

        setState(() {});
      }
    });

    // Start the timer
    _timer.start();
  }

  Future<void> setUpForceMode() async {
    await PreferenceService.getBool(PreferenceService.forceModeKey)
        .then((value) {
      forceModeEnabled.value = value ?? false;
    });
  }

  // FIXME: This doesn't work
  // @override
  // Future<void> onWindowMinimize() async {
  //   if (forceModeEnabled.value) {
  //     await handleWindowState();
  //   }
  //   super.onWindowMinimize();
  // }

  // FIXME: This doesn't work
  // @override
  // Future<void> onWindowBlur() async {
  //   if (forceModeEnabled.value) {
  //     await handleWindowState();
  //   }
  //   super.onWindowBlur();
  // }

  // FIXME: This doesn't work
  // Future<void> handleWindowState() async {
  //   if (inProgress) {
  //     await windowManager.show();
  //     await windowManager.focus();
  //     await windowManager.setFullScreen(true);
  //   } else {
  //     windowManager.minimize();
  //     await windowManager.setFullScreen(false);
  //   }
  // }

  @override
  void dispose() {
    _timer.dispose();
    windowManager.removeListener(this);
    super.dispose();
  }

  /// Display a local notification
  Future<void> showNotification() async {
    LocalNotification notification = LocalNotification(
      title: inProgress ? "Stay Focused 💪" : "Take a Moment 🌟",
      body: inProgress
          ? "Keep your gaze on the screen. Remember, every 20 minutes, take a 20-second break looking at something 20 feet away."
          : "Step back from the screen and focus on something 20 feet away for 20 seconds. Your eyes will thank you!",
    );
    // FIXME: This doesn't work
    // notification.onShow = _onShowNotification;
    notification.show();
  }
  // FIXME: This doesn't work
  // Future<void> _onShowNotification() async {
  //   if (forceModeEnabled.value) {
  //     await handleWindowState();
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        timer: _timer,
        onToggle: () {
          if (_timer.status == TimerStatus.pause) {
            _timer.start();
          } else {
            _timer.pause();
          }
        },
        onRestart: _timer.restart,
        onMinimize: windowManager.minimize,
      ),
      // AppBar(
      //   title: const Text('Eyes Care'),
      //   centerTitle: true,
      //   actions: [
      //     AnimatedBuilder(
      //       animation: _timer,
      //       builder: (context, _) {
      //         return IconButton(
      //           icon: Icon(
      //             _timer.status == TimerStatus.pause
      //                 ? Icons.play_arrow
      //                 : Icons.pause,
      //           ),
      //           onPressed: () {
      //             if (_timer.status == TimerStatus.pause) {
      //               _timer.start();
      //             } else {
      //               _timer.pause();
      //             }
      //           },
      //         );
      //       },
      //     ),
      //     IconButton(
      //       onPressed: _timer.restart,
      //       icon: const Icon(Icons.restart_alt),
      //     ),
      //     IconButton(
      //       onPressed: windowManager.minimize,
      //       icon: const Icon(Icons.minimize_rounded),
      //     ),
      //   ],
      // ),
      body: Container(
        padding: const EdgeInsets.all(8.0),
        child: Flex(
          direction: inProgress ? Axis.vertical : Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  inProgress
                      ? Text(
                          "look away from your screen and focus on something 20 feet away for 20 seconds.",
                          style: Theme.of(context).textTheme.headlineMedium,
                        )
                      : const RuleText(),
                  ForceModeCheckBox(
                    forceModeEnabled: forceModeEnabled,
                  ),
                ],
              ),
            ),
            RuleTimer(timer: _timer, inProgress: inProgress),
          ],
        ),
      ),
    );
  }
}
