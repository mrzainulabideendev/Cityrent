import 'package:car_rent/utilz/contants/export.dart';

class Ownermoredata extends StatefulWidget {
  final String firstName;
  final String lastname;
  final String email;
  final String password;
  final String phoneNumber;
  final String role;

  const Ownermoredata(
      {super.key,
      required this.firstName,
      required this.lastname,
      required this.email,
      required this.password,
      required this.phoneNumber,
      required this.role});

  @override
  State<Ownermoredata> createState() => _OwnermoredataState();
}

class _OwnermoredataState extends State<Ownermoredata> {
  XFile? _images;
  final ImagePicker _picker = ImagePicker();

  Future<void> pickImage({required ImageSource source}) async {
    _images = await _picker.pickImage(source: source);
    setState(() {});
  }

  TextEditingController Shop_name_Controller = TextEditingController();
  final formkey = GlobalKey<FormState>();

  TextEditingController ShopDescriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        // appBar: AppBar(
        //   backgroundColor: AppColors.primaryColors.withOpacity(0.7),
        //   leading: IconButton(
        //     onPressed: () {
        //       Navigator.pop(
        //           context); // Pop the current screen from the navigation stack
        //     },
        //     icon: const Icon(
        //       Icons.arrow_back,
        //       color: AppColors
        //           .textcolour, // Make sure `AppColors.textcolour` is defined somewhere
        //       size: 35,
        //     ),
        //   ),
        // ),
        body: 
        
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(ImageApp.backgroundimage),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: w * 0.05),
            width: w,
            height: h,
            color: AppColors.primaryColors.withOpacity(0.7),
            child: SingleChildScrollView(
              child: Form(
                key: formkey,
                child: Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(
                              Icons.arrow_back,
                              color: AppColors.textcolour,
                              size: 35,
                            )),
                      ],
                    ),
                 
                    Center(
                      child: SizedBox(
                          height: h * 0.15,
                          width: w * 0.35,
                          child: Image.asset(IconsApp.appIcons)),
                    ),
                    apptext(
                        myText: "CityRent",
                        size: 40,
                        isBold: true,
                        textColor: AppColors.textcolour),
                    SizedBox(
                      height: h * 0.03,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        apptext(
                            myText: "Shop Photo",
                            size: 15,
                            isBold: true,
                            textColor: AppColors.textcolour),
                        SizedBox(
                          height: h * 0.01,
                        ),
                        GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (context) => imagePiuckerWidget(),
                            );
                          },
                          child: Container(
                            height: h * 0.17,
                            width: w,
                            decoration: BoxDecoration(
                              color: AppColors.textformcolour,
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: _images != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(25),
                                    child: Image.file(
                                      File(_images!.path),
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : const Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.add,
                                          color: Colors.blue, size: 30),
                                      SizedBox(height: 8),
                                      Text(
                                        'Please select an image',
                                        style: TextStyle(
                                            color: Colors.blue, fontSize: 16),
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                        SizedBox(
                          height: h * 0.01,
                        ),
                        apptext(
                            myText: "Shop Name",
                            size: 15,
                            isBold: true,
                            textColor: AppColors.textcolour),
                        SizedBox(
                          height: h * 0.01,
                        ),
                        textformfeild(
                          hint: "Shop Name",
                          myController: Shop_name_Controller,
                          validation: (value) {
                            if (value == null || value.isEmpty) {
                              return "Required";
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: h * 0.01,
                        ),
                        apptext(
                            myText: "Shop Description ",
                            size: 15,
                            isBold: true,
                            textColor: AppColors.textcolour),
                        SizedBox(
                          height: h * 0.01,
                        ),
                        textformfeild(
                            hint: "Shop Description",
                            myController: ShopDescriptionController,
                            validation: (value) {
                              if (value == null || value.isEmpty) {
                                return "Required";
                              }
                              return null;
                            },
                            textAlign: TextAlign.start,
                            maxline: 6),
                        SizedBox(
                          height: h * 0.01,
                        ),
                        SizedBox(
                            height: h * 0.08,
                            child: appbutton(
                                buttonText: "Next",
                                onTap: () {
                                  if (formkey.currentState!.validate()) {
                                    if (_images != null) {
                                      Navigator.pushAndRemoveUntil(
                                        context,
                                        PageRouteBuilder(
                                          pageBuilder: (context, animation,
                                                  secondaryAnimation) =>
                                              NewPlacePicker(
                                            email: widget.email,
                                            shopDescription:
                                                ShopDescriptionController.text,
                                            firstName: widget.firstName,
                                            lastname: widget.lastname,
                                            password: widget.password,
                                            phoneNumber: widget.phoneNumber,
                                            role: widget.role,
                                            shopname: Shop_name_Controller.text,
                                            shopimage: _images,
                                            ownerediti: false,
                                          ),
                                        ),
                                        (Route<dynamic> route) => false,
                                      );
                                    } else {
                                      snaki(
                                          context: context,
                                          msg: "Pick Shop Image",
                                          isErrorColor: true);
                                    }
                                  }
                                })),
                        SizedBox(
                          height: h * 0.05,
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
        
       
      ),
    );
  }

  //////////////////////////////////////// image picker==============================

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
