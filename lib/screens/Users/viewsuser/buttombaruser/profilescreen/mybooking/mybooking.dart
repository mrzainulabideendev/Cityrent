import 'package:car_rent/utilz/contants/export.dart';


class MyWidget extends StatefulWidget {
  final bool isOwner;
  const MyWidget({super.key, this.isOwner = true});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: apptext(
              myText: "My Booking",
              size: 20,
              isBold: true,
            ),
            bottom: const TabBar(
              tabs: [
                Tab(text: 'Upcoming'),
                Tab(text: 'Canceled'),
                Tab(text: 'Completed'),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              Upcomingscreen(isOwner: widget.isOwner),
              Canclescreen(isOwner: widget.isOwner),
              Completedscreen(isOwner: widget.isOwner),
            ],
          ),
          floatingActionButton: widget.isOwner
              ? FloatingActionButton(
                  onPressed: _showCalendar,
                  child: const Icon(Icons.calendar_today),
                  tooltip: 'Check Bookings',
                )
              : null,
        ),
      ),
    );
  }

  void _showCalendar() async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (selectedDate != null) {
      print(
          'Selected date: ${selectedDate.toLocal()}'); // Replace this with your logic
    }
  }
}
