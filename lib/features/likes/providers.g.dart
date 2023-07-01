// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$likesQueryHash() => r'b509bb7a1c93d7c741f3ffe01d56a4242e562e12';

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

typedef LikesQueryRef = AutoDisposeStreamProviderRef<LikeInfo>;

/// See also [likesQuery].
@ProviderFor(likesQuery)
const likesQueryProvider = LikesQueryFamily();

/// See also [likesQuery].
class LikesQueryFamily extends Family<AsyncValue<LikeInfo>> {
  /// See also [likesQuery].
  const LikesQueryFamily();

  /// See also [likesQuery].
  LikesQueryProvider call(
    int postId,
  ) {
    return LikesQueryProvider(
      postId,
    );
  }

  @override
  LikesQueryProvider getProviderOverride(
    covariant LikesQueryProvider provider,
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
  String? get name => r'likesQueryProvider';
}

/// See also [likesQuery].
class LikesQueryProvider extends AutoDisposeStreamProvider<LikeInfo> {
  /// See also [likesQuery].
  LikesQueryProvider(
    this.postId,
  ) : super.internal(
          (ref) => likesQuery(
            ref,
            postId,
          ),
          from: likesQueryProvider,
          name: r'likesQueryProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$likesQueryHash,
          dependencies: LikesQueryFamily._dependencies,
          allTransitiveDependencies:
              LikesQueryFamily._allTransitiveDependencies,
        );

  final int postId;

  @override
  bool operator ==(Object other) {
    return other is LikesQueryProvider && other.postId == postId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, postId.hashCode);

    return _SystemHash.finish(hash);
  }
}
// ignore_for_file: unnecessary_raw_strings, subtype_of_sealed_class, invalid_use_of_internal_member, do_not_use_environment, prefer_const_constructors, public_member_api_docs, avoid_private_typedef_functions
