class User {
  final String name;
  final String surname;
  final int age;
  final String city;

  User({this.name, this.surname, this.age, this.city});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['NAME'],
      surname: json['SURNAME'],
      age: json['AGE'],
      city: json['CITY'],
    );
  }
}
