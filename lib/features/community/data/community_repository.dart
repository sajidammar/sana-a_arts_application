import 'package:sanaa_artl/core/utils/result.dart';
import 'package:sanaa_artl/features/community/models/post.dart';

abstract class CommunityRepository {
  Future<Result<List<Post>>> getPosts();
  Future<Result<Post>> addPost({
    required String content,
    String? imageUrl,
    required String authorId,
  });
  Future<Result<void>> deletePost(String postId);
  Future<Result<bool>> toggleLike(String postId, String userId);
  Future<Result<Comment>> addComment({
    required String postId,
    required String content,
    required String authorId,
  });
}
