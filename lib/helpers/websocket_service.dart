import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:dart_pusher_channels/dart_pusher_channels.dart';

import '../features/reservations/model/chat_message_model.dart';
import '../networks/api_acess.dart';
import '../constants/app_constants.dart';
import 'di.dart';

class WebSocketService {
  static final WebSocketService _instance = WebSocketService._internal();
  static WebSocketService get instance => _instance;

  WebSocketService._internal();

  PusherChannelsClient? pusher;
  PrivateChannel? currentChannel;
  StreamSubscription? _chatEventSubscription;
  StreamSubscription? _chatEventSubscriptionFallback;
  StreamSubscription? _connectionSubscription;
  bool _isInitialized = false;

  Future<void> connectAndSubscribe(String conversationId) async {
    try {
      if (!_isInitialized) {
        PusherChannelsPackageLogger.enableLogs();

        const options = PusherChannelsOptions.fromHost(
          scheme: 'wss',
          host: 'backend.tremley.com',
          key: 'isfdqmxbdd7ljgyuixe7',
          shouldSupplyMetadataQueries: true,
          metadata: PusherChannelsOptionsMetadata.byDefault(),
          port: 443,
        );

        pusher = PusherChannelsClient.websocket(
          options: options,
          connectionErrorHandler: (exception, trace, refresh) async {
            log("Pusher connection error: $exception");
            refresh();
          },
        );
        _isInitialized = true;
      }

      final channelName = "private-chat-conversation.$conversationId";
      log("🔌 Connecting to channel: $channelName");

      currentChannel = pusher?.privateChannel(
        channelName,
        authorizationDelegate: _CustomAuthDelegate(
          endpoint:
              Uri.parse('https://backend.tremley.com/api/broadcasting/auth'),
          headers: {
            "Authorization": "Bearer ${appData.read(kKeyAccessToken) ?? ''}",
            "Accept": "application/json",
          },
        ),
      );

      _connectionSubscription = pusher?.onConnectionEstablished.listen((_) {
        log("🔄 WebSocket connected — subscribing...");
        currentChannel?.subscribeIfNotUnsubscribed();
      });

      pusher?.eventStream.listen((event) {
        log("🌍 Global WebSocket Event: [${event.name}] on channel [${event.channelName}]");
      });

      currentChannel?.subscribeIfNotUnsubscribed();

      _chatEventSubscription =
          currentChannel?.bind('ChatEvent').listen(_handleIncomingMessage);

      // Failsafe for full namespace
      _chatEventSubscriptionFallback = currentChannel
          ?.bind('App\\\\Events\\\\ChatEvent')
          .listen(_handleIncomingMessage);

      pusher?.connect();
    } catch (e) {
      log("Pusher Init Error: $e");
    }
  }

  void _handleIncomingMessage(ChannelReadEvent event) {
    if (event.data != null) {
      try {
        log("📩 Message Event received: ${event.data}");

        final decoded = jsonDecode(event.data!) as Map<String, dynamic>;
        final dataMap = decoded.containsKey('message') &&
                decoded['message'] is Map<String, dynamic>
            ? decoded['message']
            : decoded;

        final newMsg = ChatMessageModel.fromJson(dataMap);

        log("✅ Parsed message: ${newMsg.message}");

        // Inject into Rx stream
        final currentRxState = getConversationRxObj.fileData.value;
        if (currentRxState != null && currentRxState['data'] != null) {
          List messages = List.from(currentRxState['data']);

          if (!messages.any((m) => m['id'] == newMsg.id)) {
            messages.add(dataMap);
            currentRxState['data'] = messages;
            getConversationRxObj.dataFetcher.sink.add(currentRxState);
          }
        }
      } catch (e) {
        log("❌ Message JSON Parse Error: $e");
      }
    }
  }

  Future<void> disconnect() async {
    try {
      await _chatEventSubscription?.cancel();
      await _chatEventSubscriptionFallback?.cancel();
      await _connectionSubscription?.cancel();

      _chatEventSubscription = null;
      _chatEventSubscriptionFallback = null;
      _connectionSubscription = null;

      currentChannel?.unsubscribe();
      currentChannel = null;

      pusher?.dispose();
      pusher = null;
      _isInitialized = false;

      log("🔌 Pusher disconnected");
    } catch (e) {
      log("Pusher disconnect error: $e");
    }
  }
}

class _CustomAuthDelegate
    implements
        EndpointAuthorizableChannelAuthorizationDelegate<
            PrivateChannelAuthorizationData> {
  final Uri endpoint;
  final Map<String, String> headers;

  _CustomAuthDelegate({required this.endpoint, required this.headers});

  @override
  Future<PrivateChannelAuthorizationData> authorizationData(
    String socketId,
    String channelName,
  ) async {
    try {
      log("Auth Request: $endpoint, socketId: $socketId, channel: $channelName");
      final response = await http.post(
        endpoint,
        headers: {
          ...headers,
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {'socket_id': socketId, 'channel_name': channelName},
      );

      log("Auth Response Status: ${response.statusCode}");
      log("Auth Response Body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final decoded = jsonDecode(response.body);
        return PrivateChannelAuthorizationData(authKey: decoded['auth']);
      } else {
        throw Exception("Failed auth: ${response.statusCode} ${response.body}");
      }
    } catch (e) {
      log("Auth Error: $e");
      rethrow;
    }
  }

  @override
  void Function(dynamic error, StackTrace stackTrace)? get onAuthFailed =>
      (error, stackTrace) {
        log(
          "Auth Failed Callback: $error",
          error: error,
          stackTrace: stackTrace,
        );
      };
}
