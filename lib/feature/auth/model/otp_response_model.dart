class OtpResponseModel {
  OtpResponseModel({
      this.success, 
      this.message,});

  OtpResponseModel.fromJson(dynamic json) {
    success = json['success'];
    message = json['message'];
  }
  bool? success;
  String? message;
OtpResponseModel copyWith({  bool? success,
  String? message,
}) => OtpResponseModel(  success: success ?? this.success,
  message: message ?? this.message,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = success;
    map['message'] = message;
    return map;
  }

}