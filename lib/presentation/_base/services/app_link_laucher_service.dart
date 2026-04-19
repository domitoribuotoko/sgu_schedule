import 'package:url_launcher/url_launcher.dart';

abstract class AppLinkLauncherInterface {
  Future<void> launchUri(Uri uri);

  Future<void> launchUrlString(String? url);

  Uri? tryParseUri(String? value);

  Future<void> launchPhone(String? phoneOrUri);
}

class AppLinkLauncherService implements AppLinkLauncherInterface {
  @override
  Future<void> launchUri(Uri uri) async {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Future<void> launchUrlString(String? url) async {
    final uri = tryParseUri(url);
    if (uri == null) {
      return;
    }
    await launchUri(uri);
  }

  @override
  Uri? tryParseUri(String? value) {
    final raw = value?.trim();
    if (raw == null || raw.isEmpty) {
      return null;
    }

    final uri = Uri.tryParse(raw);
    if (uri == null || !uri.isAbsolute) {
      return null;
    }
    return uri;
  }

  @override
  Future<void> launchPhone(String? phoneOrUri) async {
    final raw = phoneOrUri?.trim();
    if (raw == null || raw.isEmpty) {
      return;
    }

    final asUri = tryParseUri(raw);
    if (asUri != null && asUri.scheme == 'tel') {
      await launchUri(asUri);
      return;
    }

    final normalizedPhone = _normalizePhone(raw);
    if (normalizedPhone == null) {
      return;
    }

    await launchUri(Uri(scheme: 'tel', path: normalizedPhone));
  }

  String? _normalizePhone(String raw) {
    final cleaned = raw.replaceAll(RegExp(r'[^0-9+]'), '');
    if (cleaned.isEmpty) {
      return null;
    }

    if (cleaned.startsWith('+')) {
      final withoutPlus = cleaned.substring(1).replaceAll('+', '');
      return withoutPlus.isEmpty ? null : '+$withoutPlus';
    }

    return cleaned;
  }
}
