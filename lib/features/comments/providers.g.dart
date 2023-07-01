// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$commentsQueryHash() => r'33436127eedbad90341529036bb61868be3ce46f';

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

typedef CommentsQueryRef = AutoDisposeStreamProviderRef<CommentInfo?>;

/// See also [commentsQuery].
@ProviderFor(commentsQuery)
const commentsQueryProvider = CommentsQueryFamily();

/// See also [commentsQuery].
class CommentsQueryFamily extends Family<AsyncValue<CommentInfo?>> {
  /// See also [commentsQuery].
  const CommentsQueryFamily();

  /// See also [commentsQuery].
  CommentsQueryProvider call(
    int postId,
  ) {
    return CommentsQueryProvider(
      postId,
    );
  }

  @override
  CommentsQueryProvider getProviderOverride(
    covariant CommentsQueryProvider provider,
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
  String? get name => r'commentsQueryProvider';
}

/// See also [commentsQuery].
class CommentsQueryProvider extends AutoDisposeStreamProvider<CommentInfo?> {
  /// See also [commentsQuery].
  CommentsQueryProvider(
    this.postId,
  ) : super.internal(
          (ref) => commentsQuery(
            ref,
            postId,
          ),
          from: commentsQueryProvider,
          name: r'commentsQueryProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$commentsQueryHash,
          dependencies: CommentsQueryFamily._dependencies,
          allTransitiveDependencies:
              CommentsQueryFamily._allTransitiveDependencies,
        );

  final int postId;

  @override
  bool operator ==(Object other) {
    return other is CommentsQueryProvider && other.postId == postId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, postId.hashCode);

    return _SystemHash.finish(hash);
  }
}
// ignore_for_file: unnecessary_raw_strings, subtype_of_sealed_class, invalid_use_of_internal_member, do_not_use_environment, prefer_const_constructors, public_member_api_docs, avoid_private_typedef_functions
