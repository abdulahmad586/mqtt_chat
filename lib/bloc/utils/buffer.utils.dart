import 'dart:convert';
import 'dart:typed_data';

class BufferUtils {
  static concatWithPayload(Map<String, dynamic> object, Uint8List data) {
    String jsonObj = jsonEncode(object);
    Uint8List payload = BufferUtils.toUint8List(jsonObj);
    int payloadSize = payload.length;

    var idBuf = List<int>.filled(5, 0);
    idBuf.setRange(0, (payloadSize.toString()).length,
        BufferUtils.toUint8List(payloadSize.toString()));

    var builder = BytesBuilder();
    builder.add(idBuf);
    builder.add(payload);
    builder.add(data);
    return builder.toBytes();
  }

  static List<Uint8List> parseMergedBuffers(Uint8List bytes) {
    // int lengthOfPayload = bytes[0];
    int lengthOfPayload = 255;
    int dataLength = bytes.length;
    try {
      lengthOfPayload = int.parse(
          BufferUtils.fromUint8List(BufferUtils.trim(bytes.sublist(0, 5))));
    } catch (e) {
      print("Error getting length of payload " + e.toString());
    }

//    print("Length of data "+dataLength.toString()+" | payload : "+lengthOfPayload.toString());
    return [
      bytes.sublist(5, lengthOfPayload + 5),
      bytes.sublist(5 + lengthOfPayload, dataLength)
    ];
  }

  static String fromUint8List(Uint8List data) {
    return String.fromCharCodes(data);
  }

  static Uint8List toUint8List(String str) {
    List<int> list = str.codeUnits;
    return Uint8List.fromList(list);
  }

  static Uint8List trim(Uint8List list) {
    int end = list.length;

    for (int i = 0; i < list.length; i++) {
      if (list[i] == 0) {
        end = i;
        break;
      }
    }

    return list.sublist(0, end);
  }
}
