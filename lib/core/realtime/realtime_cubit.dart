import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:build4allgym/core/config/env.dart';
import 'package:build4allgym/core/network/globals.dart' as g;

class RealtimeState {
  final bool connected;
  final int tenantId;

  const RealtimeState({this.connected = false, this.tenantId = 0});
}

class RealtimeCubit extends Cubit<RealtimeState> {
  RealtimeCubit() : super(const RealtimeState());

  /// Call with empty token / tenantId=0 to disconnect.
  void bind({
    required String tokenMaybeBearerOrRaw,
    required int tenantId,
  }) {
    final raw = tokenMaybeBearerOrRaw.trim();
    final stripped =
    raw.toLowerCase().startsWith('bearer ') ? raw.substring(7).trim() : raw;

    if (stripped.isEmpty || tenantId <= 0) {
      _disconnect();
      return;
    }

    _connect(token: stripped, tenantId: tenantId);
  }

  void _connect({required String token, required int tenantId}) {
    // TODO: wire your WebSocket here using Env.wsPath
    // Example: WebSocketChannel.connect(Uri.parse('${g.appServerRoot}${Env.wsPath}?token=$token'))
    debugPrint('[Realtime] Connected tenant=$tenantId');
    emit(RealtimeState(connected: true, tenantId: tenantId));
  }

  void _disconnect() {
    debugPrint('[Realtime] Disconnected');
    emit(const RealtimeState(connected: false, tenantId: 0));
  }

  @override
  Future<void> close() {
    _disconnect();
    return super.close();
  }
}