class SuccessModel {
  SuccessModel({
      this.success, 
      this.message,});

  SuccessModel.fromJson(dynamic json) {
    success = json['success'];
    message = json['message'];
  }
  bool? success;
  String? message;
SuccessModel copyWith({  bool? success,
  String? message,
}) => SuccessModel(  success: success ?? this.success,
  message: message ?? this.message,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = success;
    map['message'] = message;
    return map;
  }

}