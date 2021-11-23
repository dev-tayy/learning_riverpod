import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

var valueProvider = StateNotifierProvider<Clock, DateTime>((ref) {
  return Clock();
});
void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class Clock extends StateNotifier<DateTime> {
  late final Timer _timer;
  // 1. initialize with current time
  Clock() : super(DateTime.now()) {
    // 2. create a timer that fires every second
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      // 3. update the state with the current time
      state = DateTime.now();
    });
  }

  // 4. cancel the timer when finished
  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}

class MyHomePage extends ConsumerWidget {
  const MyHomePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<DateTime>(valueProvider, (previous, current) {
      // note: this callback executes when the provider value changes,
      // not when the build method is called

      String previousTime = DateFormat('HH:mm:ss').format(previous!);
      String currentTime = DateFormat('HH:mm:ss').format(current);
      // 5. update the UI with the new time
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('Value is $currentTime and previous value $previousTime')),
      );
    });
    final value = ref.watch(valueProvider.notifier);
    print(value);

    return Scaffold(
      body: Center(
        child: Text(
          'Some text here oh 👍 ',
          style: Theme.of(context).textTheme.headline4,
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   // access the provider via ref.read(), then increment its state.
      //   onPressed: () => ref.read(valueProvider).state++,
      //   child: const Icon(Icons.add),
      // ),
    );
  }
}
