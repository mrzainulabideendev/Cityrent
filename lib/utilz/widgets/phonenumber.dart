import 'package:car_rent/utilz/contants/export.dart';

Widget phonenumber({
  required TextEditingController myController,
  required Function(String?) validation,
}) {
  return IntlPhoneField(
    controller: myController,
    decoration: InputDecoration(
      filled: true,
      fillColor: AppColors.textcolour,
      hintText: 'Phone Number',
      hintStyle: TextStyle(color: AppColors.buttonColors), // Set hint text color to white
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25),
        borderSide: BorderSide(color: Colors.white), // Set border color to white
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25),
        borderSide: BorderSide(color: Colors.white), // Set focused border color to white
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25),
      ),
    ),
    initialCountryCode: 'US', // Default country code
    onChanged: (phone) {
      validation(phone.completeNumber);
    },
    style: TextStyle(color: AppColors.buttonColors), // Set input text color
  );
}
