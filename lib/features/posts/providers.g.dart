// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$imageUrlHash() => r'22a9788fdb872ad7c1622bda418710881c21b21b';

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

typedef ImageUrlRef = AutoDisposeProviderRef<String>;

/// See also [imageUrl].
@ProviderFor(imageUrl)
const imageUrlProvider = ImageUrlFamily();

/// See also [imageUrl].
class ImageUrlFamily extends Family<String> {
  /// See also [imageUrl].
  const ImageUrlFamily();

  /// See also [imageUrl].
  ImageUrlProvider call({
    required String userId,
    required String fileName,
  }) {
    return ImageUrlProvider(
      userId: userId,
      fileName: fileName,
    );
  }

  @override
  ImageUrlProvider getProviderOverride(
    covariant ImageUrlProvider provider,
  ) {
    return call(
      userId: provider.userId,
      fileName: provider.fileName,
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
  String? get name => r'imageUrlProvider';
}

/// See also [imageUrl].
class ImageUrlProvider extends AutoDisposeProvider<String> {
  /// See also [imageUrl].
  ImageUrlProvider({
    required this.userId,
    required this.fileName,
  }) : super.internal(
          (ref) => imageUrl(
            ref,
            userId: userId,
            fileName: fileName,
          ),
          from: imageUrlProvider,
          name: r'imageUrlProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$imageUrlHash,
          dependencies: ImageUrlFamily._dependencies,
          allTransitiveDependencies: ImageUrlFamily._allTransitiveDependencies,
        );

  final String userId;
  final String fileName;

  @override
  bool operator ==(Object other) {
    return other is ImageUrlProvider &&
        other.userId == userId &&
        other.fileName == fileName;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, userId.hashCode);
    hash = _SystemHash.combine(hash, fileName.hashCode);

    return _SystemHash.finish(hash);
  }
}
// ignore_for_file: unnecessary_raw_strings, subtype_of_sealed_class, invalid_use_of_internal_member, do_not_use_environment, prefer_const_constructors, public_member_api_docs, avoid_private_typedef_functions
