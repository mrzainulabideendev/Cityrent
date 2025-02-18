import 'package:car_rent/utilz/contants/export.dart';

Widget appbutton({
  required String buttonText,
  required onTap,
  IconData? icon, 
  Color? iconcolour =const Color.fromARGB(255, 185, 39, 39),
  
  bottonColor = AppColors.buttonColors,
  splashColor = Colors.white,
}) {
  return Builder(builder: (context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: bottonColor,
        borderRadius: BorderRadius.circular(30),
        boxShadow: const [
          BoxShadow(
            color: AppColors.textcolour, // Inner shadow color
          ),
        ],
      ),
      child: Material(
        color: bottonColor,
        child: InkWell(
          splashColor: splashColor,
          onTap: onTap,
          child: Center(
            child: Row( 
              mainAxisSize: MainAxisSize.min, 
              children: [
                if (icon != null) ...[
                  Icon(icon, color: iconcolour, size:20), // Display icon if provided
                  const SizedBox(width: 8), // Add space between icon and text
                ],
                apptext(
                  myText: buttonText,
                  isBold: true,
                  size: 15,
                  textColor: AppColors.textcolour,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  });
}
