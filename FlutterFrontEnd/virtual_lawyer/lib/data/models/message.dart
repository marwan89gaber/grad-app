class Message {
  final String text;
  final bool isUser;
  final bool isAttachment;
  final String? attachmentName;
  
  Message({
    required this.text, 
    required this.isUser,
    this.isAttachment = false,
    this.attachmentName,
  });
}
