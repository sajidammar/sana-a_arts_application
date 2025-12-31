import 'package:flutter/material.dart';
import 'package:sanaa_artl/core/utils/database/database_helper.dart';
import 'package:sanaa_artl/core/utils/database/dao/user_dao.dart';
import 'package:sanaa_artl/core/utils/database/dao/exhibition_dao.dart';
import 'package:sanaa_artl/core/utils/database/dao/artwork_dao.dart';

class GlobalManagementController {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  final UserDao _userDao = UserDao();
  final ExhibitionDao _exhibitionDao = ExhibitionDao();
  final ArtworkDao _artworkDao = ArtworkDao();

  // --- Users Management ---
  Future<List<Map<String, dynamic>>> getAllUsers() async {
    final db = await _dbHelper.database;
    return await db.query('users');
  }

  Future<void> updateUserRole(String userId, String role) async {
    await _userDao.updateUser(userId, {'role': role});
  }

  // --- Exhibition Management ---
  Future<List<Map<String, dynamic>>> getAllExhibitions() async {
    return await _exhibitionDao.getAllExhibitions();
  }

  Future<void> toggleExhibitionStatus(String id, bool isActive) async {
    await _exhibitionDao.updateExhibition(id, {'is_active': isActive ? 1 : 0});
  }

  // --- Store/Artworks Management ---
  Future<List<Map<String, dynamic>>> getAllArtworks() async {
    return await _artworkDao.getAllArtworks();
  }

  Future<void> deleteArtwork(String id) async {
    await _artworkDao.deleteArtwork(id);
  }

  // --- Reports & Comments Management ---
  Future<List<Map<String, dynamic>>> getAllReports() async {
    final db = await _dbHelper.database;
    return await db.query('admin_reports', orderBy: 'created_at DESC');
  }

  Future<void> updateReportStatus(String id, String status) async {
    final db = await _dbHelper.database;
    await db.update(
      'admin_reports',
      {'status': status},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteTargetContent(String targetId, String targetType) async {
    final db = await _dbHelper.database;
    if (targetType == 'post') {
      await db.delete('posts', where: 'id = ?', whereArgs: [targetId]);
    } else if (targetType == 'comment') {
      await db.delete('comments', where: 'id = ?', whereArgs: [targetId]);
    } else if (targetType == 'reel') {
      await db.delete('reels', where: 'id = ?', whereArgs: [targetId]);
    }
  }

  Future<List<Map<String, dynamic>>> getAllComments() async {
    final db = await _dbHelper.database;
    return await db.query('comments');
  }

  // --- Requests Management ---
  Future<List<Map<String, dynamic>>> getAllRequests() async {
    final db = await _dbHelper.database;
    return await db.query('admin_requests', orderBy: 'created_at DESC');
  }

  Future<void> updateRequestStatus(String id, String status) async {
    final db = await _dbHelper.database;
    await db.update(
      'admin_requests',
      {'status': status, 'updated_at': DateTime.now().toIso8601String()},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // --- Community/Posts Management ---
  Future<List<Map<String, dynamic>>> getAllPosts() async {
    final db = await _dbHelper.database;
    return await db.query('posts');
  }

  Future<void> deletePost(String postId) async {
    final db = await _dbHelper.database;
    await db.delete('posts', where: 'id = ?', whereArgs: [postId]);
  }

  // --- Notifications (Mock for now or integrate with a table if exists) ---
  Future<void> sendGlobalNotification(String title, String message) async {
    // Logic to insert into a notifications table that the main app reads
    debugPrint('Sending Notification: $title - $message');
  }
}
