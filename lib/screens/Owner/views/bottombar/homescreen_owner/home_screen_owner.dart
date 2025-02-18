import 'package:car_rent/utilz/contants/export.dart';

class Homescreenowner extends StatefulWidget {
  const Homescreenowner({super.key});

  @override
  State<Homescreenowner> createState() => _HomescreenownerState();
}

class _HomescreenownerState extends State<Homescreenowner> {
//   List<Map<String, String>> carBrandsWithLogos = [
//     {"brand": "Honda", "brandImg": LogosApp.hondalogo},
//     {"brand": "BMW", "brandImg": LogosApp.bmwlogo},
//     {"brand": "Audi", "brandImg": LogosApp.audilogo},
//     {"brand": "Hyundai", "brandImg": LogosApp.hyundailogo},
//     {"brand": "Nissan", "brandImg": LogosApp.nissanlogo},
//     {"brand": "Kia", "brandImg": LogosApp.kialogo},
//     {"brand": "Mazda", "brandImg": LogosApp.mazdalogo},
//     {"brand": "Suzuki", "brandImg": LogosApp.suzukilogo},
//     {"brand": "Toyota", "brandImg": LogosApp.toyotalogo},

//     {"brand": "Other", "brandImg": IconsApp.speedcar}, // Use a default logo
  // ];
  String carSearch = '';
  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    final authW = context.watch<Authencationcontroller>();
    // final cardetail = context.watch<Ownerviewercontroller>();

    return Scaffold(
      backgroundColor: AppColors.textcolour,
      drawer: OwnerDrawer(),
      body: Builder(builder: (context) {
        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: w * 0.05,
          ),
          width: w,
          height: h,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SizedBox(
                    height: h * 0.08,
                  ),
                  apptext(
                      myText:
                          "Hi, ${authW.userData!['firstName']} ${authW.userData!['lastName']}",
                      size: 25,
                      isBold: true),
                  Spacer(),
                  GestureDetector(
                      onTap: () {
                        Scaffold.of(context).openDrawer();
                      },
                      child: Icon(
                        Icons.menu,
                        size: 40,
                      )),
                ],
              ),
              //===============================Search======================

              // const Divider(),
              TextFormField(
                onChanged: (value) {
                  setState(() {
                    carSearch = value;
                  });
                },
                style: const TextStyle(fontFamily: "Poppins"),
                decoration: InputDecoration(
                  fillColor: AppColors.textcolour,
                  filled: true,
                  contentPadding:
                      const EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
                  hintText: "Search for a car",
                  prefixIcon: const Icon(
                    Icons.search,
                  ), // Icon for search
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(color: AppColors.buttonColors),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(color: AppColors.buttonColors),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(color: AppColors.buttonColors),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(color: AppColors.buttonColors),
                  ),
                ),
              ),
              //===========================================Search========================
              //===========================================Car list ========================
              SizedBox(
                height: h * 0.02,
              ),
              //===========================================Car list ========================

              // SizedBox(
              //   height: h * 0.21,
              //   width: w,
              //   child: ListView.builder(
              //     itemCount: carBrandsWithLogos.length,
              //     scrollDirection: Axis.horizontal,
              //     itemBuilder: (context, index) {
              //       // Get the current brand data
              //       final brandData = carBrandsWithLogos[index];
              //       return Padding(
              //         padding: const EdgeInsets.all(8.0),
              //         child: Container(
              //           margin: const EdgeInsets.only(right: 1),
              //           height: h * 0.14,
              //           width: w * 0.46,
              //           decoration: BoxDecoration(
              //             boxShadow: [
              //               BoxShadow(
              //                 color: Colors.grey.withOpacity(0.15),
              //                 spreadRadius: 3,
              //                 blurRadius: 5,
              //                 offset: Offset(0, 2),
              //               ),
              //             ],
              //             color: AppColors.textcolour,
              //             borderRadius: BorderRadius.circular(25),
              //           ),
              //           child: Column(
              //             children: [
              //               Container(
              //                 padding: EdgeInsets.all(10),
              //                 width: w * 0.6,
              //                 height: h * 0.13,
              //                 child: Image.asset(
              //                   brandData['brandImg']!,
              //                   // fit: BoxFit.cover,
              //                 ),
              //               ),
              //               apptext(
              //                 myText: brandData['brand']!,
              //                 size: 20,
              //                 isBold: true,
              //                 textColor: AppColors.buttonColors,
              //               ),
              //               apptext(
              //                 myText:
              //                     "20", // You can replace this with actual data if needed
              //                 size: 15,
              //                 isBold: true,
              //                 textColor: AppColors.buttonColors,
              //               ),
              //             ],
              //           ),
              //         ),
              //       );
              //     },
              //   ),
              // ),
              //===========================================Car list ========================

              const Divider(
                height: 20,
                thickness: 1,
                color: Colors.grey,
              ),
              apptext(
                  myText: "Your Vehicles",
                  size: 20,
                  isBold: true,
                  textColor: AppColors.buttonColors),
              const Divider(
                height: 20,
                thickness: 1,
                color: Colors.grey,
              ),

              //================================================== Your vehicles===================
              SizedBox(
                height: h * 0.02,
              ),
              Expanded(
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("Cars")
                      .where("ownerUid",
                          isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primaryColors,
                        ),
                      );
                    } else if (snapshot.hasData) {
                      var carsData = snapshot.data!.docs;

                      // Search functionality
                      if (carSearch.isNotEmpty) {
                        carsData = carsData.where((element) {
                          return element
                              .get('CarName')
                              .toString()
                              .toLowerCase()
                              .contains(carSearch.toLowerCase());
                        }).toList();
                      }

                      if (carsData.isNotEmpty) {
                        return ListView.builder(
                          itemCount: carsData.length,
                          itemBuilder: (context, index) {
                            String heroTag =
                                "cardetail_${carsData[index]['CarImages'][0]}";
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (context, animation,
                                            secondaryAnimation) =>
                                        CarDetailsScreen(
                                      showBottomBar: false,
                                      isOwner: true,
                                      isShop: false,
                                      isUser: false,

                                      heroTag: heroTag,
                                      carData:
                                          carsData[index], // Pass car data here
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                clipBehavior: Clip.antiAlias,
                                margin: const EdgeInsets.only(bottom: 10),
                                padding: EdgeInsets.symmetric(
                                  horizontal: w * 0.05,
                                ),
                                width: w,
                                height: h * 0.32,
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.2),
                                      spreadRadius: 3,
                                      blurRadius: 5,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                  color:
                                      const Color.fromARGB(255, 215, 214, 214),
                                  borderRadius: BorderRadius.circular(34),
                                ),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: h * 0.01,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        apptext(
                                            myText: carsData[index]['CarName'],
                                            size: 22,
                                            isBold: true,
                                            textColor: AppColors.buttonColors),
                                        Spacer(),
                                        apptext(
                                          myText: carsData[index]['isActive']
                                              ? 'Active'
                                              : 'Disactive',
                                          size: 13,
                                        ),
                                        SizedBox(
                                          width: w * 0.02,
                                        ),
                                        Container(
                                          height: h * 0.02,
                                          width: w * 0.02,
                                          decoration: BoxDecoration(
                                            color: carsData[index]['isActive']
                                                ? Colors.green
                                                : Colors.red,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        apptext(
                                            myText: carsData[index]['Cardrand'],
                                            size: 15,
                                            isBold: true,
                                            textColor: AppColors.buttonColors),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        apptext(
                                          myText: 'Car Rent(Day)',
                                          size: 16,
                                        ),
                                        Spacer(),
                                        apptext(
                                            myText:
                                                '${carsData[index]['Carrent']} pkr',
                                            size: 16,
                                            textColor: AppColors.primaryColors),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        apptext(
                                            myText: "Car Model",
                                            size: 13,
                                            isBold: true,
                                            textColor: AppColors.buttonColors),
                                        Spacer(),
                                        apptext(
                                            myText: carsData[index]['Carmodel'],
                                            size: 13,
                                            textColor: AppColors.primaryColors),
                                      ],
                                    ),
                                    SizedBox(
                                      height: h * 0.01,
                                    ),
                                    Container(
                                      clipBehavior: Clip.antiAlias,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      width: w,
                                      height: h * 0.16,
                                      child: Hero(
                                        tag: heroTag,
                                        child: Image.network(
                                            carsData[index]['CarImages'][0],
                                            fit: BoxFit.cover),
                                      ),
                                    ),
                                  ],
                                ),
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
                ),
              )
            ],
          ),
        );
      }),
    );
  }
}
