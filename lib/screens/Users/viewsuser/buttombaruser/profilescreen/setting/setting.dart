import 'package:car_rent/utilz/contants/export.dart';

class Settingscreen extends StatefulWidget {
  const Settingscreen({super.key});

  @override
  State<Settingscreen> createState() => _SettingscreenState();
}

class _SettingscreenState extends State<Settingscreen> {
  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    //final authsRead = context.read<Authencationcontroller>();

    return SafeArea(
      child: Scaffold(
        body: Container(
          color: AppColors.textcolour,
          width: w,
          height: h,
          padding: EdgeInsets.symmetric(horizontal: w * 0.05, vertical: h * 0.06),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(Icons.arrow_back_ios_new)),
              SizedBox(
                height: h * 0.02,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  apptext(
                    myText: "Settings",
                    size: 30,
                    isBold: true,
                  ),
                ],
              ),
              SizedBox(height: h * 0.02),
              Settingboxprofile(
                boxtext: "Password Manger",
                boxicons: Icons.password,
                onpressed: () {
                  Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            const passwordmangerscreen(),
                      ));
                },
              ),
              const Divider(),
              Settingboxprofile(
                boxtext: "Delete Account",
                boxicons: Icons.delete_sharp,
                onpressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return PopUpforall(
                            popupname: "Delete Account",
                            popudescription: " Are you want Delete Account? ",
                            popuicon: Icons.delete_sharp,
                            ontaps: () {
                              //  bool res =
                              //                   await authsRead.deleteUser(context: context,password: FirebaseAuth.instance. );
                              //               if (res) {
                              //                 Navigator.pushAndRemoveUntil(
                              //                   context,
                              //                   PageRouteBuilder(
                              //                     pageBuilder:
                              //                         (context, animation, secondaryAnimation) =>
                              //                             LoginScreen(),
                              //                   ),
                              //                   (route) => false,
                              //               );
                              //               }
                            });
                      });
                },
              ),
              const Divider(),
            ],
          ),
        ),
      ),
    );
  }
}

//========================================= Settings boxxs==========================================

Widget Settingboxprofile({
  required String boxtext,
  required IconData boxicons,
  onpressed,
}) {
  return Builder(
    builder: (context) {
      final w = MediaQuery.of(context).size.width;

      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(
            boxicons,
            size: 30,
          ),
          SizedBox(
            width: w * 0.02,
          ),
          Expanded(
            child: Text(
              boxtext,
              style: const TextStyle(
                fontSize: 20,
                color: AppColors.buttonColors,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          IconButton(
            onPressed: onpressed,
            icon: const Icon(Icons.arrow_forward_ios),
          ),
        ],
      );
    },
  );
}
