import 'package:car_rent/screens/Users/viewsuser/buttombaruser/homescreen/Users_Drawer.dart';
import 'package:car_rent/utilz/contants/export.dart';

class Homescreenuser extends StatefulWidget {
  const Homescreenuser({super.key});

  @override
  State<Homescreenuser> createState() => _HomescreenuserState();
}

class _HomescreenuserState extends State<Homescreenuser> {
  List<Map<String, String>> carBrandsWithLogos = [
    {"brand": "Honda", "brandImg": LogosApp.hondalogo},
    {"brand": "BMW", "brandImg": LogosApp.bmwlogo},
    {"brand": "Audi", "brandImg": LogosApp.audilogo},
    {"brand": "Hyundai", "brandImg": LogosApp.hyundailogo},
    {"brand": "Nissan", "brandImg": LogosApp.nissanlogo},
    {"brand": "Kia", "brandImg": LogosApp.kialogo},
    {"brand": "Mazda", "brandImg": LogosApp.mazdalogo},
    {"brand": "Suzuki", "brandImg": LogosApp.suzukilogo},
    {"brand": "Toyota", "brandImg": LogosApp.toyotalogo},

    {"brand": "Other", "brandImg": IconsApp.speedcar}, // Use a default logo
  ];
  String carSearch = '';

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    final authW = context.watch<Authencationcontroller>();

    return Scaffold(
      drawer: UsersDrawer(),
      body: Builder(builder: (context) {
        return Container(
          color: AppColors.textcolour,
          padding: EdgeInsets.symmetric(
            horizontal: w * 0.05,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: h * 0.02,
              ),
              Row(
                children: [
                  apptext(
                      myText:
                          "Hi, ${authW.userData!['firstName']} ${authW.userData!['lastName']}",
                      textColor: Colors.black,
                      size: 30,
                      isBold: true),
                  const Spacer(),
                  IconButton(
                      onPressed: () {
                        Scaffold.of(context).openDrawer();
                      },
                      icon: const Icon(
                        Icons.menu,
                        color: AppColors.buttonColors,
                        size: 35,
                      ))
                ],
              ),
              SizedBox(
                height: h * 0.02,
              ),
              //===============================Search======================
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

              SizedBox(
                height: h * 0.21,
                width: w,
                child: ListView.builder(
                  itemCount: carBrandsWithLogos.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    // Get the current brand data
                    final brandData = carBrandsWithLogos[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        margin: const EdgeInsets.only(right: 1),
                        height: h * 0.14,
                        width: w * 0.46,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.15),
                              spreadRadius: 3,
                              blurRadius: 5,
                              offset: Offset(0, 2),
                            ),
                          ],
                          color: AppColors.textcolour,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.all(10),
                              width: w * 0.6,
                              height: h * 0.13,
                              child: Image.asset(
                                brandData['brandImg']!,
                                // fit: BoxFit.cover,
                              ),
                            ),
                            apptext(
                              myText: brandData['brand']!,
                              size: 20,
                              isBold: true,
                              textColor: AppColors.buttonColors,
                            ),
                            apptext(
                              myText:
                                  "20", // You can replace this with actual data if needed
                              size: 15,
                              isBold: true,
                              textColor: AppColors.buttonColors,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              //===========================================Car list ========================

              const Divider(
                height: 20,
                thickness: 1,
                color: Colors.grey,
              ),
              apptext(
                  myText: "Available vehicles",
                  size: 20,
                  isBold: true,
                  textColor: AppColors.buttonColors),
              const Divider(
                height: 20,
                thickness: 1,
                color: Colors.grey, // Color of the line
              ),

              //================================================== Available vehicles===================
              Expanded(
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("Cars")
                      .where('isActive', isEqualTo: true)
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

                      if (carSearch.isNotEmpty) {
                        carsData2user = carsData2user.where((element) {
                          return element
                              .get('CarName')
                              .toString()
                              .toLowerCase()
                              .contains(carSearch.toLowerCase());
                        }).toList();
                      }

                      if (carsData2user.isNotEmpty) {
                        return ListView.builder(
                          itemCount: carsData2user.length,
                          itemBuilder: (context, index) {
                            String heroTag =
                                "cardetail_${carsData2user[index]['CarImages'][0]}";

                            return Container(
                              margin: const EdgeInsets.only(bottom: 20),
                              padding:
                                  EdgeInsets.symmetric(horizontal: w * 0.05),
                              width: w,
                              height: h * 0.33,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [Colors.white, Colors.grey.shade100],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    spreadRadius: 3,
                                    blurRadius: 5,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: Stack(
                                children: [
                                  // Car Details
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: h * 0.01),
                                      Row(
                                        children: [
                                          apptext(
                                            myText: carsData2user[index]
                                                ['CarName'],
                                            size: 22,
                                            isBold: true,
                                            textColor: AppColors.buttonColors,
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          apptext(
                                            myText: carsData2user[index]
                                                ['Cardrand'],
                                            size: 15,
                                            textColor: AppColors.buttonColors,
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          apptext(
                                            myText: "Car Rent (Day)",
                                            size: 17,
                                            textColor: AppColors.buttonColors,
                                          ),
                                          Spacer(),
                                          apptext(
                                            myText:
                                                '${carsData2user[index]['Carrent']} pkr',
                                            size: 20,
                                            isBold: true,
                                            textColor: AppColors.primaryColors,
                                          ),
                                        ],
                                      ),
                                      // Car Model
                                      Row(
                                        children: [
                                          apptext(
                                            myText: "Car Model",
                                            size: 13,
                                            textColor: AppColors.buttonColors,
                                          ),
                                          Spacer(),
                                          apptext(
                                            myText: carsData2user[index]
                                                ['Carmodel'],
                                            size: 13,
                                            isBold: true,
                                            textColor: AppColors.primaryColors,
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: h * 0.005),
                                      // Car Image
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            PageRouteBuilder(
                                              pageBuilder: (context, animation,
                                                      secondaryAnimation) =>
                                                  CarDetailsScreen(
                                                isOwner: false,
                                                isShop: false,
                                                isUser: true,
                                                isUserCardata:
                                                    carsData2user[index],
                                                heroTag: heroTag,
                                              ),
                                            ),
                                          );
                                        },
                                        child: Hero(
                                          tag: heroTag,
                                          transitionOnUserGestures: true,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            child: Image.network(
                                              carsData2user[index]['CarImages']
                                                  [0],
                                              fit: BoxFit.cover,
                                              width: double.infinity,
                                              height: h * 0.18,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Positioned(
                                    top: 07,
                                    right: 1,
                                    child: IconButton(
                                      iconSize:
                                          30, // Adjust the size of the icon as needed
                                      icon: Icon(
                                        context
                                                .watch<UserViewerController>()
                                                .isCarFavorite(
                                                    carsData2user[index]
                                                        .reference
                                                        .id)
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        color: context
                                                .watch<UserViewerController>()
                                                .isCarFavorite(
                                                    carsData2user[index]
                                                        .reference
                                                        .id)
                                            ? Colors.red
                                            : Colors.grey,
                                      ),
                                      onPressed: () {
                                        final carId =
                                            carsData2user[index].reference.id;
                                        final isFavorite = context
                                            .read<UserViewerController>()
                                            .isCarFavorite(carId);

                                        context
                                            .read<UserViewerController>()
                                            .toggleFavoriteCar(
                                                carId, isFavorite);
                                      },
                                    ),
                                  ),
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
                ),
              )

              //////////////////////////////////////////////////
            ],
          ),
        );
      }),
    );
  }
}
