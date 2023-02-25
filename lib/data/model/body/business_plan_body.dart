class BusinessPlanBody {
  String businessPlan;
  String estateId;
  String packageId;
  String payment;

  BusinessPlanBody({this.businessPlan, this.estateId, this.packageId, this.payment});

  BusinessPlanBody.fromJson(Map<String, dynamic> json) {
    businessPlan = json['business_plan'];
    estateId = json['restaurant_id'];
    packageId = json['package_id'];
    payment = json['payment'];
  }

  Map<String, String> toJson() {
    final Map<String, String> data = new Map<String, String>();
    data['business_plan'] = this.businessPlan;
    data['restaurant_id'] = this.estateId;
    data['package_id'] = this.packageId;
    data['payment'] = this.payment;
    return data;
  }
}
