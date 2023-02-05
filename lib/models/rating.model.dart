class Rating{
  int id;
  String user;
  double rating;
  int time;

  Rating({this.id=0, required this.user, this.rating=1, this.time=0}){
    if(id==0){
      id = (DateTime.now().millisecondsSinceEpoch/1000).ceil();
    }
    if(time==0){
      time = (DateTime.now().millisecondsSinceEpoch/1000).ceil();
    }
  }

  static parseRating(Map<String, dynamic> obj) {
    return Rating(
      id: obj.containsKey("id") ? obj["id"] : 0,
      time: obj.containsKey("time") ? obj["time"] : 0,
      rating: obj.containsKey("rating") ? double.parse(obj["rating"].toString()) : 0,
      user: obj.containsKey("user") ? obj["user"] : '',
    );
  }

  toMap({toDb=false}) {
    return {"id": id, "time": time, "rating": rating, "user": user};
  }

}