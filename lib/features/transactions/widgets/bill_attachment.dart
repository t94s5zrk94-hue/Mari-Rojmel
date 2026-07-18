import 'dart:io';

import 'package:flutter/material.dart';

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
        OutlinedButton.icon(
          onPressed: onGalleryTap,
          icon: const Icon(Icons.attach_file),
          label: const Text('Add Bill'),
        ),

        const SizedBox(height: 12),

        if (billImage != null)
          Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
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
                label: const Text('Remove Bill'),
              ),
            ],
          ),
      ],
    );
  }
}
