import 'package:car_rent/utilz/contants/export.dart';

class YourProfilescreen extends StatefulWidget {
  final bool isOwner;
  const YourProfilescreen({super.key, this.isOwner = true});

  @override
  State<YourProfilescreen> createState() => _YourProfilescreenState();
}
class _YourProfilescreenState extends State<YourProfilescreen> {
  TextEditingController shopnameController = TextEditingController();
  TextEditingController shopdecController = TextEditingController();
  TextEditingController firstnameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  final formkey = GlobalKey<FormState>();
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
  
    if (!_isInitialized) {
      final authControoller = context.watch<Authencationcontroller>();
      shopnameController =
          TextEditingController(text: authControoller.userData!["shopName"]);
      shopdecController = TextEditingController(
          text: authControoller.userData!["shopDescription"]);
      firstnameController =
          TextEditingController(text: authControoller.userData!["firstName"]);
      lastnameController =
          TextEditingController(text: authControoller.userData!["lastName"]);
      phoneController =
          TextEditingController(text: authControoller.userData!["phoneNumber"]);
      
      _isInitialized = true;
    }
  }


  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    final authsRead = context.read<Authencationcontroller>();

    return SafeArea(
      child: Scaffold(
        body: Container(
          color: AppColors.textcolour,
          width: w,
          height: h,
          padding: EdgeInsets.symmetric(
            horizontal: w * 0.04,
          ),
          child: SingleChildScrollView(
            child: Form(
              key: formkey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: h * 0.03,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(Icons.arrow_back_ios_new),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      apptext(
                        myText: "Your Profile",
                        size: 30,
                        isBold: true,
                      ),
                    ],
                  ),

                  boxforyourprofile(
                      boxname: "First Name",
                      inerboxname: "First Name",
                      validation: (value) {
                        if (value == null || value.isEmpty) {
                          return "Required";
                        }
                        return null;
                      },
                      myController: firstnameController),
                  boxforyourprofile(
                      boxname: "Last Name",
                      validation: (value) {
                        if (value == null || value.isEmpty) {
                          return "Required";
                        }
                        return null;
                      },
                      inerboxname: "Last Name",
                      myController: lastnameController),
                  boxforyourprofile(
                      boxname: "Phone Number",
                      validation: (value) {
                        if (value == null || value.isEmpty) {
                          return "Required";
                        }
                        return null;
                      },
                      inerboxname: "Phone Number",
                      myController: phoneController),

                  // Check if the user is an owner
                  if (widget.isOwner) ...[
                    boxforyourprofile(
                        boxname: "Shop Name",
                        inerboxname: "Shop Name",
                        validation: (value) {
                          if (value == null || value.isEmpty) {
                            return "Required";
                          }
                          return null;
                        },
                        myController: shopnameController),
                    boxforyourprofile(
                        boxname: "Shop Description",
                        validation: (value) {
                          if (value == null || value.isEmpty) {
                            return "Required";
                          }
                          return null;
                        },
                        inerboxname: "Shop Description",
                        maxline: 6,
                        myController: shopdecController),
                  ],

                  SizedBox(height: h * 0.02),

                  SizedBox(
                    width: w,
                    height: h * 0.08,
                    child: appbutton(
                        buttonText: "Update Profile",
                        onTap: () async {
                          if (formkey.currentState!.validate()) {
                            if (widget.isOwner) {
                              bool res = await authsRead.changeOnwerprofile(
                                  firstName: firstnameController.text,
                                  lastName: lastnameController.text,
                                  phoneNumber: phoneController.text,
                                  shopDescription: shopdecController.text,
                                  shopName: shopnameController.text);
                              if (res) {
                                await authsRead.getUserRole(
                                    FirebaseAuth.instance.currentUser!.uid);
                                Navigator.pop(context);
                                snaki(
                                    context: context,
                                    msg: "Successfully Change Your Profile");
                              }
                            } else {
                              bool res = await authsRead.changeUserprofile(
                                firstName: firstnameController.text,
                                lastName: lastnameController.text,
                                phoneNumber: phoneController.text,
                              );
                              if (res) {
                                await authsRead.getUserRole(
                                    FirebaseAuth.instance.currentUser!.uid);
                                Navigator.pop(context);
                                snaki(
                                    context: context,
                                    msg: "Successfully Change Your Profile");
                              }
                            }
                          }
                        }),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

//=========================================================================== Box=====================

Widget boxforyourprofile(
    {required String boxname,
    required String inerboxname,
    String? prefixTextss,
    String? Function(String?)? validation,
    TextEditingController? myController,
    int maxline = 1}) {
  return Builder(builder: (context) {
    final h = MediaQuery.of(context).size.height;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        apptext(myText: boxname, size: 13),
        SizedBox(height: h * 0.01),
        textformfeild(
            hint: inerboxname,
            erorcolour: Colors.red,
            backcolour: Colors.grey.withOpacity(0.2),
            borderRadius: 10,
            prefixTexts: prefixTextss,
            validation: validation,
            myController: myController,
            maxline: maxline,
            textAlign: TextAlign.start),
      ],
    );
  });
}
