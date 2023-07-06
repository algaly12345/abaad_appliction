class SignUpBody {
  String fName;
  String phone;
  String email;
  String password;
  String refCode;
  int zone_id;
  int city_id;
  String membershipType;

  SignUpBody({this.fName, this.phone, this.email='', this.password, this.refCode = '',this.zone_id,this.city_id,this.membershipType});

  SignUpBody.fromJson(Map<String, dynamic> json) {
    fName = json['name'];
    phone = json['phone'];
    email = json['email'];
    password = json['password'];
    refCode = json['ref_code'];
    zone_id = json['zone_id'];
    city_id = json['city_id'];
    membershipType = json['membership_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.fName;
    data['phone'] = this.phone;
    data['email'] = this.email;
    data['password'] = this.password;
    data['ref_code'] = this.refCode;
    data['zone_id'] = this.zone_id;
    data['city_id'] = this.refCode;
    data['membership_type'] = this.membershipType;
    return data;
  }
}
