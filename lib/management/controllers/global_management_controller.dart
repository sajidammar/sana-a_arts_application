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
  Future<List<Map<String, dynamic>>> getAllComments() async {
    final db = await _dbHelper.database;
    return await db.query('comments');
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


