// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$likesCountHash() => r'53f4512cb8a35908f55e51df15a0112b84b9a16d';

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

typedef LikesCountRef = AutoDisposeStreamProviderRef<LikeInfo>;

/// See also [likesCount].
@ProviderFor(likesCount)
const likesCountProvider = LikesCountFamily();

/// See also [likesCount].
class LikesCountFamily extends Family<AsyncValue<LikeInfo>> {
  /// See also [likesCount].
  const LikesCountFamily();

  /// See also [likesCount].
  LikesCountProvider call(
    int postId,
  ) {
    return LikesCountProvider(
      postId,
    );
  }

  @override
  LikesCountProvider getProviderOverride(
    covariant LikesCountProvider provider,
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
  String? get name => r'likesCountProvider';
}

/// See also [likesCount].
class LikesCountProvider extends AutoDisposeStreamProvider<LikeInfo> {
  /// See also [likesCount].
  LikesCountProvider(
    this.postId,
  ) : super.internal(
          (ref) => likesCount(
            ref,
            postId,
          ),
          from: likesCountProvider,
          name: r'likesCountProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$likesCountHash,
          dependencies: LikesCountFamily._dependencies,
          allTransitiveDependencies:
              LikesCountFamily._allTransitiveDependencies,
        );

  final int postId;

  @override
  bool operator ==(Object other) {
    return other is LikesCountProvider && other.postId == postId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, postId.hashCode);

    return _SystemHash.finish(hash);
  }
}
// ignore_for_file: unnecessary_raw_strings, subtype_of_sealed_class, invalid_use_of_internal_member, do_not_use_environment, prefer_const_constructors, public_member_api_docs, avoid_private_typedef_functions
