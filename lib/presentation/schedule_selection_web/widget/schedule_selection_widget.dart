import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sgu_schedule/domain/entities/schedule/faculty.dart';
import 'package:sgu_schedule/domain/entities/schedule/schedule_group.dart';
import 'package:sgu_schedule/domain/entities/schedule/study_form.dart';
import 'package:sgu_schedule/presentation/schedule_selection_web/cubit/schedule_selection_cubit.dart';
import 'package:sgu_schedule/presentation/schedule_selection_web/cubit/schedule_selection_state.dart';

class ScheduleSelectionWidget extends StatelessWidget {
  const ScheduleSelectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Выбор группы')),
      body: BlocBuilder<ScheduleSelectionCubit, ScheduleSelectionState>(
        builder: (context, s) {
          if (s.error != null && s.faculties.isEmpty && !s.loadingFaculties) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(s.error!, textAlign: TextAlign.center),
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: () {
                        context.read<ScheduleSelectionCubit>().loadFaculties();
                      },
                      child: const Text('Повторить'),
                    ),
                  ],
                ),
              ),
            );
          }
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (s.loadingFaculties)
                const LinearProgressIndicator()
              else
                _FacultyDropdown(
                  items: s.faculties,
                  value: s.selectedFaculty,
                  onChanged: (f) {
                    context.read<ScheduleSelectionCubit>().selectFaculty(f);
                  },
                ),
              const SizedBox(height: 16),
              if (s.selectedFaculty != null) ...[
                if (s.loadingForms)
                  const LinearProgressIndicator()
                else
                  _FormDropdown(
                    items: s.studyForms,
                    value: s.selectedForm,
                    onChanged: (v) {
                      context.read<ScheduleSelectionCubit>().selectForm(v);
                    },
                  ),
              ],
              const SizedBox(height: 16),
              if (s.selectedForm != null) ...[
                if (s.loadingGroups)
                  const LinearProgressIndicator()
                else
                  _GroupDropdown(
                    items: s.groups,
                    value: s.selectedGroup,
                    onChanged: (v) {
                      context.read<ScheduleSelectionCubit>().selectGroup(v);
                    },
                  ),
              ],
              if (s.error != null && s.faculties.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  s.error!,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
              ],
              const SizedBox(height: 24),
              FilledButton(
                onPressed: s.saving || s.selectedGroup == null
                    ? null
                    : () {
                        context
                            .read<ScheduleSelectionCubit>()
                            .confirmAndOpenSchedule();
                      },
                child: s.saving
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Открыть расписание'),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _FacultyDropdown extends StatelessWidget {
  const _FacultyDropdown({
    required this.items,
    required this.value,
    required this.onChanged,
  });

  final List<Faculty> items;
  final Faculty? value;
  final ValueChanged<Faculty?> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<Faculty>(
      key: ValueKey('faculty-${items.length}-${value?.id}'),
      decoration: const InputDecoration(labelText: 'Факультет / подразделение'),
      isExpanded: true,
      // ignore: deprecated_member_use
      value: value != null && items.contains(value) ? value : null,
      items: items
          .map(
            (e) => DropdownMenuItem(
              value: e,
              child: Text(e.name, overflow: TextOverflow.ellipsis),
            ),
          )
          .toList(),
      onChanged: onChanged,
    );
  }
}

class _FormDropdown extends StatelessWidget {
  const _FormDropdown({
    required this.items,
    required this.value,
    required this.onChanged,
  });

  final List<StudyForm> items;
  final StudyForm? value;
  final ValueChanged<StudyForm?> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<StudyForm>(
      key: ValueKey('form-${items.length}-${value?.id}'),
      decoration: const InputDecoration(labelText: 'Форма обучения'),
      isExpanded: true,
      // ignore: deprecated_member_use
      value: value != null && items.contains(value) ? value : null,
      items: items
          .map(
            (e) => DropdownMenuItem(
              value: e,
              child: Text(e.name, overflow: TextOverflow.ellipsis),
            ),
          )
          .toList(),
      onChanged: onChanged,
    );
  }
}

class _GroupDropdown extends StatelessWidget {
  const _GroupDropdown({
    required this.items,
    required this.value,
    required this.onChanged,
  });

  final List<ScheduleGroup> items;
  final ScheduleGroup? value;
  final ValueChanged<ScheduleGroup?> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<ScheduleGroup>(
      key: ValueKey('group-${items.length}-${value?.id}'),
      decoration: const InputDecoration(labelText: 'Группа'),
      isExpanded: true,
      // ignore: deprecated_member_use
      value: value != null && items.contains(value) ? value : null,
      items: items
          .map(
            (e) => DropdownMenuItem(
              value: e,
              child: Text(e.name, overflow: TextOverflow.ellipsis),
            ),
          )
          .toList(),
      onChanged: onChanged,
    );
  }
}
