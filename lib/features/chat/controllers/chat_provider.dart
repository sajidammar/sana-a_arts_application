import 'package:flutter/material.dart';
import 'package:sanaa_artl/core/utils/database/database_helper.dart';
import 'package:sanaa_artl/core/utils/database/database_constants.dart';
import 'package:sanaa_artl/core/services/connectivity_service.dart';
import 'package:sanaa_artl/core/services/notification_service.dart';
import '../models/chat_model.dart';

class ChatProvider extends ChangeNotifier {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Conversation> _conversations = [];
  List<ChatMessage> _currentMessages = [];
  bool _isLoading = false;

  List<Conversation> get conversations => _conversations;
  List<ChatMessage> get currentMessages => _currentMessages;
  bool get isLoading => _isLoading;

  ChatProvider() {
    _setupConnectivityListener();
  }

  void _setupConnectivityListener() {
    ConnectivityService().isConnected.addListener(() {
      if (ConnectivityService().isConnected.value) {
        syncPendingMessages();
      }
    });
  }

  Future<void> loadConversations() async {
    _isLoading = true;
    notifyListeners();

    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      DatabaseConstants.tableConversations,
      orderBy: '${DatabaseConstants.colUpdatedAt} DESC',
    );

    _conversations = maps.map((map) => Conversation.fromMap(map)).toList();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadMessages(int conversationId) async {
    _isLoading = true;
    notifyListeners();

    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      DatabaseConstants.tableMessages,
      where: '${DatabaseConstants.colConversationId} = ?',
      whereArgs: [conversationId],
      orderBy: '${DatabaseConstants.colTimestamp} ASC',
    );

    _currentMessages = maps.map((map) => ChatMessage.fromMap(map)).toList();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> sendMessage({
    required String receiverId,
    required String receiverName,
    String? receiverImage,
    required String senderId,
    required String text,
  }) async {
    final db = await _dbHelper.database;
    final now = DateTime.now();

    // Check if conversation exists
    final List<Map<String, dynamic>> existing = await db.query(
      DatabaseConstants.tableConversations,
      where: '${DatabaseConstants.colReceiverId} = ?',
      whereArgs: [receiverId],
    );

    int conversationId;
    if (existing.isEmpty) {
      // Create new conversation
      conversationId = await db.insert(DatabaseConstants.tableConversations, {
        DatabaseConstants.colReceiverId: receiverId,
        DatabaseConstants.colReceiverName: receiverName,
        DatabaseConstants.colReceiverImage: receiverImage,
        DatabaseConstants.colLastMessage: text,
        DatabaseConstants.colLastMessageTime: now.toIso8601String(),
        DatabaseConstants.colCreatedAt: now.toIso8601String(),
        DatabaseConstants.colUpdatedAt: now.toIso8601String(),
      });
    } else {
      conversationId = existing.first[DatabaseConstants.colId];
      // Update conversation
      await db.update(
        DatabaseConstants.tableConversations,
        {
          DatabaseConstants.colLastMessage: text,
          DatabaseConstants.colLastMessageTime: now.toIso8601String(),
          DatabaseConstants.colUpdatedAt: now.toIso8601String(),
        },
        where: '${DatabaseConstants.colId} = ?',
        whereArgs: [conversationId],
      );
    }

    final isOnline = await ConnectivityService().checkCurrentStatus();

    // Insert message
    final message = ChatMessage(
      conversationId: conversationId,
      senderId: senderId,
      messageText: text,
      timestamp: now,
      syncStatus: isOnline ? 'synced' : 'pending',
    );

    if (!isOnline) {
      await NotificationService().showNotification(
        id: 2,
        title: 'جاري الانتظار للإرسال',
        body: 'سيتم إرسال الرسالة عند الاتصال بالانترنت',
        isPersistent: true,
      );
    }

    await db.insert(DatabaseConstants.tableMessages, message.toMap());

    // Refresh data
    await loadConversations();

    // Always refresh messages if we are currently looking at this conversation
    // or if the current message list is empty (first message in a new conversation)
    if (_currentMessages.isEmpty ||
        (_currentMessages.isNotEmpty &&
            _currentMessages.first.conversationId == conversationId)) {
      await loadMessages(conversationId);
    }
  }

  Future<void> deleteConversation(int id) async {
    final db = await _dbHelper.database;
    await db.delete(
      DatabaseConstants.tableConversations,
      where: '${DatabaseConstants.colId} = ?',
      whereArgs: [id],
    );
    await loadConversations();
  }

  Future<void> syncPendingMessages() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      DatabaseConstants.tableMessages,
      where: 'sync_status = ?',
      whereArgs: ['pending'],
    );

    final pending = maps.map((map) => ChatMessage.fromMap(map)).toList();
    if (pending.isEmpty) return;

    for (var msg in pending) {
      try {
        await Future.delayed(const Duration(seconds: 1));

        await db.update(
          DatabaseConstants.tableMessages,
          {'sync_status': 'synced'},
          where: 'id = ?',
          whereArgs: [msg.id],
        );

        // Refresh UI if needed
        if (_currentMessages.any((m) => m.id == msg.id)) {
          await loadMessages(msg.conversationId);
        }

        await NotificationService().showNotification(
          id: msg.id ?? 999,
          title: 'تم إرسال الرسالة ✅',
          body: 'تم إرسال رسالتك: "${msg.messageText}"',
        );

        await NotificationService().cancelNotification(2);
      } catch (e) {
        // Error syncing message
      }
    }

    await loadConversations();
  }
}
