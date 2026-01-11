import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path/path.dart' as path;
import 'package:sanaa_artl/core/controllers/app_status_provider.dart';
import 'package:flutter/material.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  // Root folder name
  static const String rootFolder = 'SanaaArt';

  // Subfolders
  static const String mediaFolder = 'Media';
  static const String cacheFolder = 'Cache';
  static const String databasesFolder = 'Databases';

  // Media Subfolders
  static const String videosFolder = 'SanaaArt Videos';
  static const String imagesFolder = 'SanaaArt Images';
  static const String docsFolder = 'SanaaArt Documents';
  static const String profileFolder = 'SanaaArt Profile';

  Future<void> initialize(AppStatusProvider statusProvider) async {
    bool hasPermission = await requestPermissions(statusProvider);

    if (hasPermission) {
      await _createFolderStructure();
      statusProvider.removeAlert('storage_permission_needed');
    } else {
      statusProvider.addAlert(
        SystemAlert(
          id: 'storage_permission_needed',
          message: 'التطبيق يحتاج لصلاحية التخزين لحفظ الصور والفيديوهات',
          type: AlertType.warning,
          icon: Icons.storage,
        ),
      );
    }
  }

  /// Request all necessary permissions
  Future<bool> requestPermissions(AppStatusProvider statusProvider) async {
    if (kIsWeb) return true;

    try {
      if (Platform.isAndroid) {
        try {
          final androidInfo = await DeviceInfoPlugin().androidInfo;
          if (androidInfo.version.sdkInt >= 33) {
            // Android 13+
            Map<Permission, PermissionStatus> statuses = await [
              Permission.photos,
              Permission.videos,
              Permission.audio,
              Permission.camera,
              Permission.notification,
            ].request();

            return statuses.values.every(
              (status) => status.isGranted || status.isLimited,
            );
          } else {
            // Android 12 and below
            Map<Permission, PermissionStatus> statuses = await [
              Permission.storage,
              Permission.camera,
            ].request();

            return statuses.values.every((status) => status.isGranted);
          }
        } catch (e) {
          // Fallback for MissingPluginException or other errors in DeviceInfo
          Map<Permission, PermissionStatus> statuses = await [
            Permission.storage,
            Permission.camera,
          ].request();
          return statuses.values.every((status) => status.isGranted);
        }
      } else if (Platform.isIOS) {
        Map<Permission, PermissionStatus> statuses = await [
          Permission.photos,
          Permission.camera,
          Permission.microphone,
          Permission.notification,
        ].request();

        return statuses.values.every(
          (status) => status.isGranted || status.isLimited,
        );
      }
    } catch (e) {
      // إذا فشلت مكتبة الصلاحيات نفسها (MissingPluginException)
      statusProvider.addAlert(
        SystemAlert(
          id: 'permission_plugin_error',
          message: 'عذراً، نظام إدارة الصلاحيات غير متاح حالياً.',
          type: AlertType.warning,
          icon: Icons.warning_amber_rounded,
        ),
      );
      return true;
    }

    return true;
  }

  /// Create the SanaaArt directory structure
  Future<void> _createFolderStructure() async {
    try {
      Directory baseDir;

      if (Platform.isAndroid) {
        // Try getting external storage for a WhatsApp-like experience
        // Note: For Android 11+, writing to root is restricted unless MANAGE_EXTERNAL_STORAGE is used.
        // We will default to the app's external files directory which is safer but still accessible.
        final externalDir = await getExternalStorageDirectory();
        if (externalDir != null) {
          // Move up from Android/data/com.example.app/files/
          baseDir = externalDir;
        } else {
          baseDir = await getApplicationDocumentsDirectory();
        }
      } else {
        baseDir = await getApplicationDocumentsDirectory();
      }

      // 1. Root: SanaaArt/
      final rootPath = path.join(baseDir.path, rootFolder);
      await _createDir(rootPath);

      // 2. SanaaArt/Media/
      final mediaPath = path.join(rootPath, mediaFolder);
      await _createDir(mediaPath);

      // 3. SanaaArt/Cache/ (WhatsApp-like cache)
      final cachePath = path.join(rootPath, cacheFolder);
      await _createDir(cachePath);

      // 4. SanaaArt/Databases/ (Local Encrypted Chat DBs)
      final dbPath = path.join(rootPath, databasesFolder);
      await _createDir(dbPath);

      // Media Subfolders
      await _createDir(path.join(mediaPath, videosFolder));
      await _createDir(path.join(mediaPath, imagesFolder));
      await _createDir(path.join(mediaPath, docsFolder));
      await _createDir(path.join(mediaPath, profileFolder));
    } catch (e) {
      // Error creating folder structure
    }
  }

  Future<void> _createDir(String path) async {
    final dir = Directory(path);
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
  }

  /// Get the specific folder path
  Future<String> getFolderPath(String folderName) async {
    Directory baseDir;
    if (Platform.isAndroid) {
      final externalDir = await getExternalStorageDirectory();
      baseDir = externalDir ?? await getApplicationDocumentsDirectory();
    } else {
      baseDir = await getApplicationDocumentsDirectory();
    }

    // We navigate to the subfolder
    if (folderName == rootFolder) return path.join(baseDir.path, rootFolder);

    // Media subfolders
    if ([
      videosFolder,
      imagesFolder,
      docsFolder,
      profileFolder,
    ].contains(folderName)) {
      return path.join(baseDir.path, rootFolder, mediaFolder, folderName);
    }

    // Other subfolders
    return path.join(baseDir.path, rootFolder, folderName);
  }

  /// Save a file to the custom structure
  Future<File?> saveMediaFile(File sourceFile, String targetFolder) async {
    try {
      final targetPath = await getFolderPath(targetFolder);
      final fileName = path.basename(sourceFile.path);
      final newFile = await sourceFile.copy(path.join(targetPath, fileName));
      return newFile;
    } catch (e) {
      return null;
    }
  }
}
