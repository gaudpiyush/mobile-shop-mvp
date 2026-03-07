class InquiryModel {
  final String id;
  final String userId;
  final String mobileId;
  final String questionText;
  final String? vendorReply;
  final DateTime timestamp;

  InquiryModel({
    required this.id,
    required this.userId,
    required this.mobileId,
    required this.questionText,
    this.vendorReply,
    required this.timestamp,
  });

  factory InquiryModel.fromJson(Map<String, dynamic> json) => InquiryModel(
        id: json['id'],
        userId: json['user_id'],
        mobileId: json['mobile_id'],
        questionText: json['question_text'],
        vendorReply: json['vendor_reply'],
        timestamp: DateTime.parse(json['timestamp']),
      );
}