import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:library_management/app_colors.dart';
import 'package:library_management/controllers/seat_availability_controller.dart';
import 'package:library_management/controllers/slot_availability_controller.dart';
import 'package:library_management/drawer/drawerWidgets/app_bar_widget.dart';
import 'package:library_management/provider/current_library_provider.dart';
import 'package:library_management/provider/slot_availability_provider.dart';
import 'package:library_management/provider/seat_availability_provider.dart';
import 'package:library_management/models/slot_availability_model.dart';
import 'package:library_management/models/seat_availability_model.dart';
import 'package:library_management/screens/studentScreens/add_student_screens/add_student_screen.dart';
import 'package:library_management/screens/studentScreens/add_student_screens/slot_card_avalibility.dart';
import 'package:library_management/screens/seat_box.dart';

class BookSlotAndSeat extends ConsumerStatefulWidget {
  const BookSlotAndSeat({super.key});

  @override
  ConsumerState<BookSlotAndSeat> createState() => _BookSlotAndSeatState();
}

class _BookSlotAndSeatState extends ConsumerState<BookSlotAndSeat> {
  final _slotController = SlotAvailabilityController();
  final _seatController = SeatAvailabilityController();

  final ScrollController _scrollController = ScrollController();
  final GlobalKey _seatSectionKey = GlobalKey();
  final GlobalKey _continueButtonKey = GlobalKey();

  bool _isLoading = true;
  bool _isSeatLoading = false;

  @override
  void initState() {
    super.initState();

    // Reset any selection/data left over from a previous visit to this
    // screen. Wrapped in Future.microtask because Riverpod does not allow
    // modifying a provider synchronously during initState - that still
    // counts as "while the widget tree is building". Running it as a
    // microtask defers it to right after the current build finishes.
    Future.microtask(() {
      ref.read(selectedSlotIdProvider.notifier).state = null;
      ref.read(selectedSeatIdProvider.notifier).state = null;
      ref.read(slotAvailabilityProvider.notifier).clearSlots();
      ref.read(seatAvailabilityProvider.notifier).clearSeats();

      _loadSlots();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadSlots() async {
    setState(() => _isLoading = true);
    final currentLibrary = ref.read(currentLibraryProvider);

    await _slotController.fetchSlotAvailability(
      context: context,
      ref: ref,
      libraryId: currentLibrary!,
    );

    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _onSlotTap(SlotAvailabilityModel slot) async {
    // Selecting a (possibly different) slot resets any seat already chosen -
    // a seat picked for the old slot has no meaning for the new one.
    ref.read(selectedSlotIdProvider.notifier).state = slot.slotTemplateId;
    ref.read(selectedSeatIdProvider.notifier).state = null;
    ref.read(seatAvailabilityProvider.notifier).clearSeats();

    setState(() => _isSeatLoading = true);

    final currentLibrary = ref.read(currentLibraryProvider);

    await _seatController.fetchSeatMap(
      context: context,
      ref: ref,
      libraryId: currentLibrary!,
      slotTemplateId: slot.slotTemplateId,
    );

    if (mounted) {
      setState(() => _isSeatLoading = false);
    }

    _scrollToKey(_seatSectionKey, alignment: 0.0);
  }

  void _onSeatTap(SeatAvailabilityModel seat) {
    if (!seat.isAvailable) return; // booked seats aren't tappable

    final current = ref.read(selectedSeatIdProvider);
    final isDeselecting = current == seat.seatId;

    ref.read(selectedSeatIdProvider.notifier).state = isDeselecting
        ? null
        : seat.seatId;

    if (!isDeselecting) {
      _scrollToKey(_continueButtonKey, alignment: 0.7);
    }
  }

  void _scrollToKey(GlobalKey key, {required double alignment}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ctx = key.currentContext;
      if (ctx == null) return;

      Scrollable.ensureVisible(
        ctx,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOut,
        alignment: alignment,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final slots = ref.watch(slotAvailabilityProvider);
    final selectedSlotId = ref.watch(selectedSlotIdProvider);
    final seats = ref.watch(seatAvailabilityProvider);
    final selectedSeatId = ref.watch(selectedSeatIdProvider);

    return Scaffold(
      appBar: AppBarWidget(title: 'Add Student'),
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Available Slots',
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
            ),
            const SizedBox(height: 25),
            _buildSlotSection(slots, selectedSlotId),
            if (selectedSlotId != null)
              _buildSeatSection(seats, selectedSeatId),
          ],
        ),
      ),
    );
  }

  Widget _buildSlotSection(List slots, String? selectedSlotId) {
    if (_isLoading) {
      return const SizedBox(
        height: 200,
        child: Center(
          child: SpinKitThreeBounce(color: AppColors.primary, size: 20),
        ),
      );
    }

    if (slots.isEmpty) {
      return const SizedBox(height: 200, child: _EmptySlotsView());
    }

    return Column(
      children: slots
          .map<Widget>(
            (slot) => SlotCardAvalibility(
              scale: 1,
              time: slot.formattedTime,
              name: slot.name,
              price: slot.formattedPrice,
              availableSeats: slot.availableSeats,
              isSelected: slot.slotTemplateId == selectedSlotId,
              onTap: () => _onSlotTap(slot),
            ),
          )
          .toList(),
    );
  }

  Widget _buildSeatSection(List seats, String? selectedSeatId) {
    return Container(
      key: _seatSectionKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 30),
          const Text(
            'Available Seats',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          ),
          const SizedBox(height: 14),
          const SeatLegend(),
          const SizedBox(height: 18),
          if (_isSeatLoading)
            const SizedBox(
              height: 150,
              child: Center(
                child: SpinKitThreeBounce(color: AppColors.primary, size: 20),
              ),
            )
          else if (seats.isEmpty)
            const SizedBox(
              height: 100,
              child: Center(child: Text('No seats found for this library')),
            )
          else
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: seats.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 1,
              ),
              itemBuilder: (context, index) {
                final seat = seats[index];
                return SeatBox(
                  seat: seat,
                  isSelected: seat.seatId == selectedSeatId,
                  onTap: () => _onSeatTap(seat),
                );
              },
            ),
          if (selectedSeatId != null) ...[
            const SizedBox(height: 30),
            _buildContinueButton(),
            const SizedBox(height: 40),
          ],
        ],
      ),
    );
  }

  Widget _buildContinueButton() {
    return SizedBox(
      key: _continueButtonKey,
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.buttonPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        onPressed: () {
          // Next step: navigate to the student details form -
          // to be wired up next.
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return AddStudentScreen();
              },
            ),
          );
        },
        child: const Text(
          'Continue to Student Details',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}

class _EmptySlotsView extends StatelessWidget {
  const _EmptySlotsView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.event_busy, size: 48, color: Colors.grey.shade400),
          const SizedBox(height: 12),
          Text(
            'No slots have been created yet',
            style: TextStyle(color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }
}
