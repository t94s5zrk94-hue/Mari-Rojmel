// ===============================================================
// Mari-Rojmel
// Payment Mode Detector
//
// Maps detected payment type to PaymentModeModel.
//
// Production Ready
// Flutter 3.x
// Material 3
// ===============================================================

import '../../parser/services/payment_detector.dart';
import '../models/payment_mode_model.dart';
import '../repositories/payment_mode_repository.dart';

class PaymentModeDetector {
  PaymentModeDetector(this._repository);

  final PaymentModeRepository _repository;

  // ==========================================================
  // Detect Payment Mode
  // ==========================================================

  Future<PaymentModeModel?> detect(List<String> tokens) async {
    final detectedType = PaymentDetector.detect(tokens);

    if (detectedType == DetectedPaymentType.unknown) {
      return null;
    }

    final paymentModes = await _repository.getActive();

    for (final paymentMode in paymentModes) {
      final name = paymentMode.name.trim().toLowerCase();

      switch (detectedType) {
        case DetectedPaymentType.cash:
          if (name == 'cash') {
            return paymentMode;
          }
          break;

        case DetectedPaymentType.upi:
          if (name == 'upi') {
            return paymentMode;
          }
          break;

        case DetectedPaymentType.bank:
          if (name == 'bank' || name == 'bank transfer' || name == 'transfer') {
            return paymentMode;
          }
          break;

        case DetectedPaymentType.debitCard:
          if (name == 'debit card' || name == 'debit' || name == 'atm card') {
            return paymentMode;
          }
          break;

        case DetectedPaymentType.creditCard:
          if (name == 'credit card' || name == 'credit') {
            return paymentMode;
          }
          break;

        case DetectedPaymentType.cheque:
          if (name == 'cheque' || name == 'check') {
            return paymentMode;
          }
          break;

        case DetectedPaymentType.unknown:
          break;
      }
    }

    return null;
  }
}
