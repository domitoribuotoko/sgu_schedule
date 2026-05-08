import 'package:sgu_schedule/data/telegram/telegram_mini_app_launch_reader_stub.dart'
  if (dart.library.html) 'package:sgu_schedule/data/telegram/telegram_mini_app_launch_reader_web.dart';
import 'package:sgu_schedule/domain/entities/telegram_mini_app_launch.dart';
import 'package:sgu_schedule/domain/services/telegram_mini_app_gateway.dart';

class TelegramMiniAppGatewayImpl implements TelegramMiniAppGateway {
  TelegramMiniAppGatewayImpl({TelegramMiniAppLaunchReader? reader})
    : _reader = reader ?? TelegramMiniAppLaunchReader();

  final TelegramMiniAppLaunchReader _reader;

  @override
  TelegramMiniAppLaunch readLaunchContext() => _reader.read();

  @override
  void notifyWebAppReady() => _reader.notifyReady();
}
