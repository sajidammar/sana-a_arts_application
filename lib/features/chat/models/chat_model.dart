class ChatMessage {
  final int? id;
  final int conversationId;
  final String senderId;
  final String messageText;
  final DateTime timestamp;
  final bool isSeen;
  final String syncStatus; // synced, pending, failed

  ChatMessage({
    this.id,
    required this.conversationId,
    required this.senderId,
    required this.messageText,
    required this.timestamp,
    this.isSeen = false,
    this.syncStatus = 'synced',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'conversation_id': conversationId,
      'sender_id': senderId,
      'message_text': messageText,
      'timestamp': timestamp.toIso8601String(),
      'is_seen': isSeen ? 1 : 0,
      'sync_status': syncStatus,
    };
  }

  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    return ChatMessage(
      id: map['id'],
      conversationId: map['conversation_id'],
      senderId: map['sender_id'],
      messageText: map['message_text'],
      timestamp: DateTime.parse(map['timestamp']),
      isSeen: map['is_seen'] == 1,
      syncStatus: map['sync_status'] ?? 'synced',
    );
  }
}

class Conversation {
  final int? id;
  final String receiverId;
  final String receiverName;
  final String? receiverImage;
  final String? lastMessage;
  final DateTime? lastMessageTime;
  final DateTime createdAt;
  final DateTime updatedAt;

  Conversation({
    this.id,
    required this.receiverId,
    required this.receiverName,
    this.receiverImage,
    this.lastMessage,
    this.lastMessageTime,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'receiver_id': receiverId,
      'receiver_name': receiverName,
      'receiver_image': receiverImage,
      'last_message': lastMessage,
      'last_message_time': lastMessageTime?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory Conversation.fromMap(Map<String, dynamic> map) {
    return Conversation(
      id: map['id'],
      receiverId: map['receiver_id'],
      receiverName: map['receiver_name'],
      receiverImage: map['receiver_image'],
      lastMessage: map['last_message'],
      lastMessageTime: map['last_message_time'] != null
          ? DateTime.parse(map['last_message_time'])
          : null,
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: DateTime.parse(map['updated_at']),
    );
  }
}
