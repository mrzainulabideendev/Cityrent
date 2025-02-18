import 'package:car_rent/screens/Users/viewsuser/buttombaruser/profilescreen/mybooking/mybooking.dart';

import '../../../../../../utilz/contants/export.dart';

class Mybooking extends StatefulWidget {
  final dynamic carData;

  const Mybooking({super.key, this.carData});

  @override
  State<Mybooking> createState() => _MybookingState();
}

class _MybookingState extends State<Mybooking> {
  DateTime? selectedDateTime;
  String? selectedDuration;
  TextEditingController daysController = TextEditingController();
  double pricePerDay = 0.0;
  double totalPrice = 0.0;

  @override
  void initState() {
    super.initState();
    String priceString = widget.carData['Carrent'];
    pricePerDay = double.tryParse(priceString) ?? 0.0;
  }

  String get formattedDateTime => selectedDateTime != null
      ? "${selectedDateTime!.day}-${selectedDateTime!.month}-${selectedDateTime!.year} ${selectedDateTime!.hour}:${selectedDateTime!.minute}"
      : "Not selected";

  Future<void> showDateTimePicker(BuildContext context) async {
    DateTime now = DateTime.now();
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primaryColors,
            ),
          ),
          child: child!,
        );
      },
    );

    if (selectedDate != null) {
      TimeOfDay? selectedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (selectedTime != null) {
        setState(() {
          selectedDateTime = DateTime(
            selectedDate.year,
            selectedDate.month,
            selectedDate.day,
            selectedTime.hour,
            selectedTime.minute,
          );
        });
      }
    }
  }

  void calculatePrice() {
    int duration = 0;

    if (selectedDuration == null) {
      showTopSnackBar("Please select a duration.");
      return;
    }

    if (selectedDuration == '12 hours') {
      totalPrice = pricePerDay / 2;
    } else if (selectedDuration == '24 hours') {
      totalPrice = pricePerDay;
    } else if (selectedDuration == 'Custom') {
      duration = int.tryParse(daysController.text) ?? 0;

      totalPrice = pricePerDay * duration;
    }
    setState(() {});
  }

  void showTopSnackBar(String message) {
    // Show the modal bottom sheet
    showModalBottomSheet(
      context: context,
      isDismissible: true,
      backgroundColor: Colors.transparent, // Make the background transparent
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.primaryColors,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Text(
          message,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ),
    );

    Future.delayed(const Duration(seconds: 1), () {
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    final double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final userRead = context.read<UserViewerController>();
    final notificatioRead = context.watch<GolbProviderNotification>();

    return Container(
      height: h * 0.5 + keyboardHeight,
      padding: EdgeInsets.symmetric(horizontal: w * 0.06),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: h * 0.02),
            const Center(
              child: Text(
                "Request Sent to Owner",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColors,
                ),
              ),
            ),
            SizedBox(height: h * 0.02),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${widget.carData['Cardrand']}',
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 2, 2, 2),
                      ),
                    ),
                    Text(
                      '${widget.carData['CarName']}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color.fromARGB(255, 2, 2, 2),
                      ),
                    ),
                    Text(
                      'Car Transmission: ${widget.carData['CarTransmsion']}',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color.fromARGB(255, 2, 2, 2),
                      ),
                    ),
                    Text(
                      'Car Rent: ${widget.carData['Carrent']}',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color.fromARGB(255, 2, 2, 2),
                      ),
                    ),
                  ],
                ),
                Image.network(
                  widget.carData['CarImages'][0],
                  width: w * 0.3,
                  height: h * 0.15,
                  fit: BoxFit.cover,
                ),
              ],
            ),
            SizedBox(height: h * 0.02),
            GestureDetector(
              onTap: () => showDateTimePicker(context),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: AppColors.primaryColors,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      selectedDateTime != null
                          ? formattedDateTime
                          : "Pick Date and Time",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const Icon(
                      Icons.calendar_today,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: h * 0.02),
            DropdownButtonFormField<String>(
              value: selectedDuration,
              hint: const Text(
                "Select Duration",
                style: TextStyle(color: Colors.white),
              ),
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColors.primaryColors,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
              dropdownColor: AppColors.primaryColors,
              items: ['12 hours', '24 hours', 'Custom'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: const TextStyle(color: Colors.white),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedDuration = value;
                  calculatePrice();
                });
              },
            ),
            SizedBox(height: h * 0.01),
            if (selectedDuration == 'Custom')
              TextFormField(
                controller: daysController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: "Enter number of days",
                  hintStyle: const TextStyle(color: Colors.white),
                  filled: true,
                  fillColor: AppColors.primaryColors,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
                style: const TextStyle(color: Colors.white),
                cursorColor: Colors.white,
                onChanged: (value) {
                  calculatePrice();
                },
              ),
            SizedBox(height: h * 0.01),
            Center(
              child: SizedBox(
                height: h * 0.06,
                width: w * 0.5,
                child: ElevatedButton(
                  onPressed: () async {
                    if (selectedDateTime == null) {
                      showTopSnackBar("Please select a date and time.");
                      return;
                    }
                    if (totalPrice <= 0) {
                      showTopSnackBar("Please calculate the price first.");
                      return;
                    }

                    print("Total Price: PKR ${totalPrice.toStringAsFixed(2)}");
                    print("Selected Date and Time: $formattedDateTime");
                    print("Duration: $selectedDuration");

                    bool res = await userRead.bookingCar(
                      carId: widget.carData.reference.id,
                      ownerUid: widget.carData["ownerUid"],
                      carName: widget.carData["CarName"],
                      carModel: widget.carData["Carmodel"],
                      startDate: formattedDateTime,
                      payPrice: totalPrice,
                      carRent: widget.carData["Carrent"],
                      carImage: widget.carData["CarImages"][0],
                      carbookdays: selectedDuration == 'Custom'
                          ? daysController.text
                          : selectedDuration,
                    );

                    if (res) {
                      showDialog(
                        context: context,
                        builder: (context) => newcarpoup(
                            isbooing: true,
                            onTap: () {
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (context, animation,
                                          secondaryAnimation) =>
                                     const MyWidget(
                                    isOwner: false,
                                  ),
                                ),
                              );
                            },
                            buttonText: "My Booking",
                            lottie: Appanimation.cardneanimation,
                            text:
                                "Successfully Send Your request to Owner Please Check Your 'My Booking'"),
                      );

                      notificatioRead.sendFCMNotification(
                        body: "Request for Car Booking $formattedDateTime",
                        title: widget.carData["CarName"],
                        collection: "Owner",
                        uid: widget.carData["ownerUid"],
                      );

                      // Navigator.push(
                      //     context,
                      //     PageRouteBuilder(
                      //       pageBuilder:
                      //           (context, animation, secondaryAnimation) =>
                      //               const Upcomingscreen(),
                      //     ));
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColors,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "Book",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
