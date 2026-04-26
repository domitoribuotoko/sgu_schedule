import 'package:equatable/equatable.dart';

class Faculty extends Equatable {
  const Faculty({
    required this.id,
    required this.name,
    this.kind,
  });

  final String id;
  final String name;
  final String? kind;

  @override
  List<Object?> get props => [id, name, kind];
}
