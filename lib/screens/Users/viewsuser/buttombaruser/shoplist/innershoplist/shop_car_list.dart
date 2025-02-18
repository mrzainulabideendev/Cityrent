import 'package:car_rent/utilz/contants/export.dart';

class ShopCarList extends StatefulWidget {
  final dynamic ownerCardata;

  const ShopCarList({
    super.key,
    this.ownerCardata,
  });

  @override
  State<ShopCarList> createState() => _ShopCarListState();
}

class _ShopCarListState extends State<ShopCarList> {
  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("Cars")
          .where('isActive', isEqualTo: true)
          .where('ownerUid',
              isEqualTo: widget.ownerCardata['Uid']) 
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              color: AppColors.primaryColors,
            ),
          );
        } else if (snapshot.hasData) {
          var carsData2user = snapshot.data!.docs;

          if (carsData2user.isNotEmpty) {
            return ListView.builder(
              itemCount: carsData2user.length,
              itemBuilder: (context, index) {
                String heroTag =
                    "cardetail_${carsData2user[index]['CarImages'][0]}";

                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: EdgeInsets.symmetric(
                    horizontal: w * 0.05,
                  ),
                  width: w,
                  height: h * 0.3,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 3,
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                    color: const Color.fromARGB(255, 215, 214, 214),
                    borderRadius: BorderRadius.circular(34),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          apptext(
                              myText: carsData2user[index]['CarName'],
                              size: 22,
                              isBold: true,
                              textColor: AppColors.buttonColors),
                          const Spacer(),
                          apptext(
                              myText: '${carsData2user[index]['Carrent']} pkr',
                              size: 20,
                              textColor: AppColors.primaryColors),
                        ],
                      ),
                      Row(
                        children: [
                          apptext(
                              myText: carsData2user[index]['Cardrand'],
                              size: 15,
                              isBold: true,
                              textColor: AppColors.buttonColors),
                          const Spacer(),
                          apptext(
                              myText: "/Per Day",
                              size: 15,
                              textColor: AppColors.primaryColors),
                        ],
                      ),
                      Row(
                        children: [
                          apptext(
                              myText: "Car Model",
                              size: 15,
                              isBold: true,
                              textColor: AppColors.buttonColors),
                          const Spacer(),
                          apptext(
                              myText: carsData2user[index]['Carmodel'],
                              size: 15,
                              textColor: AppColors.primaryColors),
                        ],
                      ),
                      SizedBox(
                        width: w,
                        height: h * 0.01,),
                      SizedBox(
                        width: w,
                        height: h * 0.18,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder:
                                    (context, animation, secondaryAnimation) =>
                                        CarDetailsScreen(
                                  isOwner: false,
                                  isShop: true,
                                  isUser: false,
                                  isShopData: carsData2user[index],
                                  heroTag: heroTag,
                                ),
                              ),
                            );
                          },
                          child: Hero(
                            tag: heroTag,
                            transitionOnUserGestures: true,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(
                                  25), // Adds circular radius of 25
                              child: Image.network(
                                carsData2user[index]['CarImages'][0],
                                fit: BoxFit
                                    .cover, // Ensures the image covers the container
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                );
              },
            );
          } else {
            return Center(child: apptext(myText: "No Car Found"));
          }
        } else {
          return Center(child: apptext(myText: "No Car Found"));
        }
      },
    );
  }
}
