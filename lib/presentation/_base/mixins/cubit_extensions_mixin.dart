import 'package:flutter_bloc/flutter_bloc.dart';

mixin CubitExtensions<S> on Cubit<S> {
  void maybeEmit(S next) {
    if (isClosed) {
      return;
    }
    emit(next);
  }
}
