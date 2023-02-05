import 'dart:math';

class StringUtils {
  static final _chars ='AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random();

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  static int stringToIntId(String str){
    try{
//      print("ID is "+str);

      int res = int.parse(str.codeUnits.join().trim());
      if(res > 1000000000){
        res = (res/1000000).floor();
      }
      return res;
    }catch(e){
      return 1;
    }
  }

}
