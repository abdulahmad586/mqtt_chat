import 'dart:typed_data';

import 'package:chat/models/message.model.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class Conveyor {
  String host, username;
  int port;
  bool connecting = false;
  bool connected = false;
  bool connectionOpen = false;
  late MqttClient client;

  static String chatTopic = 'mqtt_chat';

  String previousTopic = '';
  bool bAlreadySubscribed = false;

  Function()? onConnected, onConnecting, onDisconnected, onRetry, onClose;

  Function(String) onMessageReceived = (str) {
    print("MEssage here!");
  };

  Function(dynamic)? onError;
  Function(Message message)? messageLogger;
  Function(Message message, {Uint8List? buffer})? chatRoomMessage;
  // DatabaseManager dman = DatabaseManager();
  Conveyor(
      {required this.host,
      required this.username,
      this.port = 9900,
      this.onConnected,
      this.onDisconnected,
      this.onRetry,
      this.onConnecting,
      this.onError,
      this.onClose}) {
    // dman.init();
  }

  connect() async {
    client = await _login();
  }

  Future<MqttClient> _login() async {
    client = MqttServerClient(host, 'chatapp/test');

    client.logging(on: true);
    client.keepAlivePeriod =
        10; // Must agree with the keep alive set above or not set

    final MqttConnectMessage connMess = MqttConnectMessage()
        // .authenticateAs('', '')
        .withWillTopic(username) // If you set this you must set a will message
        .withWillMessage('offline')
        .startClean() // Non persistent session for testing
        .withWillQos(MqttQos.atLeastOnce);
    log('Client connecting....');
    client.connectionMessage = connMess;

    /// Connect the client, any errors here are communicated by raising of the appropriate exception. Note
    /// in some circumstances the broker will just disconnect us, see the spec about this, we however eill
    /// never send malformed messages.
    try {
      await client.connect();
    } on Exception catch (e) {
      log('EXCEPTION::client exception - $e');
      if (onError != null) {
        onError!(e.toString());
      }
      client.disconnect();
      // client = null;
      return client;
    }

    /// Check we are connected
    if (client.connectionStatus!.state == MqttConnectionState.connected) {
      log('Client connected');
      if (onConnected != null) {
        onConnected!();
      }
    } else {
      /// Use status here rather than state if you also want the broker return code.
      log('client connection failed - disconnecting, status is ${client.connectionStatus}');
      client.disconnect();
      // client = null;
    }
    return client;
  }

  Future<bool> _connectToClient() async {
    if (client != null &&
        client.connectionStatus != null &&
        client.connectionStatus!.state == MqttConnectionState.connected) {
      print('already logged in');
    } else {
      client = await _login();
      if (client == null) {
        return false;
      }
    }
    return true;
  }

  Future<bool> subscribe(String topic, Function(Message) onMessage) async {
    if (await _connectToClient() == true) {
      /// Add the unsolicited disconnection callback
      client.onDisconnected = _onDisconnected;

      /// Add the successful connection callback
      client.onConnected = _onConnected;

      client.onSubscribed = _onSubscribed;
      // onMessage(Message(
      //     sender: topic,
      //     receivers: [username],
      //     type: Message.TYPE_PRIVATE,
      //     content: 'Subscribed!'));
      this.onMessageReceived = (str) {
        onMessage(Message(
            sender: topic,
            receivers: [username],
            type: Message.TYPE_PRIVATE,
            content: str));
      };
      _subscribe(topic);
    }
    return true;
  }

  /// The subscribed callback
  void _onSubscribed(String topic) {
    log('Subscription confirmed for topic $topic');
    bAlreadySubscribed = true;
    previousTopic = topic;
  }

  /// The unsolicited disconnect callback
  void _onDisconnected() {
    log('OnDisconnected client callback - Client disconnection');
    if (onDisconnected != null) {
      onDisconnected!();
    }
    if (client.connectionStatus?.returnCode ==
        MqttConnectReturnCode.notAuthorized) {
      if (onError != null) {
        onError!("Unauthorzed access");
      }
      log('Unauthorized access');
    }
    client.disconnect();
  }

  /// The successful connect callback
  void _onConnected() {
    log('OnConnected client callback - Client connection was sucessful');
    if (onConnected != null) {
      onConnected!();
    }
  }

  //static Stream<List<Watts>> wattsStream() {}
  //
  // uses the config/private.json asset to get the Adafruit broker and our
  // Adafruit IO key.  config/private.json should be a file in .gitignore.
  // the intent is to hide this private info in a file that is not sync'd
  // with gitHub.
  //
  // Future<Map> _getBrokerAndKey() async {
  // TODO: Check if private.json does not exist or expected key/values are not there.
  // String connect = await rootBundle.loadString('config/private.json');
  // return (json.decode(connect));
  // }

//
// Subscribe to the readings being published into Adafruit's mqtt by the energy monitor(s).
//
  Future _subscribe(String topic) async {
    client.subscribe(topic, MqttQos.exactlyOnce);

    client.updates!.listen((messageList) {
      // log("MESSAGE::: ${messageList[0].payload..toString()}");
      final recMess = messageList[0];
      if (recMess is! MqttReceivedMessage<MqttPublishMessage>) return;
      final pubMess = recMess.payload;
      final pt = MqttPublishPayload.bytesToString(pubMess.payload.message);
      log("RECEIVEDDDDD $pt");
      // print(
      //     'EXAMPLE::Change notification:: topic is <${recMess.topic}>, payload is <-- $pt -->');
      onMessageReceived(pt);
    });

    /// If needed you can listen for published messages that have completed the publishing
    /// handshake which is Qos dependant. Any message received on this stream has completed its
    /// publishing handshake with the broker.
    // ignore: avoid_types_on_closure_parameters
    // client.published!.listen((MqttPublishMessage message) {
    //   print(
    //       'EXAMPLE::Published notification:: topic is ${message.variableHeader!.topicName}, with Qos ${message.header!.qos}');
    // });
  }

//////////////////////////////////////////
// Publish to an (Adafruit) mqtt topic.
  Future<void> publish(String value) async {
    // Connect to the client if we haven't already
    if (await _connectToClient() == true) {
      final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
      builder.addString(value);
      client.publishMessage(username, MqttQos.atMostOnce, builder.payload!);
    }
  }

  void log(String str) {
    print("INFO:$str");
  }
}
