class GroupWish {
  final int? id;
  final int idProposition;
  final int idGroup;

  GroupWish({
    this.id,
    required this.idProposition,
    required this.idGroup,
  });

  Map<String, dynamic> toJson() {
    return {
      'idProposition': idProposition,
      'idGroup': idGroup,
    };
  }

  static GroupWish fromJson(Map<String, dynamic> json) {
    return GroupWish (
      id: json['id'],
      idProposition: json['idProposition'],
      idGroup: json['idGroup'],
    );
  }
}

