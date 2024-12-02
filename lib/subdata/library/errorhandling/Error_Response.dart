class ErrorResponse {
  bool? success;
  int? code;
  String? locale;
  String? message;
  int? statusCode;

  ErrorResponse({this.success, this.code, this.locale, this.message});

  ErrorResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    code = json['code'];
    locale = json['locale'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['code'] = this.code;
    data['locale'] = this.locale;
    data['message'] = this.message;
    return data;
  }
}
