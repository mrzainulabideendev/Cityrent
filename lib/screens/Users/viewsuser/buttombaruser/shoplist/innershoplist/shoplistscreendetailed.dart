import '../../../../../../utilz/contants/export.dart';
import 'shopabout.dart';

class Shopdetailsacreen extends StatefulWidget {
  final String heroTag;
  final dynamic ownerData;

  const Shopdetailsacreen({
    super.key,
    required this.heroTag,
    this.ownerData,
  });

  @override
  State<Shopdetailsacreen> createState() => _ShopdetailsacreenState();
}

class _ShopdetailsacreenState extends State<Shopdetailsacreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
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
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: apptext(myText: "Shop Details", size: 20, isBold: true),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Column(
          children: [
            Container(
              width: w,
              height: h * 0.3,
              child: Hero(
                tag: widget.heroTag,
                transitionOnUserGestures: true,
                child: Image.network(
                  widget.ownerData['ShopImage'],
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: h * 0.02),
            Container(
              width: w * 0.93,
              height: h * 0.06,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.grey.withOpacity(0.3),
              ),
              child: TabBar(
                labelColor: AppColors.primaryColors,
                controller: tabController,
                isScrollable: false,
                indicatorColor: AppColors.textcolour,
                dividerColor: Colors.transparent,
                labelPadding: EdgeInsets.symmetric(horizontal: 8.0),
                tabs: [
                  apptext(
                      myText: "Cars",
                      textColor: AppColors.buttonColors,
                      isBold: true,
                      size: 15),
                  apptext(
                      myText: "About",
                      textColor: AppColors.buttonColors,
                      isBold: true,
                      size: 15),
                  // apptext(
                  //     myText: "Review",
                  //     textColor: AppColors.buttonColors,
                  //     isBold: true,
                  //     size: 15),
                ],
              ),
            ),
            SizedBox(height: h * 0.02),
            Expanded(
              child: TabBarView(
                controller: tabController,
                children: [
                  ShopCarList(
                    ownerCardata: widget.ownerData,
                  ),
                  ShopAbout(ownerdata: widget.ownerData),
                  // Reviewscreen(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
