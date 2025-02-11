import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_login_demo/login/auth_cubit.dart';
import 'package:flutter_login_demo/counter/counter_state.dart';
import 'package:flutter_login_demo/data/model/User.dart';
import 'counter_cubit.dart';

class CounterPage extends StatelessWidget {
  const CounterPage({
    super.key,
    required this.title,
    required this.user,
  });

  final String title;
  final User user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context)
            .appBarTheme
            .backgroundColor, // Consistent with theme
        title: Text(title),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthCubit>().signOut(user);
              Navigator.pop(context);
            },
            tooltip: "Logout",
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Welcome, ${user.userName}!",
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'You have pressed the button this many times:',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            BlocBuilder<CounterCubit, CounterState>(
              builder: (context, state) {
                return Text(
                  '${state.counter}',
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      color: Colors.blueAccent, fontWeight: FontWeight.bold),
                );
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => context.read<CounterCubit>().reset(),
              child: const Text("Reset Counter"),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.read<CounterCubit>().increment(),
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
