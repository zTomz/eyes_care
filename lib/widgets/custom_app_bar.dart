import 'package:eyes_care/main.dart';
import 'package:flutter/material.dart';
import 'package:rocket_timer/rocket_timer.dart';
import 'package:window_manager/window_manager.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final RocketTimer timer;
  final void Function() onToggle;
  final void Function() onRestart;
  final void Function() onMinimize;

  const CustomAppBar({
    super.key,
    required this.timer,
    required this.onToggle,
    required this.onRestart,
    required this.onMinimize,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        DragToMoveArea(
          child: Align(
            alignment: Alignment.centerLeft,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Tooltip(
                  message: "Use this area above the app bar to move the window",
                  child: Container(
                    height: 7.5,
                    width: 7.5,
                    margin: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
                Tooltip(
                  message: "Minimize the window",
                  child: MaterialButton(
                    onPressed: onMinimize,
                    minWidth: 50,
                    height: 10,
                    padding: EdgeInsets.zero,
                    hoverColor: Colors.red[300],
                    child: const Icon(Icons.minimize_rounded),
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: ValueListenableBuilder(
                  valueListenable: themeNotifier,
                  builder: (context, _, __) {
                    final isLight = themeNotifier.value.index == 1;

                    return IconButton(
                      onPressed: () {
                        themeNotifier.value =
                            isLight ? ThemeMode.dark : ThemeMode.light;
                      },
                      icon: Icon(isLight ? Icons.dark_mode : Icons.light_mode),
                    );
                  },
                ),
              ),
              const SizedBox(width: 10),
              Text(
                'Eyes Care',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const Spacer(),
              AnimatedBuilder(
                animation: timer,
                builder: (context, _) {
                  return IconButton(
                    icon: Icon(
                      timer.status == TimerStatus.pause
                          ? Icons.play_arrow
                          : Icons.pause,
                    ),
                    onPressed: onToggle,
                  );
                },
              ),
              IconButton(
                onPressed: onRestart,
                icon: const Icon(Icons.restart_alt),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(70);
}
