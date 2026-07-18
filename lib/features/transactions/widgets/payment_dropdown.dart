import 'package:flutter/material.dart';

import '../../payment_modes/models/payment_mode_model.dart';

class PaymentDropdown extends StatelessWidget {
  const PaymentDropdown({
    super.key,
    required this.paymentModes,
    required this.selectedPaymentMode,
    required this.onChanged,
    required this.onAddPaymentMode,
  });

  final List<PaymentModeModel> paymentModes;

  final PaymentModeModel? selectedPaymentMode;

  final ValueChanged<PaymentModeModel?> onChanged;

  final VoidCallback onAddPaymentMode;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: DropdownButtonFormField<PaymentModeModel>(
            initialValue: selectedPaymentMode,
            decoration: const InputDecoration(
              labelText: 'Payment',
              border: OutlineInputBorder(),
            ),
            items: paymentModes
                .map(
                  (paymentMode) => DropdownMenuItem<PaymentModeModel>(
                    value: paymentMode,
                    child: Text(paymentMode.name),
                  ),
                )
                .toList(),
            onChanged: onChanged,
          ),
        ),

        const SizedBox(width: 8),

        IconButton(
          tooltip: 'Add Payment Mode',
          onPressed: onAddPaymentMode,
          icon: const Icon(Icons.add_circle_outline),
        ),
      ],
    );
  }
}
