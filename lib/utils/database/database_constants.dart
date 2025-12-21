/// ثوابت قاعدة البيانات
/// يحتوي على أسماء الجداول والأعمدة لتجنب الأخطاء الإملائية
class DatabaseConstants {
  // Database Info
  static const String databaseName = 'sanaa_arts.db';
  static const int databaseVersion = 2;

  // Table Names
  static const String tableUsers = 'users';
  static const String tableUserPreferences = 'user_preferences';
  static const String tablePosts = 'posts';
  static const String tableComments = 'comments';
  static const String tableLikes = 'likes';
  static const String tableArtworks = 'artworks';
  static const String tableArtists = 'artists';
  static const String tableExhibitions = 'exhibitions';
  static const String tableFollowers = 'followers';
  static const String tableArtworkLikes = 'artwork_likes';
  static const String tableCartItems = 'cart_items';
  static const String tableWishlist = 'wishlist';

  // Common Columns
  static const String colId = 'id';
  static const String colCreatedAt = 'created_at';
  static const String colUpdatedAt = 'updated_at';

  // Users Columns
  static const String colName = 'name';
  static const String colEmail = 'email';
  static const String colPhone = 'phone';
  static const String colProfileImage = 'profile_image';
  static const String colRole = 'role';
  static const String colJoinDate = 'join_date';
  static const String colLastLogin = 'last_login';
  static const String colIsEmailVerified = 'is_email_verified';
  static const String colIsPhoneVerified = 'is_phone_verified';
  static const String colPoints = 'points';
  static const String colMembershipLevel = 'membership_level';

  // User Preferences Columns
  static const String colUserId = 'user_id';
  static const String colDarkMode = 'dark_mode';
  static const String colNotifications = 'notifications';
  static const String colEmailNotifications = 'email_notifications';
  static const String colSmsNotifications = 'sms_notifications';
  static const String colLanguage = 'language';
  static const String colCurrency = 'currency';
  static const String colThemeColor = 'theme_color';

  // Posts Columns
  static const String colAuthorId = 'author_id';
  static const String colContent = 'content';
  static const String colImageUrl = 'image_url';
  static const String colTimestamp = 'timestamp';

  // Comments Columns
  static const String colPostId = 'post_id';

  // Artworks Columns
  static const String colTitle = 'title';
  static const String colArtistId = 'artist_id';
  static const String colYear = 'year';
  static const String colTechnique = 'technique';
  static const String colDimensions = 'dimensions';
  static const String colDescription = 'description';
  static const String colPrice = 'price';
  static const String colCategory = 'category';
  static const String colTags = 'tags';
  static const String colIsFeatured = 'is_featured';
  static const String colIsForSale = 'is_for_sale';
  static const String colViews = 'views';
  static const String colLikes = 'likes';
  static const String colRating = 'rating';
  static const String colRatingCount = 'rating_count';

  // Artists Columns
  static const String colBio = 'bio';
  static const String colSpecialization = 'specialization';
  static const String colYearsOfExperience = 'years_of_experience';
  static const String colLocation = 'location';
  static const String colWebsite = 'website';
  static const String colFollowers = 'followers';
  static const String colIsVerified = 'is_verified';

  // Exhibitions Columns
  static const String colStartDate = 'start_date';
  static const String colEndDate = 'end_date';
  static const String colCurator = 'curator';
  static const String colType = 'type';
  static const String colStatus = 'status';
  static const String colDate = 'date';
  static const String colArtworksCount = 'artworks_count';
  static const String colVisitorsCount = 'visitors_count';
  static const String colIsActive = 'is_active';
  static const String colIsLiked = 'is_liked';

  // Followers Columns
  static const String colFollowerId = 'follower_id';
  static const String colFollowingId = 'following_id';
}
