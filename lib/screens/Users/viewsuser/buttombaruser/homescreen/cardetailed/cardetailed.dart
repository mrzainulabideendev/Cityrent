import 'package:car_rent/screens/Users/viewsuser/buttombaruser/homescreen/cardetailed/book_car_book_button.dart';
import 'package:car_rent/utilz/contants/export.dart';

class CarDetailsScreen extends StatefulWidget {
  final String heroTag;
  final bool showBottomBar;
  final bool isOwner;
  final dynamic carData;
  final bool isUser;
  final dynamic isUserCardata;
  final bool isShop;
  final dynamic isShopData;

  const CarDetailsScreen({
    super.key,
    required this.heroTag,
    this.showBottomBar = true,
    required this.isOwner,
    this.carData,
    required this.isUser,
    this.isUserCardata,
    required this.isShop,
    this.isShopData,
  });

  @override
  State<CarDetailsScreen> createState() => _CarDetailsScreenState();
}

class _CarDetailsScreenState extends State<CarDetailsScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    final carRead = context.read<Ownerviewercontroller>();
    final carwatch = context.watch<Ownerviewercontroller>();

    final carData = widget.isOwner
        ? widget.carData
        : widget.isUser
            ? widget.isUserCardata
            : widget.isShop
                ? widget.isShopData
                : null;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: apptext(myText: "Car Details", size: 20, isBold: true),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Stack(
          children: [
            Column(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 186, 182, 182),
                  ),
                  width: w,
                  height: h * 0.25,
                  child: Hero(
                    tag: widget.heroTag,
                    transitionOnUserGestures: true,
                    child: Image.network(
                      carData['CarImages'][0],
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(
                  height: h * 0.02,
                ),
                Container(
                  width: w * 0.93,
                  height: h * 0.07,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.grey.withOpacity(0.3),
                  ),
                  child: TabBar(
                    controller: tabController,
                    isScrollable: false,
                    indicatorColor: Colors.white,
                    dividerColor: Colors.transparent,
                    labelPadding: EdgeInsets.symmetric(horizontal: 8.0),
                    tabs: [
                      apptext(
                          myText: "About",
                          textColor: AppColors.buttonColors,
                          isBold: true,
                          size: 15),
                      apptext(
                          myText: "Gallery",
                          textColor: AppColors.buttonColors,
                          isBold: true,
                          size: 15),
                      apptext(
                          myText: "Review",
                          textColor: AppColors.buttonColors,
                          isBold: true,
                          size: 15),
                    ],
                  ),
                ),
                SizedBox(
                  height: h * 0.02,
                ),
                Expanded(
                  child: TabBarView(
                    controller: tabController,
                    children: [
                      Aboutscreen(
                        isShop: widget.isShop,
                        isShopData: widget.isShopData,
                        isUser: widget.isUser,
                        isUserCardata: widget.isUserCardata,
                        carData: widget.carData,
                        isOwner: widget.isOwner,
                      ),
                      Galleryscreen(
                        imagesCarList: carData['CarImages'],
                      ),
                      Reviewscreen(
                        carData: carData,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            carwatch.isLoading ? loadingforall() : const SizedBox(),
          ],
        ),
        bottomNavigationBar: widget.showBottomBar
            ? Container(
                height: h * 0.1,
                width: w,
                padding: EdgeInsets.symmetric(horizontal: w * 0.04),
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    apptext(
                        myText: '${carData['Carrent']}(Day)',
                        textColor: AppColors.buttonColors,
                        isBold: true,
                        size: 24),
                    SizedBox(
                      height: h * 0.065,
                      width: w * 0.35,
                      child: appbutton(
                          buttonText: "Book Car",
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (context) => Mybooking(
                                carData: carData,
                              ),
                            );
                          }),
                    ),
                  ],
                ),
              )
            : Container(
                height: h * 0.1,
                width: w,
                padding: EdgeInsets.symmetric(horizontal: w * 0.04),
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      height: h * 0.065,
                      width: w * 0.35,
                      child: appbutton(
                          buttonText: carData["isActive"] ? "Deactive" : "Active",
                          bottonColor:
                              carData["isActive"] ? Colors.red : Colors.green,
                          onTap: () async {
                            bool status = await carRead.carUpdateData(
                                carData.reference.id,
                                carData["isActive"] ? false : true);
                            if (status) {
                              snaki(context: context, msg: "Update sucessfully");
                              Navigator.pop(context);
                            }
                          }),
                    ),
                    SizedBox(
                      height: h * 0.065,
                      width: w * 0.35,
                      child: appbutton(
                          buttonText: "Edit",
                          onTap: () {
                            Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder:
                                      (context, animation, secondaryAnimation) =>
                                          CarAddEditScreen(
                                    isAddNewCar: false,
                                    cardata: carData,
                                  ),
                                ));
                          }),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
