import 'package:car_rent/utilz/contants/export.dart';

class Ownerviewercontroller extends ChangeNotifier {
  bool isLoading = false;
//=========================================== Add new ====================================================
  Future<bool> addNewCarFunction(
      {required String carname,
      required String description,
      required String model,
      required String speed,
      required String flue,
      required String rent,
      required List carImagess,
      required transmsion,
     
      required drand}) async {
    isLoading = true;
    notifyListeners();

    List<String> imageUrls = [];

    try {
      var note = FirebaseFirestore.instance.collection("Cars");

      for (var image in carImagess) {
        String fileName = image.name;
        Reference ref = FirebaseStorage.instance.ref().child(
            "car_images/${FirebaseAuth.instance.currentUser!.uid}/$fileName");

        UploadTask uploadTask = ref.putFile(File(image.path));
        TaskSnapshot snapshot = await uploadTask;

        String downloadUrl = await snapshot.ref.getDownloadURL();
        imageUrls.add(downloadUrl);
      }

      await note.doc().set({
        "CarName": carname,
        "Cardescription": description,
        "Carmodel": model,
        "Carspeed": speed,
        "Carflue": flue,
        "Carrent": rent,
        "CarTransmsion": transmsion,
        "Cardrand": drand,
        "CarImages": imageUrls,
        "dateTime": DateTime.now(),
        "ownerUid": FirebaseAuth.instance.currentUser!.uid,
        "isActive": true,
      });

      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      print("ERROR: $e");
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

//=========================================== Add new ====================================================
  Future<bool> carUpdateData(String docId, bool isACTIVE) async {
    isLoading = true;
    notifyListeners();
    try {
      var note = FirebaseFirestore.instance.collection("Cars");
      await note.doc(docId).update({
        "isActive": isACTIVE,
      });
      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      print("ERROR: $e");
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  //=========================================== Add new ====================================================
  Future<bool> carUpDateAllData({
    required String carname,
    required String description,
    required String model,
    required String speed,
    required String flue,
    required String rent,
    required transmsion, 
    required String docId,
    required List carImagess, 
    required drand, 
  }) async {
    isLoading = true;
    notifyListeners();

    try {
      List<String> imageUrls = [];
      var note = FirebaseFirestore.instance.collection("Cars");

      for (var image in carImagess) {
        if (image is! String) {
          String fileName = image.name;
          Reference ref = FirebaseStorage.instance.ref().child(
              "car_images/${FirebaseAuth.instance.currentUser!.uid}/$fileName");
          UploadTask uploadTask = ref.putFile(File(image.path));
          TaskSnapshot snapshot = await uploadTask;
          String downloadUrl = await snapshot.ref.getDownloadURL();
          imageUrls.add(downloadUrl);
        } else {
          imageUrls.add(image);
        }
      }

      await note.doc(docId).update({
        "CarName": carname,
        "Cardescription": description,
        "Carmodel": model,
        "Carspeed": speed,
        "Carflue": flue,
        "CarImages": imageUrls,
        "Carrent": rent,
        "CarTransmsion": transmsion,
        "Cardrand": drand,
        "dateTime": DateTime.now(),
      });

      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      print("ERROR: $e");
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  //===========================EndLine================================================
}
