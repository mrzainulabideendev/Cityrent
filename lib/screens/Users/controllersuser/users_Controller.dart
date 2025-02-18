import 'package:car_rent/utilz/contants/export.dart';

class UserViewerController extends ChangeNotifier {
  bool isLoading = false;

  ///-----------------------------------------------------favoriteCars------------------------------------------------
  List<String> favoriteCars = []; // List to hold favorite car IDs

  // Fetch the favorite cars from Firestore
  Future<void> fetchFavoriteCars() async {
    isLoading = true;
    notifyListeners();

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception("User is not logged in");
      }

      final userUid = user.uid;
      final favoritesRef = FirebaseFirestore.instance
          .collection("Booker")
          .doc(userUid)
          .collection("Favorites");

      // Get the favorite cars for the user
      final snapshot = await favoritesRef.get();
      favoriteCars = snapshot.docs
          .map((doc) => doc.id)
          .toList(); // Store the favorite car IDs

      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      notifyListeners();
      print("Error fetching favorite cars: $e");
    }
  }

  // Add or remove a car from favorites
  Future<void> toggleFavoriteCar(String carId, bool isFavorite) async {
    isLoading = true;
    notifyListeners();

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception("User is not logged in");
      }

      final userUid = user.uid;
      final favoritesRef = FirebaseFirestore.instance
          .collection("Booker")
          .doc(userUid)
          .collection("Favorites");

      if (isFavorite) {
        await favoritesRef.doc(carId).delete();
        favoriteCars.remove(carId);
      } else {
        await favoritesRef.doc(carId).set({
          'carId': carId,
          'timestamp': FieldValue.serverTimestamp(),
        });
        favoriteCars.add(carId);
      }

      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      notifyListeners();
      print("Error adding/removing favorite: $e");
    }
  }

  // Check if a car is a favorite
  bool isCarFavorite(String carId) {
    return favoriteCars.contains(carId);
  }

  //  ///-----------------------------------------------------favoriteCars------------------------------------------------
  Future<bool> bookingCar({
    required carId,
    required ownerUid,
    required carName,
    required carModel,
    required startDate,
    required payPrice,
    required carRent,
    required carImage,
    required carbookdays,
  }) async {
    try {
      final userUid = FirebaseAuth.instance.currentUser!.uid;

      final bookCarRef = FirebaseFirestore.instance.collection("booking");
      // .doc(userUid)
      // .collection("Booking");

      await bookCarRef.doc().set({
        'carId': carId,
        'userId': userUid,
        'owner': ownerUid,
        'carName': carName,
        'carModel': carModel,
        'startDate': startDate,
        'carbookdays': carbookdays,
        'payPrice':  payPrice,
        'carRent': carRent,
        'carImage': carImage,
        'dateTime': DateTime.now(),
        "cancel": false,
        "rideComplete": false,
        "requestOwnr": false,
        "cashistory": "",
      });
      return true;
    } catch (e) {
      print("Error booking car: $e");
            return false;

    }
  }

///////////////////////////////////========================================cancelUpdate===========================================
  Future<bool> cancelUpdate({
    required String bookingId,
  }) async {
    try {
      final bookCarRef = FirebaseFirestore.instance.collection("booking");

      bookCarRef.doc(bookingId).update({
        "cancel": true,
      });

      return true;
    } catch (e) {
      print("$e");
      return false;
    }
  }

  ///////////////////////////////////========================================requestOwnr===========================================
  Future<bool> requestOwnr({
    required String bookingId,
  }) async {
    try {
      final bookCarRef = FirebaseFirestore.instance.collection("booking");

      bookCarRef.doc(bookingId).update({
        "requestOwnr": true,
      });

      return true;
    } catch (e) {
      print("$e");
      return false;
    }
  }

  ///////////////////////////////////========================================rideComplete===========================================
  Future<bool> rideComplete({
    required String bookingId,
  }) async {
    try {
      final bookCarRef = FirebaseFirestore.instance.collection("booking");

      bookCarRef.doc(bookingId).update({
        "rideComplete": true,
      });

      return true;
    } catch (e) {
      print("$e");
      return false;
    }
  }
/////////////////////////////////////////////////review/////////////////////////////////////////

Future<bool> reviewrideComplete({
  required String carid,
  required String comment,
  required double star,  // Ensure that 'star' is an integer
  required String name,
}) async {
  try {
    await FirebaseFirestore.instance
        .collection("Cars")
        .doc(carid)
        .collection("Reviews")
        .doc()
        .set({
      "comment": comment,
      "name": name,
      "star": star,
      "dateTime": DateTime.now(),
    });

    return true;
  } catch (e) {
    print("$e");
    return false;
  }
}
/////////////////////////////////chash histor/////////////////////////////////////////
  Future<bool> cashhistoryUpdate({
    required String bookingId,
        required String cashistory

  }) async {
    try {
      final bookCarRef = FirebaseFirestore.instance.collection("booking");

      bookCarRef.doc(bookingId).update({
        "cashistory": cashistory,
      });

      return true;
    } catch (e) {
      print("$e");
      return false;
    }
  }

/////////////////////////////////////////////////end line/////////////////////////////////////////
}
