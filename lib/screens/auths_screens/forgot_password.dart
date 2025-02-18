import 'package:car_rent/utilz/contants/export.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final formkey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
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
                padding: EdgeInsets.symmetric(horizontal: w * 0.02),
                width: w,
                height: h,
                color: AppColors.primaryColors.withOpacity(0.7),
                child: SingleChildScrollView(
                  child: Form(
                    key: formkey,
                    child: Column(
                      children: [
                       
                        Row(
                          // mainAxisAlignment: MainAxisAlignment.end,

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
                        SizedBox(
                          height: h * 0.03,
                        ),
                        Center(
                          child: SizedBox(
                              height: h * 0.2,
                              width: w * 0.4,
                              child: Image.asset(IconsApp.appIcons)),
                        ),
                        apptext(
                            myText: "CityRent",
                            size: 40,
                            isBold: true,
                            textColor: AppColors.textcolour),
                        SizedBox(
                          height: h * 0.04,
                        ),
                        apptext(
                            myText: "Forget Password",
                            size: 20,
                            textColor: AppColors.textcolour),
                        SizedBox(
                          height: h * 0.03,
                        ),
                        textformfeild(
                          hint: "Email",
                          validation: (value) {
                            if (value == null || value.isEmpty) {
                              return "Required";
                            }
                            final bool emailValid = RegExp(
                                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                .hasMatch(value);
                            if (emailValid == false) {
                              return "invalid email";
                            }
                            return null;
                          },
                          myController: emailController,
                        ),
                        SizedBox(
                          height: h * 0.03,
                        ),
                        SizedBox(
                          height: h * 0.07,
                          width:  w * 0.7,
                          child: appbutton(
                            buttonText: "Forget Password",
                            onTap: () async {
                              if (formkey.currentState!.validate()) {
                                // Set loading state to true before the async operation
                                authsRead.isLoading = true;

                                // Call the forget password method
                                await authsRead.forgetPassword(
                                  email: emailController.text,
                                  context: context,
                                );

                                // Reset loading state after the operation
                                authsRead.isLoading = false;
                              }
                            },
                          ),
                        )
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
