class User {
  int? id;
  String firstname;
  String lastname;
  String email;
  User(this.id, this.firstname, this.lastname, this.email);

  bool isEqualTo(User other) {
    return id == other.id &&
        firstname == other.firstname &&
        lastname == other.lastname &&
        email == other.email;
  }

  String initials() {
    return (lastname[0] + firstname[0]).toUpperCase();
  }
}
