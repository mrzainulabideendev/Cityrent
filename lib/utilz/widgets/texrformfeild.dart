import 'package:car_rent/utilz/contants/export.dart';

Widget textformfeild({
  required String hint,
  bool isPassword = false,
  Color borderColor = Colors.transparent,
  Color backcolour = Colors.white, // Default background color
  TextAlign textAlign = TextAlign.center, // Default text alignment
  TextEditingController? myController,
  String? Function(String?)? validation,
  int maxline = 1, // Default to 1 line
  double borderRadius = 30.0,
  String? prefixTexts,
  TextInputType? textInputType, // Fix type declaration
  erorcolour = Colors.white,
  maxLengths,
}) {
  return TextFormField(
    maxLength: maxLengths,
    keyboardType: textInputType,
    maxLines: isPassword ? 1 : maxline, // If password, maxLines is 1
    validator: validation,
    controller: myController,
    obscureText: isPassword,
    style: const TextStyle(fontFamily: "Poppins"),
    textAlign: textAlign,
    decoration: InputDecoration(
      suffixIcon: prefixTexts != null
          ? TextButton(
              onPressed: () {},
              child: Text(
                prefixTexts,
                style: const TextStyle(fontSize: 20),
              ),
            )
          : null,
      fillColor: backcolour,
      filled: true,
      hintText: hint,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: BorderSide(color: borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: BorderSide(color: borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: BorderSide(color: borderColor),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: BorderSide(color: borderColor),
      ),
      errorStyle: TextStyle(
        color: erorcolour, // Set validator text color to white
        fontSize: 14,
      ),
       counterText: '', 
    ),
  );
}
