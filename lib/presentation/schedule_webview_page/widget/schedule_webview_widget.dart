import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:sgu_schedule/core/utils/trace_print.dart';
import 'package:sgu_schedule/domain/services/schedule_url_utils.dart';
import 'package:sgu_schedule/presentation/_base/widgets/base_web_view_widget.dart';
import 'package:sgu_schedule/presentation/_base/utils/web_view_enhancements/sgu_site_enc/sgu_site_header_hide_enhancement.dart';
import 'package:sgu_schedule/presentation/_base/widgets/bloc_wrappers/bloc_multi_selector.dart';
import 'package:sgu_schedule/presentation/schedule_webview_page/cubit/schedule_webview_cubit.dart';
import 'package:sgu_schedule/presentation/schedule_webview_page/cubit/schedule_webview_state.dart';

import '../../_base/utils/web_view_enhancements/sgu_site_enc/sgu_site_footer_hide_enhancement.dart';

class ScheduleWebviewWidget extends StatelessWidget {
  const ScheduleWebviewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return _ScheduleWebviewBlocMultiSelector(
      selectors: (s) => [s.bootstrapComplete],
      cubitBuilder: (context, cubit, state) {
        if (!state.bootstrapComplete) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        return _ScheduleWebviewBlocMultiSelector(
          selectors: (s) => [
            s.webViewUrl,
            s.resetWebView,
            s.webviewCommand,
            s.isLoading,
            s.hasSavedGroupSchedule,
          ],
          cubitBuilder: (context, cubit, state) {
            trace('webview build url init ${state.webViewUrl}');
            return PopScope(
              canPop: false,
              onPopInvokedWithResult: (didPop, _) {
                if (!didPop) {
                  cubit.onBackTap();
                }
              },
              child: Scaffold(
                appBar: AppBar(
                  title: const Text('Расписание СГУ'),
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: cubit.onBackTap,
                  ),
                  actions: [_MenuButtonBuilder()],
                ),
                body: Stack(
                  children: [
                    BaseWebViewWidget(
                      initRequest: URLRequest(url: WebUri(state.webViewUrl)),
                      shouldReloadAfterInitUrlChange: (oldUrl, newUrl) =>
                          !ScheduleUrlUtils.sameHttpDocumentIgnoringFragment(
                            oldUrl,
                            newUrl,
                          ),
                      enhancements: const [
                        SguSiteHeaderHideEnhancement(),
                        SguSiteFooterHideEnhancement(),
                      ],
                      resetWebView: state.resetWebView,
                      onResetWebViewEnd: cubit.onResetWebViewEnd,
                      onLoadStateChange: ({required isLoading}) =>
                          cubit.onWebViewLoadStateChange(isLoading: isLoading),
                      shouldOverrideUrl: cubit.shouldOverrideUrlLoading,
                      commandRequest: state.webviewCommand,
                      onPopNotAvailable: cubit.onWebviewPopNotAvailable,
                      onCommandHandled: cubit.onWebViewCommandHandled,
                      onLoadStop: cubit.onLoadStop,
                    ),
                    if (state.isLoading)
                      const ColoredBox(
                        color: Color(0x88FFFFFF),
                        child: Center(child: CircularProgressIndicator()),
                      ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _MenuButtonBuilder extends StatelessWidget {
  const _MenuButtonBuilder();

  @override
  Widget build(BuildContext context) {
    return _ScheduleWebviewBlocMultiSelector(
      selectors: (state) => [
        state.hasAnyMenuButtons,
        state.canGoToSelectSchedule,
        state.canShowSelectedSchedule,
      ],
      cubitBuilder: (context, cubit, state) {
        trace('has any button ${state.hasAnyMenuButtons}');
        if (!state.hasAnyMenuButtons) {
          return SizedBox();
        }
        return PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert),
          onSelected: (value) {
            if (value == 'selection') {
              cubit.openScheduleSelection();
            } else if (value == 'saved_schedule') {
              cubit.openSavedScheduleFromStorage();
            }
          },
          itemBuilder: (ctx) {
            return [
              if (state.canGoToSelectSchedule)
                const PopupMenuItem<String>(
                  value: 'selection',
                  child: Text('Сменить факультет и группу'),
                ),
              if (state.hasSavedGroupSchedule && state.canShowSelectedSchedule)
                const PopupMenuItem<String>(
                  value: 'saved_schedule',
                  child: Text('Просмотреть выбранное расписание'),
                ),
            ];
          },
        );
      },
    );
  }
}

class _ScheduleWebviewBlocMultiSelector extends StatelessWidget {
  const _ScheduleWebviewBlocMultiSelector({
    required this.selectors,
    this.builder,
    this.cubitBuilder,
  }) : assert(
         builder != null || cubitBuilder != null,
         'Нужен builder или cubitBuilder',
       );

  final List<dynamic> Function(ScheduleWebviewState state) selectors;
  final Widget Function(BuildContext context, ScheduleWebviewState state)?
  builder;
  final Widget Function(
    BuildContext context,
    ScheduleWebviewCubit cubit,
    ScheduleWebviewState state,
  )?
  cubitBuilder;

  @override
  Widget build(BuildContext context) {
    return BlocMultiSelector<ScheduleWebviewCubit, ScheduleWebviewState>(
      selectors: selectors,
      builder: builder,
      cubitBuilder: cubitBuilder,
    );
  }
}
