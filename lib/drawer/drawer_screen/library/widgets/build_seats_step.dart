import 'package:flutter/material.dart';
import 'package:library_management/app_colors.dart';
import 'package:library_management/drawer/drawer_screen/library/widgets/section_title.dart';
import 'package:library_management/drawer/drawer_screen/library/widgets/text_field.dart';

Widget buildSeatStep({
  required Key formKeyStep2,
  required TextEditingController totalSeatsController,
  required TextEditingController prefixController,
  double scale = 1,
  required bool autoGenerateSeats,
  required ValueChanged<bool> onAutoGenerateChanged,
}) {
  return SingleChildScrollView(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Form(
      key: formKeyStep2,
      child: Container(
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(26),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .04),
              blurRadius: 18,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                "Seats",
                style: TextStyle(
                  fontSize: 18 * scale,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            SizedBox(height: 4 * scale),

            Center(
              child: Text(
                "Configure seats for your library.",
                style: TextStyle(color: Colors.grey.shade600, fontSize: 10),
              ),
            ),

            SizedBox(height: 30 * scale),

            sectionTitle("Total Seats"),

            SizedBox(height: 8 * scale),

            textField(
              controller: totalSeatsController,
              hintText: '100',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Enter total seats";
                }

                final seats = int.tryParse(value);

                if (seats == null || seats <= 0) {
                  return "Enter valid seat count";
                }

                return null;
              },
              fillColor: AppColors.background,
            ),

            SizedBox(height: 16 * scale),

            sectionTitle("Seat Prefix"),

            SizedBox(height: 8 * scale),

            textField(
              controller: prefixController,
              hintText: "A",
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return "Enter seat prefix";
                }

                return null;
              },
              maxLength: 1,
              fillColor: AppColors.background,
            ),

            SizedBox(height: 26 * scale),

            const Divider(),

            SizedBox(height: 20 * scale),

            Center(
              child: Text(
                "Seat Preview",
                style: TextStyle(
                  fontSize: 12 * scale,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            SizedBox(height: 8 * scale),

            /// Legend
            Center(
              child: Wrap(
                spacing: 18 * scale,
                runSpacing: 10 * scale,
                children: [
                  _legendItem(
                    color: Colors.white,
                    borderColor: Colors.grey.shade400,
                    text: "Available",
                    scale: scale,
                  ),
                  _legendItem(
                    color: Colors.green,
                    borderColor: Colors.green,
                    text: "Occupied",
                    scale: scale,
                  ),
                  _legendItem(
                    color: Colors.orange,
                    borderColor: Colors.orange,
                    text: "Reserved",
                    scale: scale,
                  ),
                ],
              ),
            ),

            SizedBox(height: 18 * scale),

            AnimatedBuilder(
              animation: Listenable.merge([
                totalSeatsController,
                prefixController,
              ]),
              builder: (_, __) {
                final prefix = prefixController.text.trim().isEmpty
                    ? "A"
                    : prefixController.text.trim().toUpperCase();

                final seats = int.tryParse(totalSeatsController.text) ?? 0;
                final previewCount = seats > 9 ? 9 : seats;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 10 * scale,
                      runSpacing: 10 * scale,
                      children: List.generate(previewCount, (index) {
                        return Container(
                          width: 60 * scale,
                          height: 60 * scale,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14 * scale),
                            border: Border.all(
                              color: Colors.grey.shade300,
                              width: 1.3 * scale,
                            ),
                          ),
                          child: Text(
                            "$prefix${index + 1}",
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 13 * scale,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        );
                      }),
                    ),

                    if (seats > 9)
                      Padding(
                        padding: EdgeInsets.only(top: 14 * scale),
                        child: Text(
                          "...and ${seats - 9} more seats",
                          style: TextStyle(
                            fontSize: 12 * scale,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ),

                    SizedBox(height: 24 * scale),

                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(16 * scale),
                      decoration: BoxDecoration(
                        color: Colors.green.withValues(alpha: .08),
                        borderRadius: BorderRadius.circular(14 * scale),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,

                        children: [
                          Icon(
                            Icons.info,
                            size: 15 * scale,
                            color: AppColors.grey500,
                          ),

                          SizedBox(height: 4 * scale),

                          Center(
                            child: Text(
                              "All seats are initially created as Available. Their status changes to Occupied or Reserved after assigning students.",
                              style: TextStyle(
                                fontSize: 10 * scale,
                                color: Colors.grey.shade600,
                                height: 1.5,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _legendItem({
  required Color color,
  required Color borderColor,
  required String text,
  required double scale,
}) {
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        width: 14 * scale,
        height: 14 * scale,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(4 * scale),
          border: Border.all(color: borderColor),
        ),
      ),
      SizedBox(width: 6 * scale),
      Text(
        text,
        style: TextStyle(fontSize: 12 * scale, color: Colors.grey.shade700),
      ),
    ],
  );
}
