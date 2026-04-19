import 'package:equatable/equatable.dart';
import 'package:sgu_schedule/core/sgu_schedule_constants.dart';
import 'package:sgu_schedule/core/utils/trace_print.dart';
import 'package:sgu_schedule/domain/services/schedule_url_utils.dart';
import 'package:sgu_schedule/presentation/_base/enums/webview_command_enum.dart';

class ScheduleWebviewState extends Equatable {
  const ScheduleWebviewState({
    required this.bootstrapComplete,
    required this.webViewUrl,
    this.hasSavedGroupSchedule = false,
    this.savedScheduleWebUrl = '',
    this.webviewCommand = WebViewCommandEnum.none,
    this.resetWebView = false,
    this.isLoading = true,
  });

  final bool bootstrapComplete;
  final String webViewUrl;

  /// Есть сохранённый путь группы (из старта или после успешного save в сессии).
  final bool hasSavedGroupSchedule;

  /// Полный URL страницы сохранённой группы (`origin` + путь).
  final String savedScheduleWebUrl;
  final WebViewCommandEnum webviewCommand;
  final bool resetWebView;
  final bool isLoading;

  ScheduleWebviewState copyWith({
    bool? bootstrapComplete,
    String? webViewUrl,
    bool? hasSavedGroupSchedule,
    String? savedScheduleWebUrl,
    WebViewCommandEnum? webviewCommand,
    bool? resetWebView,
    bool? isLoading,
  }) {
    return ScheduleWebviewState(
      bootstrapComplete: bootstrapComplete ?? this.bootstrapComplete,
      webViewUrl: webViewUrl ?? this.webViewUrl,
      hasSavedGroupSchedule:
          hasSavedGroupSchedule ?? this.hasSavedGroupSchedule,
      savedScheduleWebUrl: savedScheduleWebUrl ?? this.savedScheduleWebUrl,
      webviewCommand: webviewCommand ?? this.webviewCommand,
      resetWebView: resetWebView ?? this.resetWebView,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  bool get canGoToSelectSchedule =>
      webViewUrl != SguScheduleConstants.scheduleIndexUrl;

  bool get canShowSelectedSchedule {
    if (!hasSavedGroupSchedule || savedScheduleWebUrl.isEmpty) {
      return false;
    }
    return !ScheduleUrlUtils.sameHttpDocumentIgnoringFragment(
      webViewUrl,
      savedScheduleWebUrl,
    );
  }

  bool get hasAnyMenuButtons {
    // trace('canGoToSelectSchedule $canGoToSelectSchedule $webViewUrl');
    return canGoToSelectSchedule ||
        (canShowSelectedSchedule && hasSavedGroupSchedule);
  }

  @override
  List<Object?> get props => [
    bootstrapComplete,
    webViewUrl,
    hasSavedGroupSchedule,
    savedScheduleWebUrl,
    webviewCommand,
    resetWebView,
    isLoading,
  ];
}
