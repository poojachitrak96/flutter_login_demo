import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_login_demo/login/auth_state.dart';
import 'package:flutter_login_demo/counter/counter_cubit.dart';
import 'package:flutter_login_demo/counter/counter_page.dart';
import 'package:flutter_login_demo/data/model/User.dart';
import 'package:flutter_login_demo/data/repository/UserRepositoryImpl.dart';
import 'auth_cubit.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isValid = false;
  bool _isSubmitted = false;

  void _validateForm() {
    setState(() {
      _isValid = _formKey.currentState?.validate() ?? false;
    });
  }

  void _onLoginPressed(BuildContext context) {
    setState(() {
      _isSubmitted = true;
    });

    if (_formKey.currentState!.validate()) {
      final user = User(
        userName: _usernameController.text,
        password: _passwordController.text,
      );
      context.read<AuthCubit>().signIn(user);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Login"),
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _usernameController,
                      decoration: const InputDecoration(
                        labelText: "Username",
                        hintText: "Enter at least 3 characters",
                        border: OutlineInputBorder(),
                      ),
                      autovalidateMode: _isSubmitted
                          ? AutovalidateMode.always
                          : AutovalidateMode.disabled,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Enter a username";
                        } else if (value.length < 3) {
                          return "Username must be at least 3 characters";
                        }
                        return null;
                      },
                      onChanged: (value) => _validateForm(),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: "Password",
                        hintText: "Must be at least 6 characters",
                        border: OutlineInputBorder(),
                      ),
                      autovalidateMode: _isSubmitted
                          ? AutovalidateMode.always
                          : AutovalidateMode.disabled,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Enter a password";
                        } else if (value.length < 6) {
                          return "Password must be at least 6 characters";
                        }
                        return null;
                      },
                      onChanged: (value) => _validateForm(),
                    ),
                    const SizedBox(height: 16),
                    BlocConsumer<AuthCubit, AuthState>(
                      listener: (context, state) {
                        if (state is AuthSuccess) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(state.message)),
                          );

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BlocProvider(
                                create: (context) => CounterCubit(
                                    userRepo: UserRepositoryImpl(),
                                    user: state.user),
                                child: CounterPage(
                                    title: "Counter App", user: state.user),
                              ),
                            ),
                          );
                        } else if (state is AuthFailure) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Invalid username or password")),
                          );
                        }
                      },
                      builder: (context, state) {
                        return ElevatedButton(
                          onPressed:
                              _isValid ? () => _onLoginPressed(context) : null,
                          child: state is AuthLoading
                              ? const CircularProgressIndicator()
                              : const Text("Login"),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
