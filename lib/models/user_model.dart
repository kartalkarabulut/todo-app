class Kullanici {
  Kullanici({
    this.userId,
    required this.name,
    required this.surname,
    required this.email,
    required this.password,
  });

  factory Kullanici.fromJson(Map<String, dynamic> json) {
    return Kullanici(
      userId: json['userId'],
      name: json['name'],
      surname: json['surname'],
      email: json['email'],
      password: json['password'],
    );
  }

  String email;
  String name;
  String password;
  String surname;
  String? userId;

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'name': name,
      'surname': surname,
      'email': email,
      'password': password,
    };
  }

  Kullanici copyWith({
    String? userId,
    String? name,
    String? surname,
    String? email,
    String? password,
  }) {
    return Kullanici(
      userId: userId ?? this.userId,
      name: name ?? this.name,
      surname: surname ?? this.surname,
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }
}
