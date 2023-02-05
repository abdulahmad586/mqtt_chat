import 'dart:convert';

class User {
  String name, fname, about;
  String deviceId;
  int id, lastContact;
  Map<String, int> rating;
  bool isBlocked;
  double totalRating = 0;

  static const defaultRating = {"s1":0,"s2":0,"s3":0,"s4":0,"s5":0};

  User({required this.name, this.fname="", required this.id, this.isBlocked = false, this.lastContact=0,this.deviceId="", this.rating=defaultRating, this.about=""}){
    totalRating = calculateRating(rating);
  }

  static double calculateRating(ratingData){
    int fiveStar = ratingData["s5"];
    int fourStar = ratingData["s4"];
    int threeStar = ratingData["s3"];
    int twoStar = ratingData["s2"];
    int oneStar = ratingData["s1"];

    double rating = ( (5 * fiveStar) + (4 * fourStar) + (3 * threeStar) + (2 * twoStar) + (1 * oneStar) ) / (fiveStar+fourStar+threeStar+twoStar+oneStar);
    return rating;
  }

  static parseUser(Map<String, dynamic> obj) {
    return User(
      id: obj.containsKey("id") ? obj["id"] : 0,
      lastContact: obj.containsKey("lastContact") ? obj["lastContact"] : DateTime.now().millisecondsSinceEpoch,
      rating: obj.containsKey("rating") ? (obj["rating"] is String ? jsonDecode(obj["rating"]): Map<String,int>.from(obj["rating"])) : defaultRating,
      name: obj.containsKey("name") ? obj["name"] : '',
      fname: obj.containsKey("fname") ? obj["fname"] : '',
      about: obj.containsKey("about") ? obj["about"] : '',
      isBlocked: obj.containsKey("isBlocked") ? (obj["isBlocked"] is int ? (obj["isBlocked"] == 1?true:false) : obj["isBlocked"]): false,
      deviceId: obj.containsKey("deviceId") ? obj["deviceId"] : '',
    );
  }

  static List<User> parseMany(List<Map<String, dynamic>>  items){
    return List.generate(items.length, (index)=> parseUser(items[index]));
  }

  toMap({toDb=false}) {
    return {"deviceId":deviceId,"id": id, "name": name, "fname": fname,"isBlocked": isBlocked?1:0, "rating": toDb?jsonEncode(rating):rating, "about":about};
  }
}
