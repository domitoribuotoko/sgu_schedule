enum WebViewCommandEnum {
  none,
  clearHistory,
  back;

  bool get isBack => this == back;
  bool get isClear=> this == clearHistory;
}
