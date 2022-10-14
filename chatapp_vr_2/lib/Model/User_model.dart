class UserModel {
  final String name;
  final String id;
  //final String profilePic;
  //final bool isOnline;
  final String status;
  final String phone;
  // final List<String> groupId;

  UserModel({
    required this.name,
    required this.id,
    //required this.profilePic,
    // required this.isOnline,
    required this.phone,
    // required this.groupId,
    required this.status,
  });
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'id': id,
      //'profilePic': profilePic,
      //'isOnline': isOnline,
      'phone': phone,
      //'groupId': groupId,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] ?? '',
      id: map['id'] ?? '',
      status: map['status'] ?? false,
      phone: map['phone'] ?? '',
    );
  }
}
