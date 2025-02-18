import 'package:car_rent/utilz/contants/export.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final double h = MediaQuery.of(context).size.height;
    final double w = MediaQuery.of(context).size.width;
    final authsRead = context.read<Authencationcontroller>();
    final authsWatch = context.watch<Authencationcontroller>();

    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(ImageApp.backgroundimage),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: w * 0.1),
                width: w,
                height: h,
                color: AppColors.primaryColors.withOpacity(0.7),
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        SizedBox(height: h * 0.05),
                        SizedBox(
                          height: h * 0.2,
                          width: w * 0.4,
                          child: Image.asset(IconsApp.appIcons),
                        ),
                        apptext(
                          myText: "CityRent",
                          size: 40,
                          isBold: true,
                          textColor: AppColors.textcolour,
                        ),
                        SizedBox(height: h * 0.1),
                        textformfeild(
                          hint: "Email",
                          myController: emailController,
                          validation: (value) {
                            if (value == null || value.isEmpty) {
                              return "Required";
                            }
                            final bool emailValid = RegExp(
                                    r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
                                .hasMatch(value);
                            if (!emailValid) {
                              return "Invalid email";
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: h * 0.01),
                        textformfeild(
                          hint: "Password",
                          isPassword: true,
                          myController: passwordController,
                          validation: (value) {
                            if (value == null || value.isEmpty) {
                              return "Required";
                            }
                            if (value.length < 6) {
                              return "Password is too short";
                            }
                            if (!RegExp(r'^[A-Z]').hasMatch(value)) {
                              return "Capital letter";
                            }
                            return null;
                          },
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ForgotPassword(),
                              ),
                            );
                          },
                          child: apptext(
                            myText: "Forgot Password",
                            size: 15,
                            textColor: AppColors.textcolour,
                          ),
                        ),
                        SizedBox(height: h * 0.01),
                        ////////////////////////////////Login//////////////////////////////////////////////////
                        SizedBox(
                          height: h * 0.055,
                          child: appbutton(
                            buttonText: "Login",
                            onTap: () async {
                              if (formKey.currentState!.validate()) {
                                authsRead.isLoading = true;
                                var result = await authsRead.authslogin(
                                  myemail: emailController.text,
                                  mypass: passwordController.text,
                                  context: context,
                                );
                                emailController.clear();
                                passwordController.clear();

                                if (result is String && result.isNotEmpty) {
                              
                                  String role = result;

                                  Widget destination;
                                  if (role == "Owner") {
                                    destination = const MyBottomBarOwner();
                                  } else {
                                    destination = const Mybuttombaruser();
                                  }

                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => destination),
                                    (route) => false,
                                  );
                                  authsRead.isLoading = false;
                                } else {
                                  print("Login failed or email not verified");
                                }
                              }
                            },
                          ),
                        ),

                        ////////////////////////////////Login//////////////////////////////////////////////////

                        SizedBox(
                          height: h * 0.01,
                        ),
                        apptext(
                          myText: "Don't Have An Account?",
                          size: 16,
                          textColor: AppColors.textcolour,
                        ),
                        SizedBox(
                          height: h * 0.01,
                        ),

                        SizedBox(
                          height: h * 0.055,
                          width: w * 0.3,
                          child: appbutton(
                              bottonColor: Colors.red,
                              buttonText: "SIGN UP",
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const Signupscreen(),
                                  ),
                                );
                              }),
                        ),
                        SizedBox(
                          height: h * 0.03,
                        ),

                        // TextButton(
                        //   onPressed: () {
                        //     // Navigator.push(
                        //     //   context,
                        //     //   MaterialPageRoute(
                        //     //     builder: (context) => Signupscreen(),
                        //     //   ),
                        //     // );
                        //   },
                        //   child: apptext(
                        //     myText: "SIGN UP",
                        //     size: 15,
                        //     textColor: AppColors.textcolour,
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            authsWatch.isLoading ? loadingforall() : const SizedBox()
          ],
        ),
      ),
    );
  }
}
