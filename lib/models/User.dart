class User {
  int? id;
  String firstname;
  String lastname;
  String email;
  bool isPublic;
  User(this.id, this.firstname, this.lastname, this.email, this.isPublic);

  bool isEqualTo(User other) {
    return id == other.id &&
        firstname == other.firstname &&
        lastname == other.lastname &&
        email == other.email;
  }

  String initials() {
    return (lastname[0] + firstname[0]).toUpperCase();
  }

  @override
  String toString() {
    return "User($id,$firstname,$lastname,$email,$isPublic)";
  }
}
