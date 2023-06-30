// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$commentsCountHash() => r'157acc966fee1f76628954d70d9e6bcd166525c4';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

typedef CommentsCountRef = AutoDisposeStreamProviderRef<CommentInfo>;

/// See also [commentsCount].
@ProviderFor(commentsCount)
const commentsCountProvider = CommentsCountFamily();

/// See also [commentsCount].
class CommentsCountFamily extends Family<AsyncValue<CommentInfo>> {
  /// See also [commentsCount].
  const CommentsCountFamily();

  /// See also [commentsCount].
  CommentsCountProvider call(
    int postId,
  ) {
    return CommentsCountProvider(
      postId,
    );
  }

  @override
  CommentsCountProvider getProviderOverride(
    covariant CommentsCountProvider provider,
  ) {
    return call(
      provider.postId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'commentsCountProvider';
}

/// See also [commentsCount].
class CommentsCountProvider extends AutoDisposeStreamProvider<CommentInfo> {
  /// See also [commentsCount].
  CommentsCountProvider(
    this.postId,
  ) : super.internal(
          (ref) => commentsCount(
            ref,
            postId,
          ),
          from: commentsCountProvider,
          name: r'commentsCountProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$commentsCountHash,
          dependencies: CommentsCountFamily._dependencies,
          allTransitiveDependencies:
              CommentsCountFamily._allTransitiveDependencies,
        );

  final int postId;

  @override
  bool operator ==(Object other) {
    return other is CommentsCountProvider && other.postId == postId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, postId.hashCode);

    return _SystemHash.finish(hash);
  }
}
// ignore_for_file: unnecessary_raw_strings, subtype_of_sealed_class, invalid_use_of_internal_member, do_not_use_environment, prefer_const_constructors, public_member_api_docs, avoid_private_typedef_functions
