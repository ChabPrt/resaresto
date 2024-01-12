class GroupUsers {
  final int? id;
  final int idUser;
  final int idGroup;

  GroupUsers({
    this.id,
    required this.idUser,
    required this.idGroup,
  });

  Map<String, dynamic> toJson() {
    return {
      'idUser': idUser,
      'idGroup': idGroup,
    };
  }

  static GroupUsers fromJson(Map<String, dynamic> json) {
    return GroupUsers (
      id: json['id'],
      idUser: json['idUser'],
      idGroup: json['idGroup'],
    );
  }
}

