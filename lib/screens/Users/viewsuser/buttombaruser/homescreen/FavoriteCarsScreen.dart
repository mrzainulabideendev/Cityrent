import 'package:car_rent/utilz/contants/export.dart';

class FavoriteCarsScreen extends StatelessWidget {
  const FavoriteCarsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userViewerController = context.watch<UserViewerController>();

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Favorite Cars"),
        ),
        body: StreamBuilder(
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
              // Filter favorite cars
              var favoriteCars = carsData2user.where((car) {
                return userViewerController.favoriteCars.contains(car.reference.id);
              }).toList();

              if (favoriteCars.isNotEmpty) {
                return ListView.builder(
                  itemCount: favoriteCars.length,
                  itemBuilder: (context, index) {
                    String heroTag =
                        "cardetail_${favoriteCars[index]['CarImages'][0]}";

                    return Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      padding: EdgeInsets.symmetric(horizontal: 20),
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: apptext(
                                      myText: favoriteCars[index]['CarName'],
                                      size: 26,
                                      isBold: true,
                                      textColor: AppColors.buttonColors,
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      context.watch<UserViewerController>().isCarFavorite(favoriteCars[index].reference.id)
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      color: context.watch<UserViewerController>().isCarFavorite(favoriteCars[index].reference.id)
                                          ? Colors.red
                                          : Colors.grey,
                                    ),
                                    onPressed: () {
                                      final carId = favoriteCars[index].reference.id;
                                      final isFavorite = context
                                          .read<UserViewerController>()
                                          .isCarFavorite(carId);

                                      context.read<UserViewerController>().toggleFavoriteCar(carId, isFavorite);
                                    },
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  apptext(
                                    myText: '${favoriteCars[index]['Carrent']} PKR',
                                    size: 20,
                                    textColor: AppColors.primaryColors,
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              // Car Image
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder: (context, animation, secondaryAnimation) => CarDetailsScreen(
                                        isOwner: false,
                                        isShop: false,
                                        isUser: true,
                                        isUserCardata: favoriteCars[index],
                                        heroTag: heroTag,
                                      ),
                                    ),
                                  );
                                },
                                child: Hero(
                                  tag: heroTag,
                                  transitionOnUserGestures: true,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: Image.network(
                                      favoriteCars[index]['CarImages'][0],
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      height: 150, // Adjust height as needed
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                );
              } else {
                return Center(child: apptext(myText: "No Favorite Cars Found"));
              }
            } else {
              return Center(child: apptext(myText: "No Cars Available"));
            }
          },
        ),
      ),
    );
  }
}
