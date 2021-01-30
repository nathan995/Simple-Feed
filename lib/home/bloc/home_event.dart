part of 'home_bloc.dart';

@immutable
abstract class HomeEvent {}

class SetLoading extends HomeEvent {}

class SetNotLoading extends HomeEvent {}

class SetError extends HomeEvent {}

class SetNoError extends HomeEvent {}
