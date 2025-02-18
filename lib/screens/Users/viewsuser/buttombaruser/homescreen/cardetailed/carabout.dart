import 'package:car_rent/utilz/contants/export.dart';

class Aboutscreen extends StatefulWidget {
  final bool isOwner;
  final dynamic carData;
  final bool isUser;
  final dynamic isUserCardata;
  final bool isShop;
  final dynamic isShopData;
  const Aboutscreen({
    super.key,
    required this.isOwner,
    this.carData,
    required this.isUser,
    this.isUserCardata,
    required this.isShop,
    this.isShopData,
  });

  @override
  State<Aboutscreen> createState() => _AboutscreenState();
}

class _AboutscreenState extends State<Aboutscreen> {
  dynamic getActiveData() {
    if (widget.isOwner) {
      return widget.carData;
    } else if (widget.isUser) {
      return widget.isUserCardata;
    } else if (widget.isShop) {
      return widget.isShopData;
    }
    return {};
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    final activeData = getActiveData();
    
    String ownerId = activeData['ownerUid'];

    return Container(
      color: AppColors.textcolour,
      padding: EdgeInsets.symmetric(horizontal: w * 0.06, vertical: h * 0.01),
      height: h,
      width: w,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Conditional rendering
            widget.isOwner
                ? const SizedBox()
                : Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 2,
                          offset: const Offset(0, 2),
                        ),
                      ],
                      color: AppColors.textcolour,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    padding: EdgeInsets.symmetric(
                        horizontal: w * 0.03, vertical: h * 0.01),
                    height: h * 0.08,
                    width: w,
                    child: Row(
                      children: [
                        Icon(
                          Icons.message,
                          size: w * 0.08,
                        ),
                        SizedBox(
                          width: w * 0.04,
                        ),
                        apptext(
                            myText: "Chat With Owner", size: 15, isBold: true),
                        const Spacer(),
                        SizedBox(
                            width: w * 0.25,
                            child: appbutton(buttonText: "Chat", onTap: () {}))
                      ],
                    ),
                  ),
            SizedBox(
              height: h * 0.02,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                apptext(
                    myText:
                        '${activeData['Cardrand']}', // Data from active scenario
                    isBold: true,
                    size: 30),
                apptext(
                    myText: '${activeData['CarName']}'
                        '${activeData['Carmodel']}',
                    isBold: true,
                    size: 18),
////////////////////////////////////////////////////////////////////////
                StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('Owner')
                      .doc(ownerId)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }

                    if (!snapshot.hasData || snapshot.data == null) {
                      return const Text('Owner shop data not available');
                    }

                    // Assuming the shop name field in owner data is 'shopName'
                    final ownerData = snapshot.data!.data() as Map<String, dynamic>;
                    String shopName = ownerData['shopName'] ?? 'Unknown Shop';

                    return apptext(myText: shopName, size: 15);
                  },
                ),
                ////////////////////////////////////////////////////////////////////////
              ],
            ),
            SizedBox(
              height: h * 0.01,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                detailsbox(
                    imagePath: IconsApp.transmission,
                    boxname: '${activeData['CarTransmsion']}'), // Correct data
                detailsbox(
                    boxname: '${activeData['Carspeed']}Km/H',
                    imagePath: IconsApp.speedcar),
                detailsbox(imagePath: IconsApp.carchair, boxname: "4 seater"),
                detailsbox(
                  imagePath: IconsApp.carfule,
                  boxname: '${activeData['Carflue']}Km/L', // Correct data
                ),
              ],
            ),
            SizedBox(
              height: h * 0.02,
            ),
            const Divider(),
            apptext(
              myText: '${activeData['Cardescription']}', // Correct description
              size: 15,
            ),
          ],
        ),
      ),
    );
  }
}


//=============================================================
Widget detailsbox({
  required String imagePath,
  required String boxname,
}) {
  return Builder(builder: (context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: h * 0.06,
          width: w * 0.09,
          child: Image.asset(imagePath),
        ),
        SizedBox(height: h * 0.008),
        SizedBox(
          height: h * 0.02,
          child: apptext(myText: boxname, size: 13, isBold: true),
        ),
      ],
    );
  });
}
