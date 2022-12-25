class SignUpBody {
  String fName;
  String phone;
  String email;
  String password;
  String refCode;

  SignUpBody({this.fName, this.phone, this.email='', this.password, this.refCode = ''});

  SignUpBody.fromJson(Map<String, dynamic> json) {
    fName = json['name'];
    phone = json['phone'];
    email = json['email'];
    password = json['password'];
    refCode = json['ref_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.fName;
    data['phone'] = this.phone;
    data['email'] = this.email;
    data['password'] = this.password;
    data['ref_code'] = this.refCode;
    return data;
  }
}
