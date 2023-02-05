class Channel{

  int id;
  String name;
  String desc;
  String owner;
  bool isBlocked;
  bool subscribed;
  bool blocked;

  Channel({required this.name, this.id=0, required this.desc, this.owner = "", this.isBlocked = false, this.subscribed = false, this.blocked=false});

  static parseChannel(Map<String, dynamic> obj){
    return Channel(
      id: obj.containsKey("id")?obj["id"]:0,
      name: obj.containsKey("name")?obj["name"]:'',
      desc: obj.containsKey("desc")?obj["desc"]:'',
      owner: obj.containsKey("owner")?obj["owner"]:'',
      isBlocked: obj.containsKey("isBlocked")?(obj["isBlocked"] is int ? (obj["isBlocked"] ==1 ? true : false) : obj["isBlocked"] ):false,
      subscribed: obj.containsKey("subscribed")?(obj["subscribed"] is int ? (obj["subscribed"] ==1 ? true : false) : obj["subscribed"] ):false,
      blocked: obj.containsKey("blocked")?(obj["blocked"] is int ? (obj["blocked"] ==1 ? true : false) : obj["blocked"] ):false,
    );
  }

  static List<Channel> parseMany(List<dynamic>  items){
    return List.generate(items.length, (index)=> parseChannel(Map<String, dynamic>.from(items[index])));
  }

  toMap({toDb=false}){

    return {
      "id":id,
      "name":name,
      "desc":desc,
      "owner":owner,
      "isBlocked":toDb?(isBlocked?1:0):isBlocked,
      "subscribed":toDb?(subscribed?1:0):subscribed,
      "blocked":toDb?(blocked?1:0):blocked,
    };

  }
}