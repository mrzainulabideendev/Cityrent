import 'package:car_rent/utilz/contants/export.dart';
import 'package:permission_handler/permission_handler.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key, required String title});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  /////////////////////////////////////////////////////
  NotificationService notificatonSevice = NotificationService();
  /////////////////////////////////////////////////////

  @override
  void initState() {
    super.initState();

    // Request notification permission
    notificatonSevice.requestNotificationPermission();

    // Initialize Firebase and setup notifications
    notificatonSevice.firebaseInit(context);
    notificatonSevice.setupInteractNotifications(context);

    // Request location permission
    requestLocationPermission();
  }

  // Request location permission
  Future<void> requestLocationPermission() async {
    PermissionStatus status = await Permission.location.status;

    if (status.isGranted) {
      print('Location permission already granted');
    } else if (status.isDenied) {
      PermissionStatus newStatus = await Permission.location.request();
      if (newStatus.isGranted) {
        print('Location permission granted');
      } else {
        print('Location permission denied');
      }
    } else if (status.isPermanentlyDenied) {
      print('Location permission is permanently denied');
      // Redirect user to app settings to manually enable the permission
      openAppSettings();
    }
  }

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
                width: w,
                color: AppColors.primaryColors.withOpacity(0.5),
                child: Column(
                  children: [
                    SizedBox(height: h * 0.17),
                    SizedBox(
                      height: h * 0.3,
                      width: w * 0.5,
                      child: Image.asset(IconsApp.appIcons),
                    ),
                    apptext(
                      myText: "CityRent",
                      size: 40,
                      isBold: true,
                      textColor: AppColors.textcolour,
                    ),
                    SizedBox(height: h * 0.29),
                    SizedBox(
                      height: h * 0.065,
                      width: w * 0.8,
                      child: appbutton(
                        buttonText: "Let's go Start",
                        onTap: () async {
                          authsRead.checkLoginStatus(context);
                        },
                        bottonColor: AppColors.buttonColors,
                        splashColor: AppColors.primaryColors,
                      ),
                    )
                  ],
                ),
              ),
            ),
            authsWatch.isLoading ? loadingforall() : const SizedBox()
          ],
        ),
      ),
    );
  }
}
