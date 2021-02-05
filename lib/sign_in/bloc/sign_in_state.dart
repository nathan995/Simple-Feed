part of 'sign_in_bloc.dart';

@immutable
abstract class SignInState {}

class SignInInitial extends SignInState {}

class SignInLoadingState extends SignInState {}

class SignInErrorState extends SignInState {
  final String message;
  SignInErrorState({this.message});
}

class CodeSentState extends SignInState {}

class SignInCompletedState extends SignInState {}
