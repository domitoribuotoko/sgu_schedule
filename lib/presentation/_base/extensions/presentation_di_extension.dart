import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sgu_schedule/core/di/di_interface.dart';
import 'package:sgu_schedule/domain/_base/di_getters.dart';

extension PresentationDiX on BuildContext {
  DiPresentationScope get presentationDi => read<DiPresentationScope>();

  Factories get factories => presentationDi.factories;

  UseCases get useCases => presentationDi.useCases;
}
