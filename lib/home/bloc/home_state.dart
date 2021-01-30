part of 'home_bloc.dart';

enum LoadingStatus { loading, notLoading }
enum ErrorStatus { error, noError }

@immutable
abstract class HomeState {
  final LoadingStatus loadingStatus = LoadingStatus.loading;
  final ErrorStatus errorStatus = ErrorStatus.noError;
}

class HomeInitial extends HomeState {
  final LoadingStatus loadingStatus;
  final ErrorStatus errorStatus;
  HomeInitial(this.loadingStatus, this.errorStatus);
}

class LoadingState extends HomeState {
  final loadingStatus;
  LoadingState(this.loadingStatus);
}

class ErrorState extends HomeState {
  final errorStaus;
  ErrorState(this.errorStaus);
}
