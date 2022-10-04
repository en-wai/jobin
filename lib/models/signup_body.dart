class SignUpBody {
  String fName;
  String phone;
  String email;
  String password;

  SignUpBody({required this.fName,

    required this.phone,
    this.email='', required this.password});

 factory SignUpBody.fromJson(Map<String, dynamic> json) {
   return SignUpBody(
       fName : json['f_name'],

       phone : json['phone'],
       email : json['email'],
       password : json['password']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['f_name'] = this.fName;

    data['phone'] = this.phone;
    data['email'] = this.email;
    data['password'] = this.password;
    return data;
  }
}