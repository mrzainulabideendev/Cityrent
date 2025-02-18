import 'package:car_rent/utilz/contants/export.dart';

void showVerificationDialog(BuildContext context, User user) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Email not verified"),
        content: Text(
            "Please verify your email to continue. Do you want to resend the verification email?"),
        actions: [
          TextButton(
            onPressed: () async {
              await user.sendEmailVerification();
              Navigator.of(context).pop(); // Close the dialog
              var snackbar = SnackBar(
                content: apptext(
                    myText: "Verification email sent", textColor: Colors.white),
                duration: Duration(seconds: 2),
                backgroundColor: Colors.green,
              );
              ScaffoldMessenger.of(context).showSnackBar(snackbar);
            },
            child: Text("Resend Email"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog without resending
            },
            child: Text("Cancel"),
          ),
        ],
      );
    },
  );
}
