import 'package:car_rent/utilz/contants/export.dart';
import 'package:lottie/lottie.dart';

Widget loadingforall() {
  return Builder(builder: (context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    return Container(
      // You need to return this Container
      height: h,
      width: w,
      color: Colors.black54, // Optional: Semi-transparent background
      child: Center(
          child: Container(
              decoration: BoxDecoration(
                  color: AppColors.textcolour,
                  borderRadius: BorderRadius.circular(25)),
              height: h * 0.2,
              width: w * 0.6,
              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.center, // Center the content
                children: [
                  SizedBox(
                      height: h * 0.15,
                      child: Lottie.asset(Appanimation.loadinganimation)),
                  apptext(
                      myText: "please wait ........",
                      isBold: true,
                      size: 15,
                      textColor: AppColors.buttonColors)
                ],
              ))),
    );
  });
}
