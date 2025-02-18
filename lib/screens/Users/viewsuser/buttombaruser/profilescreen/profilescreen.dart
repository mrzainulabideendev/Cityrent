import 'package:car_rent/screens/Users/viewsuser/buttombaruser/profilescreen/mybooking/mybooking.dart';
import 'package:car_rent/utilz/contants/export.dart';

class Profilescreen extends StatefulWidget {
  final bool isOwner;
  const Profilescreen({super.key, this.isOwner = true});

  @override
  State<Profilescreen> createState() => _ProfilescreenState();
}

class _ProfilescreenState extends State<Profilescreen> {
  XFile? image;
  final ImagePicker _picker = ImagePicker();

  Future<void> pickImage({required ImageSource source}) async {
    image = await _picker.pickImage(source: source);
    setState(() {});
    await context.read<Authencationcontroller>().uploadProfileImage(
        image!.path, context.read<Authencationcontroller>().userData!['role']);

    context
        .read<Authencationcontroller>()
        .getUserRole(FirebaseAuth.instance.currentUser!.uid);
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    final authW = context.watch<Authencationcontroller>();

    return Scaffold(
      body: Container(
        color: AppColors.textcolour,
        width: w,
        height: h,
        padding: EdgeInsets.symmetric(
          horizontal: w * 0.05,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: h * 0.06,
              ),
              apptext(myText: "Profile", size: 26, isBold: true),
              SizedBox(
                height: h * 0.01,
              ),
              Stack(
                children: [
                  Container(
                    clipBehavior: Clip.antiAlias,
                    height: h * 0.15,
                    width: w * 0.36,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border:
                          Border.all(color: AppColors.buttonColors, width: 1),
                    ),
                    child: image != null
                        ? Image.file(
                            File(image!.path),
                            fit: BoxFit.cover,
                          )
                        : authW.userData!['ProfileImage'] != ''
                            ? Image.network(
                                authW.userData!['ProfileImage'],
                                fit: BoxFit.cover,
                              )
                            : Icon(
                                Icons.person_rounded,
                                size: w * 0.38,
                              ),
                  ),
                  Positioned(
                    right: w * 0.03,
                    top: h * 0.085,
                    child: Container(
                      clipBehavior: Clip.antiAlias,
                      height: h * 0.09,
                      width: w * 0.08,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primaryColors,
                      ),
                      child: GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (context) => imagePiuckerWidget(),
                          );
                        },
                        child: Icon(
                          Icons.mode_edit_outline_outlined,
                          color: AppColors.textcolour,
                          size: w * 0.06,
                        ),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: h * 0.02,
              ),
              apptext(
                myText:
                    "${authW.userData!["firstName"]} ${authW.userData!["lastName"]}",
                size: 20,
                isBold: true,
              ),
              SizedBox(
                height: h * 0.03,
              ),
              boxxprofile(
                  boxtext: "Your Profile",
                  boxicons: Icons.person,
                  onprsed: () {
                    Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  YourProfilescreen(
                            isOwner: widget.isOwner,
                          ),
                        ));
                  }),
              if (widget.isOwner)
                Column(
                  children: [
                    boxxprofile(
                        boxtext: "Change Shop Location",
                        boxicons: Icons.location_on_rounded,
                        onprsed: () {
                          Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder:
                                    (context, animation, secondaryAnimation) =>
                                        NewPlacePicker(
                                  ownerediti: true,
                                ),
                              ));
                        }),
                  ],
                ),
              boxxprofile(
                  boxtext: "My Booking",
                  boxicons: Icons.format_list_bulleted_outlined,
                  onprsed: () {
                    Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  MyWidget(
                            isOwner: widget.isOwner,
                          ),
                        ));
                  }),
              boxxprofile(
                  boxtext: "Settings",
                  boxicons: Icons.settings,
                  onprsed: () {
                    Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  const Settingscreen(),
                        ));
                  }),
              boxxprofile(
                  boxtext: "Help Center",
                  boxicons: Icons.help_outline_outlined),
              boxxprofile(
                  boxtext: "Privacy Policy", boxicons: Icons.privacy_tip),
              boxxprofile(
                  boxtext: "Logout",
                  boxicons: Icons.login_outlined,
                  onprsed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return PopUpforall(
                            popupname: "Logout",
                            popudescription: "Are you sure you want to logout?",
                            popuicon: Icons.logout,
                            ontaps: () async {
                              if (widget.isOwner) {
                                await authW.removeDeviceTokenOnLogout(
                                    collection: "Owner");
                                await FirebaseAuth.instance.signOut();

                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const LoginScreen()),
                                  (route) => false,
                                );
                              } else {
                                await authW.removeDeviceTokenOnLogout(
                                    collection: "Booker");
                                await FirebaseAuth.instance.signOut();

                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const LoginScreen()),
                                  (route) => false,
                                );
                              }
                            },
                          );
                        });
                  }),
            ],
          ),
        ),
      ),
    );
  }
  //====================================imagePiuckerWidget////////////////////////////////

  imagePiuckerWidget() {
    return Builder(builder: (context) {
      final h = MediaQuery.of(context).size.height;
      final w = MediaQuery.of(context).size.width;
      return Container(
        height: h * 0.22,
        width: w,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () async {
                    await pickImage(source: ImageSource.camera);
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.camera_alt_outlined),
                  iconSize: w * 0.13,
                ),
                apptext(myText: "Camera", isBold: true, size: 13),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () async {
                    await pickImage(source: ImageSource.gallery);
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.photo_size_select_actual_sharp),
                  iconSize: w * 0.13,
                ),
                apptext(myText: "Gallery", isBold: true, size: 13),
              ],
            ),
          ],
        ),
      );
    });
  }
}

//=================================================== Box profile screen=============
Widget boxxprofile({
  required boxtext,
  required boxicons,
  onprsed,
}) {
  return Builder(builder: (context) {
    final w = MediaQuery.of(context).size.width;

    return Column(
      children: [
        Row(
          children: [
            Icon(
              boxicons,
              size: 30,
            ),
            SizedBox(
              width: w * 0.01,
            ),
            apptext(
                myText: boxtext,
                size: 13,
                textColor: AppColors.buttonColors,
                isBold: true),
            const Spacer(),
            IconButton(
                onPressed: onprsed,
                iconSize: 20,
                icon: Icon(Icons.arrow_forward_ios)),
          ],
        ),
        const Divider(),
      ],
    );
  });
}
///================================================
