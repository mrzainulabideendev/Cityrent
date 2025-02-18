import 'dart:convert';
import 'package:car_rent/utilz/contants/export.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

class Upcomingscreen extends StatefulWidget {
  final bool isOwner;

  const Upcomingscreen({super.key, this.isOwner = true});

  @override
  State<Upcomingscreen> createState() => _UpcomingscreenState();
}

class _UpcomingscreenState extends State<Upcomingscreen> {
  Map<String, dynamic>? paymentIntentData;
  bool isAgree = false;
  bool isClicked = false;
  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    final userCarRead = context.read<UserViewerController>();
    final notificatioRead = context.watch<GolbProviderNotification>();

    return Container(
      height: h,
      padding: EdgeInsets.only(top: h * 0.02),
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("booking")
            .where(widget.isOwner ? "owner" : "userId",
                isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .where("rideComplete", isEqualTo: false)
            .where("cancel", isEqualTo: false)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.primaryColors,
              ),
            );
          } else if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
            var bookcar = snapshot.data!.docs;
            bookcar.sort((a, b) => b["dateTime"].compareTo(a["dateTime"]));

            return ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: w * 0.05),
              itemCount: bookcar.length,
              itemBuilder: (context, index) {
                var car = bookcar[index];
                String ownerId = car['owner'];
                String formattedStartDate = (car['startDate']);
                String userId = car['userId'];

                return StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection(widget.isOwner ? "Booker" : "Owner")
                      .doc(widget.isOwner ? userId : ownerId)
                      .snapshots(),
                  builder: (context, userSnapshot) {
                    if (userSnapshot.hasData && userSnapshot.data != null) {
                      var userData = userSnapshot.data!;
                      String shopOrUserName = widget.isOwner
                          ? userData['firstName'] ?? 'Unknown User'
                          : userData['shopName'] ?? 'Unknown Shop';
                      String phoneNumber = userData['phoneNumber'] ?? 'N/A';

                      return Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: w * 0.03, vertical: h * 0.02),
                        margin: const EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                          color: AppColors.textformcolour,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  width: w * 0.3,
                                  height: h * 0.19,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: Image.network(car['carImage']),
                                  ),
                                ),
                                SizedBox(width: w * 0.05),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          if (widget.isOwner) ...[
                                            if (car['cashistory'] != null)
                                              Spacer(),
                                            apptext(
                                              myText: car['cashistory'],
                                              size: 13,
                                              textColor: const Color.fromARGB(
                                                  255, 244, 1, 1),
                                            ),
                                          ] else ...[
                                            apptext(
                                              myText: car['requestOwnr']
                                                  ? 'Approved'
                                                  : 'Pending',
                                              size: 13,
                                              isBold: true,
                                              textColor: car['requestOwnr']
                                                  ? Colors.green
                                                  : Colors.red,
                                            ),
                                          ],
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          apptext(
                                            myText: car['carName'],
                                            size: 17,
                                            isBold: true,
                                            textColor: AppColors.buttonColors,
                                          ),
                                        ],
                                      ),
                                      apptext(
                                        myText:
                                            "Start Date: $formattedStartDate",
                                        size: 12,
                                        textColor: AppColors.buttonColors,
                                      ),
                                      apptext(
                                        myText: "Phone: $phoneNumber",
                                        size: 16,
                                        textColor: AppColors.buttonColors,
                                      ),
                                      apptext(
                                        myText:
                                            "Days Booked: ${(car['carbookdays'])}",
                                        size: 16,
                                        textColor: AppColors.buttonColors,
                                      ),
                                      apptext(
                                        myText:
                                            "Total Pay: PKR ${car['payPrice']}",
                                        size: 16,
                                        textColor: AppColors.buttonColors,
                                      ),
                                      apptext(
                                        myText: widget.isOwner
                                            ? "Booker: $shopOrUserName"
                                            : "Shop: $shopOrUserName",
                                        size: 14,
                                        textColor: AppColors.buttonColors,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: h * 0.02),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ///////////////////////////////////////////owner////////////////////////
                                if (widget.isOwner && !car['requestOwnr'])
                                  Row(
                                    children: [
                                      SizedBox(
                                        height: h * 0.055,
                                        width: w * 0.35,
                                        child: appbutton(
                                          buttonText: "Approve",
                                          onTap: () {
                                            showAdaptiveDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return PopUpforall(
                                                  popupname: "Approve Car",
                                                  popudescription:
                                                      "Are you sure car will \n available on this date",
                                                  popuicon: Icons.date_range,
                                                  ontaps: () async {
                                                    bool res = await userCarRead
                                                        .requestOwnr(
                                                            bookingId: car
                                                                .reference.id);
                                                    if (res) {
                                                      await notificatioRead.sendFCMNotification(
                                                          body:
                                                              "Successfully accepted Your Car Booking",
                                                          title:
                                                              "Car Booking Approval",
                                                          collection: "Booker",
                                                          uid: car['userId']);

                                                      Navigator.pop(context);
                                                    }
                                                  },
                                                );
                                              },
                                            );
                                          },
                                          bottonColor: Colors.green,
                                          splashColor: AppColors.primaryColors,
                                        ),
                                      ),
                                      SizedBox(width: w * 0.02),
                                      SizedBox(
                                        height: h * 0.055,
                                        width: w * 0.35,
                                        child: appbutton(
                                          buttonText: "Cancel",
                                          onTap: () {
                                            showAdaptiveDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return PopUpforall(
                                                  popupname: "Cancel",
                                                  popudescription:
                                                      "Are you sure you want \n  to cancel booking?",
                                                  popuicon: Icons.cancel_sharp,
                                                  ontaps: () async {
                                                    bool res = await userCarRead
                                                        .cancelUpdate(
                                                            bookingId: car
                                                                .reference.id);
                                                    if (res) {
                                                      await notificatioRead
                                                          .sendFCMNotification(
                                                              body:
                                                                  "Car Booking Cancel To Owner",
                                                              title:
                                                                  "Booking Cancel",
                                                              collection:
                                                                  "Booker",
                                                              uid: car[
                                                                  'userId']);
                                                      Navigator.pop(context);
                                                    }
                                                  },
                                                );
                                              },
                                            );
                                          },
                                          bottonColor: AppColors.buttonColor2,
                                          splashColor: AppColors.primaryColors,
                                        ),
                                      ),
                                    ],
                                  )
                                ///////////////////////////////////////////user////////////////////////

                                else if (!widget.isOwner && !car['requestOwnr'])
                                  SizedBox(
                                    height: h * 0.055,
                                    width: w * 0.75,
                                    child: appbutton(
                                      buttonText: "Cancel",
                                      onTap: () {
                                        showAdaptiveDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return PopUpforall(
                                              popupname: "Cancel",
                                              popudescription:
                                                  "Are you sure you want \n  to cancel booking?",
                                              popuicon: Icons.cancel_sharp,
                                              ontaps: () async {
                                                bool res = await userCarRead
                                                    .cancelUpdate(
                                                        bookingId:
                                                            car.reference.id);
                                                if (res) {
                                                  await notificatioRead
                                                      .sendFCMNotification(
                                                          body:
                                                              "Car Booking Cancel To Booker",
                                                          title:
                                                              "Booking Cancel",
                                                          collection: "Owner",
                                                          uid: car['owner']);
                                                  Navigator.pop(context);
                                                }
                                              },
                                            );
                                          },
                                        );
                                      },
                                      bottonColor: AppColors.buttonColor2,
                                      splashColor: AppColors.primaryColors,
                                    ),
                                  )
                                ///////////////////////////////////////////owner////////////////////////

                                else if (widget.isOwner && car['requestOwnr'])
                                  Row(
                                    children: [
                                      SizedBox(
                                        height: h * 0.055,
                                        width: w * 0.6,
                                        child: appbutton(
                                          buttonText: "Cancel",
                                          onTap: () {
                                            showAdaptiveDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return PopUpforall(
                                                  popupname: "Cancel",
                                                  popudescription:
                                                      "Are you sure you want \n  to cancel booking?",
                                                  popuicon: Icons.cancel_sharp,
                                                  ontaps: () async {
                                                    bool res = await userCarRead
                                                        .cancelUpdate(
                                                            bookingId: car
                                                                .reference.id);
                                                    if (res) {
                                                      await notificatioRead
                                                          .sendFCMNotification(
                                                              body:
                                                                  "Car Booking Cancel To Owner",
                                                              title:
                                                                  "Booking Cancel",
                                                              collection:
                                                                  "Booker",
                                                              uid: car[
                                                                  'userId']);
                                                      Navigator.pop(context);
                                                    }
                                                  },
                                                );
                                              },
                                            );
                                          },
                                          bottonColor: AppColors.buttonColor2,
                                          splashColor: AppColors.primaryColors,
                                        ),
                                      ),
                                    ],
                                  )
                                else
                                  /////////////////////////////////////////////////////////////// user detail
                                  Row(
                                    children: [
                                      SizedBox(
                                        height: h * 0.055,
                                        width: w * 0.24,
                                        child: appbutton(
                                          buttonText: "Complete",
                                          onTap: () {
                                            showAdaptiveDialog(
                                                context: context,
                                                builder: (context) => Reviewbox(
                                                      car: car,
                                                    ));
                                          },
                                          bottonColor: const Color.fromARGB(
                                              255, 50, 170, 48),
                                          splashColor: AppColors.primaryColors,
                                        ),
                                      ),
                                      SizedBox(width: w * 0.02),
                                      ///////////////////////////////////////////////////////////////Payment

                                      SizedBox(
                                        height: h * 0.055,
                                        width: w * 0.24,
                                        child: appbutton(
                                          buttonText: "Payment",
                                          onTap: () async {
                                            print("${car['payPrice']}");
                                            double payPrice = car['payPrice'];
                                            String formattedPrice = payPrice
                                                .toInt()
                                                .toString(); // Remove decimal part and convert to string

                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: const Text(
                                                      "Select Payment Method"),
                                                  actions: [
                                                    Center(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          SizedBox(
                                                            height: h * 0.05,
                                                            width: w * 0.4,
                                                            child: appbutton(
                                                              icon: Icons
                                                                  .credit_card_rounded,
                                                              iconcolour:
                                                                  AppColors
                                                                      .textcolour,
                                                              bottonColor:
                                                                  const Color
                                                                      .fromARGB(
                                                                      255,
                                                                      50,
                                                                      170,
                                                                      48),
                                                              buttonText:
                                                                  "Pay with Card",
                                                              onTap: () async {
                                                                bool staus =
                                                                    await makePayment(
                                                                        amount:
                                                                            formattedPrice); // Call payment function for card

                                                                if (staus) {
                                                                  bool res =
                                                                      false;
                                                                  while (res !=
                                                                      true) {
                                                                    res = await userCarRead.cashhistoryUpdate(
                                                                        bookingId: car
                                                                            .reference
                                                                            .id,
                                                                        cashistory:
                                                                            "Paid with Card");
                                                                  }
                                                                  if (res) {
                                                                    await notificatioRead.sendFCMNotification(
                                                                        body:
                                                                            "Successfully Payment Done With Card",
                                                                        title:
                                                                            "Booking Payment",
                                                                        collection:
                                                                            "Owner",
                                                                        uid: car[
                                                                            'owner']);

                                                                    snaki(
                                                                        // ignore: use_build_context_synchronously
                                                                        context:
                                                                            context,
                                                                        msg:
                                                                            "Success");
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                  }
                                                                }
                                                              },
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: h * 0.01,
                                                          ),
                                                          SizedBox(
                                                            height: h * 0.05,
                                                            width: w * 0.4,
                                                            child: appbutton(
                                                              icon: Icons
                                                                  .local_atm_outlined,
                                                              iconcolour:
                                                                  AppColors
                                                                      .textcolour,
                                                              buttonText:
                                                                  "Pay with Hand",
                                                              bottonColor:
                                                                  const Color
                                                                      .fromARGB(
                                                                      255,
                                                                      226,
                                                                      13,
                                                                      13),
                                                              onTap: () async {
                                                                bool res = await userCarRead.cashhistoryUpdate(
                                                                    bookingId: car
                                                                        .reference
                                                                        .id,
                                                                    cashistory:
                                                                        "Paid with Hand");

                                                                if (res) {
                                                                  await notificatioRead.sendFCMNotification(
                                                                      body:
                                                                          "Successfully Payment Done With Hand",
                                                                      title:
                                                                          "Booking Payment",
                                                                      collection:
                                                                          "Owner",
                                                                      uid: car[
                                                                          'owner']);
                                                                  snaki(
                                                                      // ignore: use_build_context_synchronously
                                                                      context:
                                                                          context,
                                                                      msg:
                                                                          "Paid with Hand");
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                }
                                                              },
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                          splashColor: AppColors.primaryColors,
                                        ),
                                      ),
                                      SizedBox(width: w * 0.02),
                                      SizedBox(
                                        height: h * 0.055,
                                        width: w * 0.24,
                                        child: appbutton(
                                          buttonText: "Cancel",
                                          onTap: () {
                                            showAdaptiveDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return PopUpforall(
                                                  popupname: "Cancel",
                                                  popudescription:
                                                      "Are you sure you want \n  to cancel booking?",
                                                  popuicon: Icons.cancel_sharp,
                                                  ontaps: () async {
                                                    bool res = await userCarRead
                                                        .cancelUpdate(
                                                            bookingId: car
                                                                .reference.id);
                                                    if (res) {
                                                      await notificatioRead
                                                          .sendFCMNotification(
                                                              body:
                                                                  "Car Booking Cancel To booker",
                                                              title:
                                                                  "Booking Cancel",
                                                              collection:
                                                                  "Owner",
                                                              uid:
                                                                  car['owner']);
                                                      // Navigator.pop(context);
                                                      // Navigator.pop(context);
                                                    }
                                                  },
                                                );
                                              },
                                            );
                                          },
                                          bottonColor: AppColors.buttonColor2,
                                          splashColor: AppColors.primaryColors,
                                        ),
                                      ),
                                    ],
                                  ),
                                /////////////////////////////////////////////////////////////// user detail
                              ],
                            ),
                          ],
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                );
              },
            );
          } else {
            return const Center(
              child: Text("No Upcoming Bookings"),
            );
          }
        },
      ),
    );
  }

  Future<bool> makePayment({required String amount}) async {
    try {
      paymentIntentData = await createPaymentIntent(
          amount, 'PKR'); //json.decode(response.body);
      // //  print('Response body==>${response.body.toString()}');
      await Stripe.instance
          .initPaymentSheet(
              paymentSheetParameters: SetupPaymentSheetParameters(
                  paymentIntentClientSecret:
                      paymentIntentData!['client_secret'],

                  // applePay: const PaymentSheetApplePay(merchantCountryCode: '+92',),
                  // googlePay: const PaymentSheetGooglePay(testEnv: true, currencyCode: "US", merchantCountryCode: "+92"),

                  style: ThemeMode.dark,
                  merchantDisplayName: 'Test'))
          .then((value) {});

      ///now finally display payment sheeet

      bool statusss = await displayPaymentSheet(paymentAmount: amount);
      if (statusss) {
        return true;
      } else {
        return false;
      }
    } catch (e, s) {
      print('exception:$e$s');
      return false;
    }
  }

  Future<bool> displayPaymentSheet({required String paymentAmount}) async {
    setState(() {
      isClicked = false;
    });
    try {
      await Stripe.instance.presentPaymentSheet().then((newValue) async {
        setState(() {
          isClicked = false;
        });

        paymentIntentData = null;
      });
      // .onError((error, stackTrace) {
      //   return false;

      //   //  print('Exception/DISPLAYPAYMENTSHEET==> $error $stackTrace');
      // });
      return true;
    } on StripeException catch (e) {
      print('Exception/DISPLAYPAYMENTSHEET==> $e');
      setState(() {
        isClicked = false;
      });

      snaki(context: context, msg: "Cancelled ", isErrorColor: true);

      return false;
    } catch (e) {
      print('$e');
      return false;
    }
  }

  //  Future<Map<String, dynamic>>
  createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
        'payment_method_types[]': 'card'
      };
      //  print(body);
      var response = await http.post(
          Uri.parse('https://api.stripe.com/v1/payment_intents'),
          body: body,
          headers: {
            'Authorization':
                'Bearer sk_test_51QBy1KFEvQcbtRvjUxJr5aQ9WcXxi1NfYKJr7Ztb585LojEXfGUA556RQgAO7jQ0vIkWo0QNSZIwU2YBsaCc1Di1005IyLYjKy',
            'Content-Type': 'application/x-www-form-urlencoded'
          });
      //  print('Create Intent reponse ===> ${response.body.toString()}');
      return jsonDecode(response.body);
    } catch (err) {
      //  print('err charging user: ${err.toString()}');
    }
  }

  calculateAmount(String amount) {
    final a = (int.parse(amount)) * 100;
    return a.toString();
  }
}
