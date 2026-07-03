class ProgramData {
  final int id;
  final String name;
  final int durationInDays;
  final double discountPercentage;

  const ProgramData({
    required this.id,
    required this.name,
    required this.durationInDays,
    required this.discountPercentage,
  });
}

const List<ProgramData> programData = [
  ProgramData(
    id: 1,
    name: "1 Month",
    durationInDays: 30,
    discountPercentage: 0,
  ),
  ProgramData(
    id: 2,
    name: "2 Months",
    durationInDays: 60,
    discountPercentage: 10,
  ),
  ProgramData(
    id: 3,
    name: "3 Months",
    durationInDays: 90,
    discountPercentage: 20,
  ),
  ProgramData(
    id: 4,
    name: "4 Months",
    durationInDays: 120,
    discountPercentage: 30,
  ),
];
