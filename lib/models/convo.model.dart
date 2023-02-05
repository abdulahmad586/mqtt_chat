class ConvoData {
  final String message;
  final payload;
  final int time;
  final String senderId;
  static const int TYPE_TEXT = 1;
  static const int TYPE_CALL_MISSED = 2;
  static const int TYPE_CALL_RECEIVED = 3;
  static const int TYPE_CALL_SENT = 4;
  static const int TYPE_WALLET_CR = 5;
  static const int TYPE_WALLET_DB = 6;
  static const int TYPE_PHOTO = 7;
  static const int TYPE_VIDEO = 8;
  static const int TYPE_AUDIO = 9;
  static const int TYPE_DOC = 10;
  static const int TYPE_CONTACT = 11;
  static const int TYPE_LOCATION = 12;

  static const int STAT_SENDING = 0;
  static const int STAT_SENT = 1;
  static const int STAT_RECEIVED = 2;
  static const int STAT_SEEN = 3;
  static const int STAT_ERROR = 4;

  final int type;
  int stat;

  String timeAgo = "0 secs ago";
  String timeStr = "0 secs ago";
  String sender = "";

  ConvoData(
      {this.message = "",
      this.time = 0,
      this.type = TYPE_TEXT,
      this.payload = "",
      this.senderId = '',
      this.sender = "",
      this.stat = STAT_SENDING}) {
    //sender= this.senderId;
    timeAgo = this.time.toString() + " ago";
    timeStr = DateTime.fromMillisecondsSinceEpoch(this.time).toString();
  }
}
