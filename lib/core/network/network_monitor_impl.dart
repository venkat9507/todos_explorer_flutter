import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import '../constants/enums.dart' show NetworkStatus;
import '../logger/app_logger.dart' show AppLogger;

abstract interface class NetworkMonitor {
  /// Real-time stream of network status changes.
  Stream<NetworkStatus> get statusStream;

  /// One-time check of current network status.
  Future<NetworkStatus> getCurrentStatus();
}

class NetworkMonitorImpl implements NetworkMonitor {
  final Connectivity _connectivity;

  NetworkMonitorImpl({Connectivity? connectivity})
      : _connectivity = connectivity ?? Connectivity();

  @override
  Stream<NetworkStatus> get statusStream async* {
    // Emit current status immediately
    yield await getCurrentStatus();

    // Listen for changes
    await for (final result in _connectivity.onConnectivityChanged) {
      try {
        if (result.contains(ConnectivityResult.none)) {
          AppLogger.warning(title: 'Network', message: 'Connection lost');
          yield NetworkStatus.disconnected;
        } else {
          final isReachable = await _checkReachability();
          if (isReachable) {
            AppLogger.info(title: 'Network', message: 'Connected: $result');
            yield NetworkStatus.connected;
          } else {
            AppLogger.warning(
                title: 'Network', message: 'No internet access: $result');
            yield NetworkStatus.disconnected;
          }
        }
      } catch (e, st) {
        AppLogger.error(
            title: 'Network',
            message: 'Error in statusStream',
            exception: e,
            stackTrace: st);
        yield NetworkStatus.disconnected;
      }
    }
  }

  @override
  Future<NetworkStatus> getCurrentStatus() async {
    try {
      final result = await _connectivity.checkConnectivity();
      if (result.contains(ConnectivityResult.none)) {
        return NetworkStatus.disconnected;
      }
      final isReachable = await _checkReachability();
      return isReachable ? NetworkStatus.connected : NetworkStatus.disconnected;
    } catch (e, st) {
      AppLogger.error(
          title: 'Network',
          message: 'Error checking status',
          exception: e,
          stackTrace: st);
      return NetworkStatus.disconnected;
    }
  }

  /// Pings a reliable endpoint to verify actual internet access.
  Future<bool> _checkReachability() async {
    try {
      final response = await http
          .get(Uri.parse('https://clients3.google.com/generate_204'))
          .timeout(const Duration(seconds: 3));
      return response.statusCode == 204;
    } catch (_) {
      return false;
    }
  }
}
