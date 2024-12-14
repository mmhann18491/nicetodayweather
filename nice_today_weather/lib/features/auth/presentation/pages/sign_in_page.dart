import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nice_today_weather/features/auth/presentation/bloc/auth_bloc.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              theme.colorScheme.primary,
              theme.colorScheme.secondary,
            ],
          ),
        ),
        child: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: theme.colorScheme.error,
                ),
              );
            }
          },
          child: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // App Icon
                    Image.asset(
                      'assets/icons/app_icon.png',
                      height: size.width * 0.25,
                    ),
                    const SizedBox(height: 24),
                    // App Title
                    Text(
                      'Nice Today',
                      style: theme.textTheme.displaySmall?.copyWith(
                        color: theme.colorScheme.onPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Weather',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: theme.colorScheme.onPrimary.withOpacity(0.8),
                        letterSpacing: 4,
                        height: 1.5,
                      ),
                    ),
                    SizedBox(height: size.height * 0.08),
                    // Sign In Button
                    BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {
                        if (state is AuthLoading) {
                          return const CircularProgressIndicator(
                            color: Colors.white,
                          );
                        }
                        return FilledButton.icon(
                          onPressed: () {
                            context
                                .read<AuthBloc>()
                                .add(SignInWithGoogleRequested());
                          },
                          style: FilledButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black87,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            minimumSize: const Size(256, 40),
                          ).copyWith(
                            overlayColor:
                                WidgetStateProperty.resolveWith((states) {
                              if (states.contains(WidgetState.pressed)) {
                                return Colors.grey.withOpacity(0.12);
                              }
                              if (states.contains(WidgetState.hovered)) {
                                return Colors.grey.withOpacity(0.08);
                              }
                              return null;
                            }),
                          ),
                          icon: Image.asset(
                            'assets/images/google_logo.png',
                            height: 18,
                            width: 18,
                          ),
                          label: Text(
                            'Sign in with Google',
                            style: theme.textTheme.labelLarge?.copyWith(
                              color: Colors.black87,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.1,
                              height: 1.0,
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                    // App Description
                    Text(
                      'Get accurate weather updates for any location',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onPrimary.withOpacity(0.7),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
