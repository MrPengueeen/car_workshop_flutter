import 'package:car_workshop_flutter/src/core/base_state.dart';
import 'package:car_workshop_flutter/src/feature/admin/bookings/controller/bookings_controller.dart';
import 'package:car_workshop_flutter/src/feature/admin/bookings/view/widgets/booking_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class AdminDashboardScreen extends ConsumerWidget {
  const AdminDashboardScreen({super.key});

  static const routePath = "/adminDashboard";

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    final dateRange = ref.watch(dateRangeProvider);
    final bookingController = ref.watch(bookingControllerProvider);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Container(
            height: height,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                InkWell(
                  onTap: () {
                    _onDateTap(context, ref);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    decoration: BoxDecoration(
                        color: Colors.grey[400],
                        borderRadius: BorderRadius.circular(16)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.calendar_month_outlined),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          '${DateFormat.yMMMMd().format(
                            dateRange[0],
                          )} - ${DateFormat.yMMMMd().format(
                            dateRange[1],
                          )}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    InkWell(
                      onTap: () {
                        _onSelectToday(context, ref);
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                        decoration: BoxDecoration(
                            color: Colors.grey[400],
                            borderRadius: BorderRadius.circular(16)),
                        child: Text(
                          'Today',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        _onSelectLastWeek(context, ref);
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                        decoration: BoxDecoration(
                            color: Colors.grey[400],
                            borderRadius: BorderRadius.circular(16)),
                        child: Text(
                          'Last Week',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        _onSelectLastMonth(context, ref);
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                        decoration: BoxDecoration(
                            color: Colors.grey[400],
                            borderRadius: BorderRadius.circular(16)),
                        child: Text(
                          'Last Month',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                if (bookingController is LoadingState)
                  const Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                      ],
                    ),
                  ),
                if (bookingController is SuccessState &&
                    bookingController.data.isEmpty)
                  const Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'No bookings found for the given date range.',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                if (bookingController is SuccessState)
                  Expanded(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        ListView.builder(
                            itemCount: bookingController.data.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return BookingCardWidget(
                                  booking: bookingController.data[index]);
                            }),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _onDateTap(BuildContext ctx, WidgetRef ref) async {
    final dateRange = await showDateRangePicker(
      context: ctx,
      firstDate: DateTime(2010),
      lastDate: DateTime.now(),
    );
    if (dateRange != null) {
      ref.read(dateRangeProvider.notifier).update((state) {
        return [dateRange.start, dateRange.end];
      });
      ref.read(bookingControllerProvider.notifier).getBookingsByDateRange(
          context: ctx, start: dateRange.start, end: dateRange.end);
    }
  }

  _onSelectToday(BuildContext ctx, WidgetRef ref) async {
    ref.read(dateRangeProvider.notifier).update((state) {
      return [DateTime.now(), DateTime.now()];
    });
    ref.read(bookingControllerProvider.notifier).getBookingsByDateRange(
        context: ctx, start: DateTime.now(), end: DateTime.now());
  }

  _onSelectLastWeek(BuildContext ctx, WidgetRef ref) async {
    ref.read(dateRangeProvider.notifier).update((state) {
      return [DateTime.now().subtract(Duration(days: 7)), DateTime.now()];
    });
    ref.read(bookingControllerProvider.notifier).getBookingsByDateRange(
        context: ctx,
        start: DateTime.now().subtract(Duration(days: 7)),
        end: DateTime.now());
  }

  _onSelectLastMonth(BuildContext ctx, WidgetRef ref) async {
    ref.read(dateRangeProvider.notifier).update((state) {
      return [DateTime.now().subtract(Duration(days: 30)), DateTime.now()];
    });
    ref.read(bookingControllerProvider.notifier).getBookingsByDateRange(
        context: ctx,
        start: DateTime.now().subtract(Duration(days: 30)),
        end: DateTime.now());
  }
}