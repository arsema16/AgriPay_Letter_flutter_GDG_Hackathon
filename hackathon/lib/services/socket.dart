import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketService {
  WebSocketChannel? _channel;
  Function(Map<String, dynamic>)? onMessageCallback;

  void connect() {
    _channel = WebSocketChannel.connect(
      Uri.parse('wss://agripay-later-backend-gdg-hackathon.onrender.com'),
    );

    _channel!.stream.listen(
      (data) {
        final decoded = jsonDecode(data);
        if (onMessageCallback != null) {
          onMessageCallback!(decoded);
        }
      },
      onError: (error) {
        print('WebSocket error: $error');
      },
      onDone: () {
        print('WebSocket connection closed.');
      },
    );
  }

  void send(Map<String, dynamic> data) {
    if (_channel != null) {
      final encoded = jsonEncode(data);
      _channel!.sink.add(encoded);
    }
  }

  void setOnMessageCallback(Function(Map<String, dynamic>) callback) {
    onMessageCallback = callback;
  }

  void disconnect() {
    _channel?.sink.close();
  }
}
