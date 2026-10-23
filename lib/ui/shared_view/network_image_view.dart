import 'package:flutter/material.dart';

import '../../config/constants.dart';
import '../custom_icons.dart';
import '../dimension.dart';

/// Image with loading + error states. Relative paths are resolved
/// against [baseImage].
class NetworkImageView extends StatelessWidget {
  const NetworkImageView(
    this.url, {
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius = AppRadius.medium,
  });

  final String? url;
  final double? width;
  final double? height;
  final BoxFit fit;
  final double borderRadius;

  String? get _resolvedUrl {
    if (url == null || url!.isEmpty) return null;
    if (url!.startsWith('http')) return url;
    return '$baseImage/$url';
  }

  @override
  Widget build(BuildContext context) {
    final resolved = _resolvedUrl;
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Container(
        width: width,
        height: height,
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        child: resolved == null
            ? const Icon(CustomIcons.imagePlaceholder)
            : Image.network(
                resolved,
                width: width,
                height: height,
                fit: fit,
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;
                  return const Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  );
                },
                errorBuilder: (jo, ko, wi) => const Icon(CustomIcons.imagePlaceholder),
              ),
      ),
    );
  }
}
