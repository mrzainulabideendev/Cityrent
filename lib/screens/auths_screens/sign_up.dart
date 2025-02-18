import 'package:car_rent/utilz/contants/export.dart';

class Signupscreen extends StatefulWidget {
  const Signupscreen({super.key});

  @override
  State<Signupscreen> createState() => _SignupscreenState();
}

class _SignupscreenState extends State<Signupscreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController firstnameController = TextEditingController();
  TextEditingController confrimController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  String? _selectedRole; // State variable to hold the selected value

  final formkey = GlobalKey<FormState>();

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
                padding: EdgeInsets.symmetric(horizontal: w * 0.05),
                width: w,
                height: h,
                color: AppColors.primaryColors.withOpacity(0.7),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Column(
                        children: [
                          SizedBox(
                            height: h * 0.04,
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
                            height: h * 0.05,
                          ),
                          SingleChildScrollView(
                            child: Form(
                              key: formkey,
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: w * 0.43,
                                        child: textformfeild(
                                          hint: "First Name",
                                          myController: firstnameController,
                                          validation: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return "Required";
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                      const Spacer(),
                                      SizedBox(
                                        width: w * 0.43,
                                        child: textformfeild(
                                          hint: "Last Name",
                                          myController: lastnameController,
                                          validation: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return "Required";
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  //==================================================================================================

                                  SizedBox(
                                    height: h * 0.03,
                                  ),
                                  textformfeild(
                                    hint: "Email",
                                    myController: emailController,
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
                                  ),
                                  SizedBox(
                                    height: h * 0.03,
                                  ),
                                  //============================================  phonenumber======================================================

                                  phonenumber(
                                    myController:
                                        phoneController, // Ensure you define this controller
                                    validation: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Required";
                                      }

                                      // Remove spaces and non-numeric characters
                                      String phoneNumber =
                                          value.replaceAll(RegExp(r'\D'), '');

                                      // Check if the length of the phone number is between 10 and 15 digits (depending on international format)
                                      if (phoneNumber.length < 10 ||
                                          phoneNumber.length > 15) {
                                        return "Invalid phone number";
                                      }

                                      return null;
                                    },
                                  ),
                                  //============================================  phonenumber======================================================

                                  SizedBox(
                                    height: h * 0.003,
                                  ),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: w * 0.43,
                                        child: textformfeild(
                                          hint: "Password",
                                          isPassword: true,
                                          myController: passwordController,
                                          validation: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return "Required";
                                            }
                                            if (value.length < 6) {
                                              return "password is too small";
                                            }
                                            if (!RegExp(r'^[A-Z]')
                                                .hasMatch(value)) {
                                              return "Password must start with a capital letter";
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                      Spacer(),
                                      SizedBox(
                                        width: w * 0.43,
                                        child: textformfeild(
                                          hint: "Confirm Password",
                                          myController: confrimController,
                                          isPassword: true,
                                          validation: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return "Required";
                                            }

                                            if (value !=
                                                passwordController.text) {
                                              return "Passwords do not match";
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  //============================================  Password======================================================

                                  SizedBox(
                                    height: h * 0.03,
                                  ),
                                  //==================================================
                                  DropdownButtonFormField<String>(
                                    borderRadius: BorderRadius.circular(25),
                                    //  itemHeight: 5,

                                    value:
                                        _selectedRole, // Bind the state variable
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please select a role'; // Display required error message
                                      }
                                      return null;
                                    },

                                    decoration: InputDecoration(
                                      errorStyle: const TextStyle(
                                        color: Colors
                                            .white, // Set validator text color to white
                                        fontSize: 14,
                                      ),
                                      filled: true,
                                      fillColor: AppColors.textcolour,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                    ),
                                    hint:
                                        Text("User and Owner"), // Display hint
                                    items: <String>['User', 'Owner']
                                        .map((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        _selectedRole =
                                            newValue; // Update the state variable
                                      });
                                    },
                                  ),

                                  //=============================================================
                                  SizedBox(
                                    height: h * 0.03,
                                  ),
                                  SizedBox(
                                    height: h * 0.07,
                                    child: appbutton(
                                      buttonText: "SIGN UP",
                                      onTap: () async {
                                        if (formkey.currentState!.validate()) {
                                          // Check if the phone number is empty
                                          if (phoneController.text.isNotEmpty) {
                                            authsRead.isLoading =
                                                true; // Set loading state true

                                            if (_selectedRole == 'Owner') {
                                              Navigator.push(
                                                context,
                                                PageRouteBuilder(
                                                  pageBuilder: (context,
                                                          animation,
                                                          secondaryAnimation) =>
                                                      Ownermoredata(
                                                    email: emailController.text,
                                                    firstName:
                                                        firstnameController
                                                            .text,
                                                    lastname:
                                                        lastnameController.text,
                                                    password:
                                                        passwordController.text,
                                                    phoneNumber:
                                                        phoneController.text,
                                                    role: _selectedRole!,
                                                  ),
                                                ),
                                              );
                                            } else if (_selectedRole ==
                                                'User') {
                                              bool res =
                                                  await authsRead.signUpUser(
                                                context: context,
                                                email: emailController.text,
                                                firstName:
                                                    firstnameController.text,
                                                lastName:
                                                    lastnameController.text,
                                                password:
                                                    passwordController.text,
                                                phoneNumber:
                                                    phoneController.text,
                                                role:
                                                    _selectedRole!, // Pass the selected role
                                              );
                                              emailController.clear();
                                              firstnameController.clear();

                                              lastnameController.clear();

                                              passwordController.clear();

                                              phoneController.clear();
                                              confrimController.clear();

                                              if (res) {
                                                 await FirebaseAuth.instance.signOut();
                                                showDialog(
                                                  context: context,
                                                  builder: (context) =>
                                                      signuppopup(),
                                                );
                                              }
                                            }
                                            authsRead.isLoading =
                                                false; // Set loading state false
                                          } else {
                                            // Show SnackBar if the phone number is empty
                                            snaki(
                                              context: context,
                                              isErrorColor: true,
                                              msg:
                                                  "Please type Your Phone Number",
                                            );
                                          }
                                        }
                                      },
                                    ),
                                  ),

                                  SizedBox(
                                    height: h * 0.01,
                                  ),
                                  apptext(
                                    myText: "I Have Already Account?",
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
                                        buttonText: "LOGIN",
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  LoginScreen(),
                                            ),
                                          );
                                        }),
                                  ),
                                  SizedBox(
                                    height: h * 0.03,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            authsWatch.isLoading ? loadingforall(): const SizedBox()
          ],
        ),
      ),
    );
  }
}
//================================== More data get For owner ==================
