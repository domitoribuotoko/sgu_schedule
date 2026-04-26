class FetchGroupsParams {
  const FetchGroupsParams({
    this.facultyId = '',
    this.formId = '',
    this.forceUpdate = false,
    this.alwaysFallback = true,
  });

  final String facultyId;
  final String formId;
  final bool forceUpdate;
  final bool alwaysFallback;
}
