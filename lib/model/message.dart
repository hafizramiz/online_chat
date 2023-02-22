class Message {
  final String content;

  Message({required this.content});

  Message.fromJson(Map<String, dynamic> json) : this.content = json["content"];

  Map<String, dynamic> toJson() {
    return {"content": this.content};
  }
}
