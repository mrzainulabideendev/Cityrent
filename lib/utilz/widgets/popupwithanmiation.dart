import 'package:car_rent/utilz/contants/export.dart';
import 'package:lottie/lottie.dart';

Widget signuppopup() {
  return Builder(builder: (context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return Dialog(
      child: Container(
        height: h * 0.36,
        width: w,
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: AppColors.textcolour,
        ),
        child: Column(
          children: [
            SizedBox(
                height: h * 0.15,
                child: Lottie.asset(Appanimation.yesanimation)),
            SizedBox(
              height: h * 0.02,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                apptext(
                    myText:
                        "Your signup was successful. Please verify your email and log in again.",
                    TextAlign: TextAlign.center,
                    size: 15),
                SizedBox(
                  height: h * 0.02,
                ),
                SizedBox(
                  width: w * 0.4,
                  height: h * 0.07,
                  child: appbutton(
                      buttonText: "Login",
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    LoginScreen(),
                          ),
                          (Route<dynamic> route) => false,
                        );
                      }),
                )
              ],
            )
          ],
        ),
      ),
    );
  });
}

//===================================================================Car-popup===========================


Widget newcarpoup({
  required String lottie,  // Lottie file path or asset name
  required String text,    // Text to display
  required bool isbooing,  // Whether to show button or not
  String? buttonText,      // Button text, optional
  VoidCallback? onTap,     // Button action callback, optional
}) {
  return Builder(
    builder: (context) {
      final h = MediaQuery.of(context).size.height;
      final w = MediaQuery.of(context).size.width;
      return Dialog(
        child: Container(
          height: h * 0.45,
          width: w,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: AppColors.textcolour,
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context); // Close dialog on tap
                    },
                    child: const Icon(
                      Icons.close,
                      size: 30,
                    ),
                  ),
                ],
              ),
              Container(
                height: h * 0.25,
                child: Lottie.asset(lottie), // Lottie animation
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  apptext(
                    myText: text,
                    TextAlign: TextAlign.center,
                    size: 15,
                    isBold: true,
                  ),
                  
                  if (isbooing && buttonText != null && onTap != null) ...[
                    SizedBox(height: h * 0.01,),
                    SizedBox(
                      height:  h* 0.05,
                      child: appbutton(
                        buttonText: buttonText,
                        onTap: onTap,
                      ),
                    ),
                  ]
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

///////////////////////////////////////////////////
