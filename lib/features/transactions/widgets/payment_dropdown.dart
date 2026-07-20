import 'package:flutter/material.dart';
import '../../../l10n/generated/app_localizations.dart';
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

            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.paymentModes,
              border: const OutlineInputBorder(),
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
          tooltip: AppLocalizations.of(context)!.addPaymentMode,
          onPressed: onAddPaymentMode,
          icon: const Icon(Icons.add_circle_outline),
        ),
      ],
    );
  }
}
