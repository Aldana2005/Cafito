class Users {
  int? id;
  String? name;
  String? password;
  String? role;

  Users({
    this.id,
    this.name,
    this.password,

    this.role,
  });

  Map<String, dynamic> toMap(){
    return {
      'id':id,
      'name':name,
      'password':password,
      'role':role
    };
  }
}