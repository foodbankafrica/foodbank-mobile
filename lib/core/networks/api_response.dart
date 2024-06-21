class ApiResponse<T> {
  final bool status;
  final String? message, error, type;
  final T? data;

  ApiResponse({
    required this.status,
    this.message,
    this.error,
    this.type,
    this.data,
  });

  bool get isSuccessful => status;
  bool get isUnSuccessful => !status;

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      status: json["success"] ?? json["results"] != null,
      message: json["message"] ?? json["error"] ?? "",
      error: json["error"] ?? json["message"] ?? "",
      type: json["type"] ?? "",
      data: json["data"] ?? json["results"],
    );
  }

  @override
  String toString() {
    return "ApiResponse: status $status, message $message, data $data";
    // return message ?? 'Unknown';
  }
}
