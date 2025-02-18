import 'package:car_rent/utilz/contants/export.dart';

class OwnerDrawer extends StatefulWidget {
  const OwnerDrawer({super.key});

  @override
  State<OwnerDrawer> createState() => _OwnerDrawerState();
}

class _OwnerDrawerState extends State<OwnerDrawer> {
  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    final authW = context.watch<Authencationcontroller>();

    return Container(
      clipBehavior: Clip.antiAlias,
      width: w * 0.75, // Slightly wider for more space
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primaryColors, Color.fromARGB(255, 224, 225, 232)],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.horizontal(right: Radius.circular(30)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: w,
            height: h * 0.3,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(topRight: Radius.circular(30)),
              color: Colors.transparent,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: w * 0.15,
                  backgroundColor: AppColors.buttonColors,
                  backgroundImage: authW.userData!['ProfileImage'] != ''
                      ? NetworkImage(authW.userData!['ProfileImage'])
                      : null,
                  child: authW.userData!['ProfileImage'] == ''
                      ? Icon(Icons.person_rounded,
                          size: w * 0.2, color: Colors.white)
                      : null,
                ),
                SizedBox(height: h * 0.02),
                apptext(
                  myText:
                      "${authW.userData!['firstName']} ${authW.userData!['lastName']}",
                  size: 24,
                  isBold: true,
                  textColor: Colors.white, // Make it stand out
                ),
                SizedBox(height: h * 0.01),
                apptext(
                  myText: authW.userData!['shopName'] ?? "Shop Name",
                  size: 18,
                  textColor: Colors.white70, // Lighter color for subtext
                ),
              ],
            ),
          ),
          SizedBox(height: h * 0.02),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                drawerIcons(
                    firstName: "Gmail:", lastName: authW.userData!['email']),
                drawerIcons(
                    firstName: "Phone Number:",
                    lastName: authW.userData!['phoneNumber']),
              ],
            ),
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: SizedBox(
              height: h * 0.06,
              child: appbutton(
                buttonText: "Log Out",
                bottonColor: AppColors.buttonColors,
                onTap: () {
                  showAdaptiveDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return PopUpforall(
                        popupname: "Logout",
                        popudescription: "Are you sure you want to logout?",
                        popuicon: Icons.logout,
                        ontaps: () async {
                          await authW.removeDeviceTokenOnLogout(
                              collection: "Owner");
                          await FirebaseAuth.instance.signOut();
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginScreen()),
                            (route) => false,
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//=================================================
Widget drawerIcons({
  required String firstName,
  required String lastName,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      apptext(
        myText: firstName,
        size: 14,
        isBold: true,
        textColor: Color.fromARGB(228, 204, 208, 203),
      ),
      apptext(
        myText: lastName,
        size: 18,
      ),
      const Divider(
          color:
              Color.fromARGB(255, 53, 48, 48)), // Lighter divider for subtlety
    ],
  );
}
