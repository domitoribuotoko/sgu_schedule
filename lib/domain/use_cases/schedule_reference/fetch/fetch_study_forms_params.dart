class FetchStudyFormsParams {
  const FetchStudyFormsParams({
    this.facultyId = '',
    this.forceUpdate = false,
    this.alwaysFallback = true,
  });

  final String facultyId;
  final bool forceUpdate;
  final bool alwaysFallback;
}
