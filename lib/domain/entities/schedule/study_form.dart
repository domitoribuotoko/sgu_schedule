import 'package:equatable/equatable.dart';

class StudyForm extends Equatable {
  const StudyForm({required this.id, required this.name});

  final String id;
  final String name;

  @override
  List<Object?> get props => [id, name];
}
