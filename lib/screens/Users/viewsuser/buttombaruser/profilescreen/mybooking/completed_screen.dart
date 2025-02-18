import 'package:car_rent/utilz/contants/export.dart';
import 'package:intl/intl.dart';

class Completedscreen extends StatefulWidget {
  final bool isOwner;
  const Completedscreen({super.key, this.isOwner = true});

  @override
  State<Completedscreen> createState() => _CompletedscreenState();
}

class _CompletedscreenState extends State<Completedscreen> {
  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    return Container(
      height: h,
      padding: EdgeInsets.only(top: h * 0.02),
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("booking")
            .where(widget.isOwner ? "owner" : "userId",
                isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .where("rideComplete", isEqualTo: true)
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

            return ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: w * 0.05),
              itemCount: bookcar.length,
              itemBuilder: (context, index) {
                var car = bookcar[index];
                String ownerId = car['owner'];
                String formattedStartDate = formatStartDate(car['startDate']);
                String userId = car['userId'];

                return StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection(widget.isOwner ? "Booker" : "Owner")
                      .doc(widget.isOwner ? userId : ownerId)
                      .snapshots(),
                  builder: (context, userSnapshot) {
                    if (userSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (userSnapshot.hasData &&
                        userSnapshot.data != null) {
                      var userData = userSnapshot.data!;
                      String shopOrUserName = widget.isOwner
                          ? userData['firstName'] ?? 'Unknown User'
                          : userData['shopName'] ?? 'Unknown Shop';
                      String phoneNumber = userData['phoneNumber'] ?? 'N/A';

                      return buildCarCard(car, shopOrUserName, phoneNumber, w,
                          h, formattedStartDate);
                    } else {
                      return const Center(child: Text("User data not found."));
                    }
                  },
                );
              },
            );
          } else {
            return Center(child: apptext(myText: "No Complete Bookings"));
          }
        },
      ),
    );
  }

  Widget buildCarCard(QueryDocumentSnapshot car, String shopOrUserName,
      String phoneNumber, double w, double h, String formattedStartDate) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: w * 0.05, vertical: h * 0.02),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    apptext(
                      myText: car['carName'],
                      size: 17,
                      isBold: true,
                      textColor: AppColors.buttonColors,
                    ),
                    apptext(
                      myText: "Start Date: $formattedStartDate",
                      size: 12,
                      textColor: AppColors.buttonColors,
                    ),
                    apptext(
                      myText: "Phone: $phoneNumber",
                      size: 16,
                      textColor: AppColors.buttonColors,
                    ),
                    apptext(
                      myText: "Days Booked: ${car['carbookdays']}",
                      size: 16,
                      textColor: AppColors.buttonColors,
                    ),
                    apptext(
                      myText: "Total Pay: PKR ${car['payPrice']}",
                      size: 16,
                      textColor: AppColors.buttonColors,
                    ),
                    apptext(
                      myText: "Shop/User: $shopOrUserName",
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (!widget.isOwner) ...[
                SizedBox(
                  height: h * 0.055,
                  width: w * 0.58,
                  child: appbutton(
                    buttonText: "Rebook",
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Mybuttombaruser(),
                        ),
                        (route) => false,
                      );
                    },
                    bottonColor: AppColors.buttonColor2,
                    splashColor: AppColors.primaryColors,
                  ),
                ),
              
              ],
            ],
          ),
        ],
      ),
    );
  }

  String formatStartDate(String startDate) {
    DateTime dateTime = DateFormat("dd-MM-yyyy HH:mm").parse(startDate);
    return DateFormat("dd-MMM-yyyy HH:mm").format(dateTime);
  }
}
