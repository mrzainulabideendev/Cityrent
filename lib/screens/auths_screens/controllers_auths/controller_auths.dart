import 'package:car_rent/screens/auths_screens/verfiy_email.dart';
import 'package:car_rent/utilz/contants/export.dart';

class Authencationcontroller extends ChangeNotifier {
  bool isLoading = false;

  Future<bool> signUpUser({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String phoneNumber,
    required BuildContext context,
    required String role, // Role parameter
    String? shopName, // Optional parameters
    String? shopDescription,
    latitude,
    shopimage,
    longitude, // Longitude for location
  }) async {
    isLoading = true;
    notifyListeners();
    try {
      bool isAuthssingupcompelet =
          await authssignup(context: context, myemail: email, mypass: password);
      if (isAuthssingupcompelet) {
        await verifyEmail(context: context);
        await firebasedatasave(
            role: role,
            email: email,
            fName: firstName,
            context: context,
            lName: lastName,
            password: password,
            phoneNumber: phoneNumber,
            shopDescription: shopDescription,
            shopName: shopName,
            shoplatitude: latitude,
            shopimage: shopimage,
            shoplongitude: longitude);
        isLoading = false;
        notifyListeners();

        return true;
      } else {
        isLoading = false;
        notifyListeners();
        return false;
      }
    } on FirebaseAuthException catch (e) {
      print(e.code);

      isLoading = false;
      notifyListeners();

      return false;
    }
  }

  //==============================Sign Up=======================================

  Future<bool> authssignup({
    required String myemail,
    required String mypass,
    required context,
  }) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: myemail,
        password: mypass,
      );
      return true;
    } on FirebaseAuthException catch (e) {
      print(e.code);
      var snackbar = SnackBar(
        content: apptext(myText: e.code, textColor: Colors.white),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
      return false;
    }
  }

  //-------------------------------------- fire base data save -------------------------------------------------------
  Future<bool> firebasedatasave({
    required String fName,
    required String lName,
    required String email,
    required BuildContext context,
    required String phoneNumber,
    required String password,
    required String role, // Add role parameter
    String? shopName, // Optional parameters for owner
    String? shopDescription,
    shoplatitude,
    shoplongitude,
    shopimage, // Only for owner
  }) async {
    try {
      String userid = FirebaseAuth.instance.currentUser!.uid;
      String? imageDownload;

      // Only process the image if the role is 'Owner' and shopimage is provided
      if (role == 'Owner' && shopimage != null) {
        if (shopimage is String) {
          imageDownload = shopimage; // If already a URL
        } else {
          var file = File(shopimage!.path);
          String fileName = "${DateTime.now()}.jpg";
          var isUploaded = await FirebaseStorage.instance
              .ref("ShopPics")
              .child(fileName)
              .putFile(file)
              .whenComplete(() => debugPrint("Image uploaded."));
          imageDownload = await isUploaded.ref.getDownloadURL();
          print("Image uploaded: $imageDownload");
        }
      }

      // Save data in role-specific folder (either 'Owner' or 'Booker')
      final users = FirebaseFirestore.instance
          .collection(role == 'Owner' ? "Owner" : "Booker");

      // Prepare user data to save
      Map<String, dynamic> userData = {
        "firstName": fName,
        "role": role,
        "lastName": lName,
        "email": email,
        "phoneNumber": phoneNumber,
                  "Uid": FirebaseAuth.instance.currentUser!.uid,

        "password": password,
        "ProfileImage": "",
        "getDeviceToken": ""
      };

      if (role == 'Owner') {
        userData.addAll({
          "shopName": shopName,

          "shopDescription": shopDescription,
          "shoplatitude": shoplatitude,
          "shoplongitude": shoplongitude,
          "ShopImage": imageDownload, // Add profile image URL if available
        });
      }

      await users.doc(userid).set(userData);
      return true;
    } on FirebaseAuthException catch (e) {
      var snackbar = SnackBar(
        content: apptext(myText: e.code, textColor: Colors.white),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
      return false;
    } catch (e) {
      // Handle other exceptions
      var snackbar = SnackBar(
        content:
            apptext(myText: "An error occurred: $e", textColor: Colors.white),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
      return false;
    }
  }

  //=====================================================  Profile  image =====================================================

  Future<String?> uploadProfileImage(var imagePath, String role) async {
    if (imagePath == null) {
      return null; // No image to upload
    }

    try {
      // Use File to get the image file from the provided path
      var file = File(imagePath);
      String fileName = "${DateTime.now().millisecondsSinceEpoch}.jpg";

      String storagePath =
          role == 'Owner' ? "OwnerProfilePics" : "BookerProfilePics";

      var uploadTask = await FirebaseStorage.instance
          .ref(storagePath)
          .child(fileName)
          .putFile(file);

      String imageDownloadURL = await uploadTask.ref.getDownloadURL();
      print(imageDownloadURL);

      FirebaseFirestore.instance
          .collection(role)
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({"ProfileImage": imageDownloadURL});

      // Map<String, dynamic> userData = {
      //   "ProfileImage": imageDownloadURL,
      // };

      print("Profile image uploaded: $imageDownloadURL");
      return imageDownloadURL;
    } catch (e) {
      print("Error uploading profile image: $e");
      return null;
    }
  }

  //=====================================================  verifry mail =====================================================

  Future verifyEmail({required context}) async {
    try {
      final user = await FirebaseAuth.instance.currentUser;

      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
      }
    } catch (e) {
      print(e);
      var snackbar = SnackBar(
        content: apptext(myText: "Invaild Email", textColor: Colors.white),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.red,
      );

      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    }
  }

//========================================================forgetpassword================================================

  Future<void> forgetPassword(
      {required String email, required BuildContext context}) async {
    // Start loading
    isLoading = true;
    notifyListeners();

    try {
      // Attempt to send the password reset email
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      // Show success message
      snaki(
          context: context,
          msg: "Reset password instruction sent to your email");
    } on FirebaseAuthException catch (e) {
      // Handle specific Firebase exceptions
      switch (e.code) {
        case 'user-not-found':
          snaki(
              context: context,
              msg: "No user found for that email.",
              isErrorColor: true);
          break;
        case 'invalid-email':
          snaki(
              context: context,
              msg: "The email address is not valid.",
              isErrorColor: true);
          break;
        default:
          snaki(
              context: context, msg: "Error: ${e.message}", isErrorColor: true);
      }
    } catch (e) {
      snaki(context: context, msg: "Error: $e", isErrorColor: true);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

//////////////////////////////getUserRole////////////////////////////////////////

  Map<String, dynamic>? userData;
  Future<String?> getUserRole(String userId) async {
    final doc =
        await FirebaseFirestore.instance.collection("Owner").doc(userId).get();
    if (doc.exists) {
      userData = doc.data();
      print(doc.data());
      return "Owner";
    }

    final doc2 =
        await FirebaseFirestore.instance.collection("Booker").doc(userId).get();
    if (doc2.exists) {
      userData = doc2.data();
      print(doc2.data());
      return "Booker";
    }

    return "";
  }
//////////////////////////////authslogin////////////////////////////////////////

  Future<Object?> authslogin({
    required String myemail,
    required String mypass,
    required BuildContext context,
  }) async {
    isLoading = true;
    notifyListeners();
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: myemail, password: mypass);

      final user = userCredential.user;

      if (user != null && !user.emailVerified) {
        showVerificationDialog(context, user);
        isLoading = false;
        notifyListeners();
        return false; // Returning a bool explicitly
      } else {
        String? role = await getUserRole(user!.uid);
        isLoading = false;
        notifyListeners();
        if (role != "") {
          return role;
        } else {
          snaki(context: context, msg: "User not found", isErrorColor: true);
          // Handle case where no role was found
          throw Exception("User role not found");
        }
      }

      // Get user role after verifying email
    } on FirebaseAuthException catch (e) {
      print(e);
      var snackbar = SnackBar(
        content:
            apptext(myText: "Wrong Email or Password", textColor: Colors.white),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.red,
      );

      ScaffoldMessenger.of(context).showSnackBar(snackbar);
      isLoading = false;
      notifyListeners();
      return false; // Return false explicitly on error
    }
  }

//////////////////////////////splash screnn user signin check////////////////////////////////////////
  Map<String, dynamic>? uerData;

  Future<void> checkLoginStatus(BuildContext context) async {
    isLoading = true;
    notifyListeners();

    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        if (!user.emailVerified) {
          await user.sendEmailVerification();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
          );
          return;
        }

        String? role = await getUserRole(user.uid);

        Widget destination;

        if (role == "Owner") {
          destination = const MyBottomBarOwner();
        } else if (role == "Booker") {
          destination = const Mybuttombaruser();
        } else {
          destination = const LoginScreen();
        }

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => destination),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    } catch (e) {
      print("Error checking login status: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<String?> getUserRle(String userId) async {
    final doc =
        await FirebaseFirestore.instance.collection("Owner").doc(userId).get();
    if (doc.exists) {
      userData = doc.data();
      print(doc.data());
      return "Owner";
    }

    final doc2 =
        await FirebaseFirestore.instance.collection("Booker").doc(userId).get();
    if (doc2.exists) {
      userData = doc2.data();
      print(doc2.data());
      return "Booker";
    }

    return null;
  }

  //////////////////////////////Change Paswword ////////////////////////////////////////

  Future changePasswordoldpassword(
      {required String currentPassword,
      required String newPassword,
      required String email,
      required context}) async {
    User? user = FirebaseAuth.instance.currentUser;

    // Reauthenticate the user with their current password
    AuthCredential credential = EmailAuthProvider.credential(
      email: email,
      password: currentPassword,
    );
    isLoading = true;
    notifyListeners();

    try {
      // Reauthenticate the user
      await user!.reauthenticateWithCredential(credential);
      // Change the password
      await user.updatePassword(newPassword);
      snaki(context: context, msg: 'Password changed successfully');
      Navigator.pop(context);
      print('Password changed successfully');
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      print(e.code);
      if (e.code == "invalid-credential") {
        snaki(context: context, msg: 'Wrong password ', isErrorColor: true);
        print('Wrong current password: $e');
      } else {
        snaki(
            context: context,
            msg: 'Error changing password: $e',
            isErrorColor: true);
        print('Error changing password: $e');
      }
    }
    isLoading = false;
    notifyListeners();
  }

  ////////////////////////////// user delet ////////////////////////////////////////
  Future<bool> deleteUser(
      {required BuildContext context, required String password}) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        AuthCredential credential = EmailAuthProvider.credential(
            email: user.email!, password: password);

        // Re-authenticate user
        await user.reauthenticateWithCredential(credential);

        await user.delete();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Account deleted successfully.")),
        );
        return true;
      }
      return false;
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error deleting account: ${e.toString()}")),
      );
      return false;
    }
  }
//------------------------------------------ Change Owner profile--------------------------

  Future<bool> changeOnwerprofile({
    required String firstName,
    required String lastName,
    required String phoneNumber,
    required String shopName,
    required String shopDescription,
  }) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance
            .collection("Owner")
            .doc(user.uid)
            .update({
          'firstName': firstName,
          'lastName': lastName,
          'phoneNumber': phoneNumber,
          'shopName': shopName,
          'shopDescription': shopDescription,
        });

        return true;
      }
    } catch (e) {
      print("Error updating name: $e");
    }
    return false;
  }
  //------------------------------------------ Change Owner loaction --------------------------

  Future<bool> changeOnwerLocation({
    required double shoplatitude,
    required double shoplongitude,
  }) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance
            .collection("Owner")
            .doc(user.uid)
            .update({
          'shoplatitude': shoplatitude,
          'shoplongitude': shoplongitude,
        });

        return true;
      }
    } catch (e) {
      print("Error updating name: $e");
    }
    return false;
  }

//------------------------------------------ Change user profile--------------------------

  Future<bool> changeUserprofile({
    required String firstName,
    required String lastName,
    required String phoneNumber,
  }) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance
            .collection("Booker")
            .doc(user.uid)
            .update({
          'firstName': firstName,
          'lastName': lastName,
          'phoneNumber': phoneNumber,
        });

        print("User name updated to $firstName $lastName");
        return true;
      }
    } catch (e) {
      print("Error updating name: $e");
    }
    return false;
  }

  //------------------------------------------ get token id user data--------------------------

  Future<bool> gettokeniddata({
    required String collection,
  }) async {
    try {
      NotificationService notificationService = NotificationService();
      String? deviceToken = await notificationService.getDeviceToken();

      // ignore: prefer_conditional_assignment
      if (deviceToken == null) {
        deviceToken = await notificationService.refreshToken();
      }

      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DocumentReference docRef =
            FirebaseFirestore.instance.collection(collection).doc(user.uid);

        DocumentSnapshot docSnapshot = await docRef.get();

        if (docSnapshot.exists) {
          await docRef.update({
            'getDeviceToken': deviceToken,
          });
        } else {
          await docRef.set({
            'getDeviceToken': deviceToken,
          }, SetOptions(merge: true));
        }

        return true;
      }
    } catch (e) {
      print("Error updating device token: $e");
    }
    return false;
  }

  //------------------------------------------ get token id delet--------------------------

  Future<void> removeDeviceTokenOnLogout({
    required String collection,
  }) async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance
          .collection(collection)
          .doc(user.uid)
          .update({'getDeviceToken': ""});
    }
  }
  //=========================================== End line================================================
}
