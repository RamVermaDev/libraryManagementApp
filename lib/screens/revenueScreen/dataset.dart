// ============================================================
// PAYMENT DATA — MAY & JUNE 2026
// ============================================================

import 'package:library_management/screens/revenueScreen/expense_item.dart';
import 'package:library_management/screens/revenueScreen/payement_item.dart';

final List<PaymentItem> paymentItems = [
  // -------------------- JUNE 2026 --------------------

  PaymentItem(
    id: 'payment_01',
    memberName: 'Rahul Sharma',
    amount: 1200,
    paymentMethod: PaymentMethod.cash,
    paidAt: DateTime(2026, 6, 29, 15, 26),
  ),

  PaymentItem(
    id: 'payment_02',
    memberName: 'Aman Verma',
    amount: 600,
    paymentMethod: PaymentMethod.upi,
    paidAt: DateTime(2026, 6, 28, 17, 55),
  ),

  PaymentItem(
    id: 'payment_03',
    memberName: 'Priya Singh',
    amount: 300,
    paymentMethod: PaymentMethod.cash,
    paidAt: DateTime(2026, 6, 28, 16, 24),
  ),

  PaymentItem(
    id: 'payment_04',
    memberName: 'Rohit Yadav',
    amount: 1500,
    paymentMethod: PaymentMethod.upi,
    paidAt: DateTime(2026, 6, 22, 11, 30),
  ),

  PaymentItem(
    id: 'payment_05',
    memberName: 'Anjali Gupta',
    amount: 900,
    paymentMethod: PaymentMethod.bankTransfer,
    paidAt: DateTime(2026, 6, 18, 13, 15),
  ),

  PaymentItem(
    id: 'payment_06',
    memberName: 'Vikas Mishra',
    amount: 1200,
    paymentMethod: PaymentMethod.cash,
    paidAt: DateTime(2026, 6, 12, 10, 45),
  ),

  PaymentItem(
    id: 'payment_07',
    memberName: 'Neha Patel',
    amount: 800,
    paymentMethod: PaymentMethod.upi,
    paidAt: DateTime(2026, 6, 5, 18, 20),
  ),

  // -------------------- MAY 2026 --------------------

  PaymentItem(
    id: 'payment_08',
    memberName: 'Saurabh Singh',
    amount: 1000,
    paymentMethod: PaymentMethod.cash,
    paidAt: DateTime(2026, 5, 30, 14, 10),
  ),

  PaymentItem(
    id: 'payment_09',
    memberName: 'Pooja Yadav',
    amount: 1200,
    paymentMethod: PaymentMethod.upi,
    paidAt: DateTime(2026, 5, 26, 16, 40),
  ),

  PaymentItem(
    id: 'payment_10',
    memberName: 'Abhishek Kumar',
    amount: 700,
    paymentMethod: PaymentMethod.cash,
    paidAt: DateTime(2026, 5, 21, 9, 30),
  ),

  PaymentItem(
    id: 'payment_11',
    memberName: 'Sneha Singh',
    amount: 1500,
    paymentMethod: PaymentMethod.bankTransfer,
    paidAt: DateTime(2026, 5, 16, 12, 20),
  ),

  PaymentItem(
    id: 'payment_12',
    memberName: 'Deepak Verma',
    amount: 900,
    paymentMethod: PaymentMethod.upi,
    paidAt: DateTime(2026, 5, 10, 17, 15),
  ),

  PaymentItem(
    id: 'payment_13',
    memberName: 'Kajal Gupta',
    amount: 1100,
    paymentMethod: PaymentMethod.cash,
    paidAt: DateTime(2026, 5, 4, 11, 50),
  ),
];


// ============================================================
// EXPENSE DATA — MAY & JUNE 2026
// ============================================================

final List<ExpenseItem> expenseItems = [
  // -------------------- JUNE 2026 --------------------

  ExpenseItem(
    id: 'expense_01',
    title: 'Electricity Bill',
    amount: 2800,
    category: ExpenseCategory.electricity,
    expenseDate: DateTime(2026, 6, 25),
  ),

  ExpenseItem(
    id: 'expense_02',
    title: 'Monthly Wi-Fi Bill',
    amount: 1000,
    category: ExpenseCategory.internet,
    expenseDate: DateTime(2026, 6, 19),
  ),

  ExpenseItem(
    id: 'expense_03',
    title: 'Water Cooler Repair',
    amount: 600,
    category: ExpenseCategory.maintenance,
    expenseDate: DateTime(2026, 6, 14),
  ),

  ExpenseItem(
    id: 'expense_04',
    title: 'Cleaning Supplies',
    amount: 450,
    category: ExpenseCategory.other,
    expenseDate: DateTime(2026, 6, 7),
  ),

  // -------------------- MAY 2026 --------------------

  ExpenseItem(
    id: 'expense_05',
    title: 'Library Rent',
    amount: 8000,
    category: ExpenseCategory.rent,
    expenseDate: DateTime(2026, 5, 28),
  ),

  ExpenseItem(
    id: 'expense_06',
    title: 'Electricity Bill',
    amount: 2400,
    category: ExpenseCategory.electricity,
    expenseDate: DateTime(2026, 5, 22),
  ),

  ExpenseItem(
    id: 'expense_07',
    title: 'Monthly Wi-Fi Bill',
    amount: 1000,
    category: ExpenseCategory.internet,
    expenseDate: DateTime(2026, 5, 18),
  ),

  ExpenseItem(
    id: 'expense_08',
    title: 'Chair Repair',
    amount: 750,
    category: ExpenseCategory.maintenance,
    expenseDate: DateTime(2026, 5, 11),
  ),

  ExpenseItem(
    id: 'expense_09',
    title: 'Cleaning Supplies',
    amount: 500,
    category: ExpenseCategory.other,
    expenseDate: DateTime(2026, 5, 5),
  ),
];