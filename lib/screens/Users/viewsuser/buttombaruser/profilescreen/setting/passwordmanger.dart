import 'package:car_rent/utilz/contants/export.dart';

// ignore: camel_case_types
class passwordmangerscreen extends StatefulWidget {
  const passwordmangerscreen({super.key});

  @override
  State<passwordmangerscreen> createState() => _passwordmangerscreenState();
}

class _passwordmangerscreenState extends State<passwordmangerscreen> {
  TextEditingController cnonfrimpassword = TextEditingController();
  TextEditingController oldpasswordController = TextEditingController();
  TextEditingController newpasswordController = TextEditingController();
  final formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    final authsRead = context.read<Authencationcontroller>();
    final authWatch = context.watch<Authencationcontroller>();

    return Scaffold(
      body: Container(
        color: AppColors.textcolour,
        width: w,
        height: h,
        padding: EdgeInsets.symmetric(horizontal: w * 0.05, vertical: h * 0.06),
        child: Form(
          key: formkey,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                  myText: "Password Manger",
                  size: 30,
                  isBold: true,
                ),
              ],
            ),
            SizedBox(height: h * 0.06),
            textformfeild(
                hint: "Old Password",
                erorcolour: Colors.black38,
                isPassword: true,
                myController: oldpasswordController,
                validation: (value) {
                  if (value == null || value.isEmpty) {
                    return "Required";
                  }
                  if (value.length < 6) {
                    return "password is too small";
                  }
                  if (!RegExp(r'^[A-Z]').hasMatch(value)) {
                    return "Password must start with a capital letter";
                  }
                  return null;
                },
                borderColor: AppColors.buttonColors,
                backcolour: AppColors.textformcolour),
            SizedBox(height: h * 0.03),
            textformfeild(
                hint: "New Password",
                erorcolour: Colors.black38,
                isPassword: true,
                myController: newpasswordController,
                validation: (value) {
                  if (value == null || value.isEmpty) {
                    return "Required";
                  }
                  if (value.length < 6) {
                    return "password is too small";
                  }
                  if (!RegExp(r'^[A-Z]').hasMatch(value)) {
                    return "Password must start with a capital letter";
                  }
                  return null;
                },
                borderColor: AppColors.buttonColors,
                backcolour: AppColors.textformcolour),
            SizedBox(height: h * 0.03),
            textformfeild(
                hint: "confrim Password",
                myController: cnonfrimpassword,
                erorcolour: Colors.black38,
                isPassword: true,
                validation: (value) {
                  if (value == null || value.isEmpty) {
                    return "Required";
                  }

                  if (value != newpasswordController.text) {
                    return "Passwords do not match";
                  }
                  return null;
                },
                borderColor: AppColors.buttonColors,
                backcolour: AppColors.textformcolour),
            SizedBox(height: h * 0.02),
            SizedBox(
                width: w,
                height: h * 0.08,
                child: appbutton(
                    buttonText: "Change Password",
                    onTap: () async {
                      if (formkey.currentState!.validate()) {
                        await authsRead.changePasswordoldpassword(
                          context: context,
                          currentPassword: oldpasswordController.text,
                          email: authWatch.userData!['email'],
                          newPassword: newpasswordController.text,
                        );
                      }
                    }
                    
                    
                    ))
          ]),
        ),
      ),
    );
  }
}
