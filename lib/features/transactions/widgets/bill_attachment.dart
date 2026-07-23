import 'dart:io';
import '../../../l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import '../../../app/app_radius.dart';

class BillAttachment extends StatelessWidget {
  const BillAttachment({
    super.key,
    this.billImage,
    required this.onCameraTap,
    required this.onGalleryTap,
    required this.onRemoveTap,
  });

  final File? billImage;

  final VoidCallback onCameraTap;
  final VoidCallback onGalleryTap;
  final VoidCallback onRemoveTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: onCameraTap,
                icon: const Icon(Icons.camera_alt_outlined),
                label: Text(AppLocalizations.of(context)!.camera),
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: OutlinedButton.icon(
                onPressed: onGalleryTap,
                icon: const Icon(Icons.photo_library_outlined),
                label: Text(AppLocalizations.of(context)!.gallery),
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        if (billImage != null)
          Column(
            children: [
              ClipRRect(
                borderRadius: AppRadius.medium,
                child: Image.file(
                  billImage!,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),

              const SizedBox(height: 12),

              TextButton.icon(
                onPressed: onRemoveTap,
                icon: const Icon(Icons.delete_outline),
                label: Text(AppLocalizations.of(context)!.removeBill),
              ),
            ],
          ),
      ],
    );
  }
}
