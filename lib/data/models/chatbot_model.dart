class ChatbotModel {
  final String text;
  final String senderType;
  final DateTime? createdAt;

  bool get isUser => senderType == 'human';

  const ChatbotModel({
    required this.text,
    required this.senderType,
    this.createdAt,
  });

  factory ChatbotModel.fromJson(Map<String, dynamic> json) {
    return ChatbotModel(
      text: json['text'] as String,
      senderType: json['senderType'] as String,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'text': text,
        'senderType': senderType,
        'createdAt': createdAt?.toIso8601String(),
      };
}