import 'package:flutter_riverpod/legacy.dart';
import 'package:library_management/models/payemnt_model.dart';

final paymentProvider =
    StateNotifierProvider<PaymentNotifier, List<PaymentModel>>(
      (ref) => PaymentNotifier(),
    );

class PaymentNotifier extends StateNotifier<List<PaymentModel>> {
  PaymentNotifier() : super([]);

  void setPayments(List<PaymentModel> payments) {
    state = payments;
  }

  void addMorePayments(List<PaymentModel> payments) {
    state = [...state, ...payments];
  }

  void addPayment(PaymentModel payment) {
    state = [payment, ...state];
  }

  void clearPayments() {
    state = [];
  }
}
