import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:library_management/app_colors.dart';
import 'package:library_management/models/seat_availability_model.dart';
import 'package:library_management/models/slot_availability_model.dart';
import 'package:library_management/models/student_model.dart';
import 'package:library_management/provider/seat_availability_provider.dart';
import 'package:library_management/provider/seat_config_provider.dart';
import 'package:library_management/provider/slot_availability_provider.dart';
import 'package:library_management/screens/seat_box.dart';
import 'package:library_management/screens/studentScreens/add_student_screens/slot_card_avalibility.dart';
import 'package:library_management/screens/studentScreens/renewAdmission/renew_student_info_card.dart';

class RenewStep1SlotAndSeat extends StatelessWidget {
  const RenewStep1SlotAndSeat({
    super.key,
    required this.member,
    required this.scale,
    required this.scrollController,
    required this.seatSectionKey,
    required this.isLoadingSlots,
    required this.isLoadingSeat,
    required this.slotFullWarning,
    required this.seatTakenWarning,
    required this.selectedSlotModel,
    required this.onSlotTap,
    required this.onSeatTap,
    required this.onContinue,
    required this.ref,
    this.previousSlotDisplay,
    this.previousSeatDisplay,
  });

  final StudentModel member;
  final double scale;
  final ScrollController scrollController;
  final GlobalKey seatSectionKey;
  final bool isLoadingSlots;
  final bool isLoadingSeat;
  final bool slotFullWarning;
  final bool seatTakenWarning;
  final SlotAvailabilityModel? selectedSlotModel;
  final void Function(SlotAvailabilityModel slot) onSlotTap;
  final void Function(SeatAvailabilityModel seat) onSeatTap;
  final VoidCallback onContinue;
  final WidgetRef ref;
  final String? previousSlotDisplay;
  final String? previousSeatDisplay;

  @override
  Widget build(BuildContext context) {
    final slots = ref.watch(slotAvailabilityProvider);
    final selectedSlotId = ref.watch(selectedSlotIdProvider);
    final seats = ref.watch(seatAvailabilityProvider);
    final selectedSeatId = ref.watch(selectedSeatIdProvider);

    final matchingSlot = slots
        .where((s) => s.slotTemplateId == member.slotTemplateId)
        .firstOrNull;
    final slotDisplay = previousSlotDisplay ??
        (matchingSlot != null
            ? '${matchingSlot.name} (${matchingSlot.formattedTime})'
            : null);

    final matchingSeat =
        seats.where((s) => s.seatId == member.seatId).firstOrNull;
    final seatDisplay = previousSeatDisplay ??
        (member.seatId == null
            ? 'No seat (Overbooked)'
            : (matchingSeat != null ? 'Seat ${matchingSeat.displayLabel}' : null));

    final bool hasAvailableSeats = seats.any((s) => s.isAvailable);
    final bool canContinue = selectedSlotModel != null &&
        (!hasAvailableSeats || selectedSeatId != null);

    return SingleChildScrollView(
      controller: scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.fromLTRB(
        14 * scale,
        16 * scale,
        14 * scale,
        40 * scale,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Student Info Header
          RenewStudentInfoCard(
            member: member,
            scale: scale,
            slotDisplay: slotDisplay,
            seatDisplay: seatDisplay,
          ),

          SizedBox(height: 24 * scale),

          // Slot Selection Header
          _SectionHeader(
            icon: Icons.schedule_rounded,
            title: 'Select Slot',
            scale: scale,
          ),
          SizedBox(height: 12 * scale),

          if (isLoadingSlots)
            const SizedBox(
              height: 140,
              child: Center(
                child: SpinKitThreeBounce(color: AppColors.primary, size: 20),
              ),
            )
          else if (slots.isEmpty)
            const _EmptyView(message: 'No slots available')
          else
            Column(
              children: slots
                  .map<Widget>(
                    (slot) => SlotCardAvalibility(
                      scale: scale,
                      time: slot.formattedTime,
                      name: slot.name,
                      price: slot.formattedPrice,
                      availableSeats: slot.availableSeats,
                      isSelected: slot.slotTemplateId == selectedSlotId,
                      onTap: () => onSlotTap(slot),
                    ),
                  )
                  .toList(),
            ),

          // Slot Full Warning
          if (slotFullWarning) ...[
            SizedBox(height: 8 * scale),
            _WarningBanner(
              icon: Icons.warning_amber_rounded,
              color: AppColors.warning,
              message:
                  'This slot is full. You can still overbook or choose another slot.',
              scale: scale,
            ),
          ],

          // Seat Selection Section
          if (selectedSlotId != null) ...[
            SizedBox(height: 24 * scale),
            Container(
              key: seatSectionKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SectionHeader(
                    icon: Icons.chair_outlined,
                    title: 'Select Seat',
                    scale: scale,
                  ),
                  SizedBox(height: 10 * scale),
                  const SeatLegend(),
                  SizedBox(height: 14 * scale),

                  if (seatTakenWarning) ...[
                    _WarningBanner(
                      icon: Icons.event_seat_rounded,
                      color: AppColors.error,
                      message:
                          'Previous seat is no longer available. Please choose a new seat.',
                      scale: scale,
                    ),
                    SizedBox(height: 10 * scale),
                  ],

                  if (isLoadingSeat)
                    const SizedBox(
                      height: 120,
                      child: Center(
                        child: SpinKitThreeBounce(
                          color: AppColors.primary,
                          size: 20,
                        ),
                      ),
                    )
                  else if (seats.isEmpty)
                    const _EmptyView(message: 'No seats found')
                  else
                    _SeatGrid(
                      seats: seats,
                      selectedSeatId: selectedSeatId,
                      onSeatTap: onSeatTap,
                      ref: ref,
                    ),

                  if (!isLoadingSeat &&
                      seats.isNotEmpty &&
                      selectedSeatId == null) ...[
                    SizedBox(height: 10 * scale),
                    _WarningBanner(
                      icon: Icons.info_outline_rounded,
                      color: AppColors.primary,
                      message:
                          'No seat selected — admission will be overbooking.',
                      scale: scale,
                    ),
                  ],
                ],
              ),
            ),
          ],

          SizedBox(height: 28 * scale),

          // Continue Button to Step 2
          SizedBox(
            width: double.infinity,
            height: 52 * scale,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.buttonPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14 * scale),
                ),
                elevation: 0,
              ),
              onPressed: canContinue ? onContinue : null,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Continue',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 15 * scale,
                    ),
                  ),
                  SizedBox(width: 8 * scale),
                  Icon(
                    Icons.arrow_forward_rounded,
                    color: Colors.white,
                    size: 18 * scale,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.icon,
    required this.title,
    required this.scale,
  });

  final IconData icon;
  final String title;
  final double scale;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18 * scale, color: AppColors.primary),
        SizedBox(width: 8 * scale),
        Text(
          title,
          style: TextStyle(
            fontSize: 15 * scale,
            fontWeight: FontWeight.w600,
            color: AppColors.heading,
          ),
        ),
      ],
    );
  }
}

class _WarningBanner extends StatelessWidget {
  const _WarningBanner({
    required this.icon,
    required this.color,
    required this.message,
    required this.scale,
  });

  final IconData icon;
  final Color color;
  final String message;
  final double scale;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12 * scale),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: .3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 18 * scale),
          SizedBox(width: 10 * scale),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                fontSize: 13 * scale,
                color: color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SeatGrid extends StatelessWidget {
  const _SeatGrid({
    required this.seats,
    required this.selectedSeatId,
    required this.onSeatTap,
    required this.ref,
  });

  final List<SeatAvailabilityModel> seats;
  final String? selectedSeatId;
  final void Function(SeatAvailabilityModel) onSeatTap;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    final seatConfig = ref.watch(seatConfigProvider);
    final columns = (seatConfig?.columns != null && seatConfig!.columns > 0)
        ? seatConfig.columns
        : 5;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: seats.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 1,
      ),
      itemBuilder: (context, index) {
        final seat = seats[index];
        return SeatBox(
          seat: seat,
          isSelected: seat.seatId == selectedSeatId,
          onTap: () => onSeatTap(seat),
        );
      },
    );
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: Center(
        child: Text(message, style: const TextStyle(color: AppColors.grey500)),
      ),
    );
  }
}
