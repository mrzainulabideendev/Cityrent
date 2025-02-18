import 'package:car_rent/utilz/contants/export.dart';

class MyBottomBarOwner extends StatefulWidget {
  const MyBottomBarOwner({super.key});

  @override
  State<MyBottomBarOwner> createState() => _MyBottomBarOwnerState();
}

class _MyBottomBarOwnerState extends State<MyBottomBarOwner> {
  List myPages = [
    const Homescreenowner(),
    const CarAddEditScreen(
      isAddNewCar: true,
    ),
    const Profilescreen(
      isOwner: true,
    ),
  ];

  int pageIndex = 0;

  @override
  void initState() {
    final authsRead = context.read<Authencationcontroller>();
    authsRead.gettokeniddata(collection: 'Owner');
    authsRead.uerData;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: myPages[pageIndex],
        bottomNavigationBar: CurvedNavigationBar(
            
            onTap: (index) {
              setState(() {
                pageIndex = index;
              });
            },
            items: const [
              Icon(Icons.home),
              Icon(Icons.add),
              Icon(Icons.person),
            ]),
      ),
    );
  }
}
