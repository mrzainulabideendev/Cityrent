import 'package:car_rent/utilz/contants/export.dart';

import 'homescreen/homescreen.dart';

class Mybuttombaruser extends StatefulWidget {
  const Mybuttombaruser({super.key});

  @override
  State<Mybuttombaruser> createState() => _Mybuttombaruser();
}

class _Mybuttombaruser extends State<Mybuttombaruser> {
  List myPages = const [
    Homescreenuser(),
    Shopslistuser(),
    Profilescreen(
      isOwner: false,
    ),

    // Container(
    //   color: Colors.blue,
    // ),
  ];

  int pageIndex = 0;
  ////////////////////////////////////////////
  @override
  void initState() {
    final authsRead = context.read<Authencationcontroller>();
    authsRead.gettokeniddata(collection: "Booker");
    authsRead.uerData;
    super.initState();
  }

  ////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: myPages[pageIndex],
        // backgroundColor: AppColors.primaryColors,
        bottomNavigationBar: CurvedNavigationBar(
            // backgroundColor: AppColors.primaryColors,
            // buttonBackgroundColor:AppColors.primaryColors ,
            // color:AppColors.primaryColors. ,
            animationDuration: const Duration(milliseconds: 500),
            onTap: (index) {
              setState(() {
                pageIndex = index;
              });
            },
            items: const [
              Icon(
                Icons.home,
              ),
              //  Icon(Icons.view_list ),
              Icon(Icons.shopping_cart),
              Icon(Icons.person),
            ]),
      ),
    );
  }
}
