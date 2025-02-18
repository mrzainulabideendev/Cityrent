import 'package:car_rent/utilz/contants/export.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Stripe.publishableKey =
      "pk_test_51QBy1KFEvQcbtRvjTBqFFgXYXLzfg2NOgVhvnEfOpuLui0fhVmqkxlO6G3ludujpXXooDIuCRYWa1c18v70xv1rD00O63J6xqK";
  FirebaseMessaging.onBackgroundMessage(_firebasemessageingBackground);

  runApp(const MyApp());
}

///////////////////////////////////////////////
@pragma("vm:entry-point")
Future<void> _firebasemessageingBackground(RemoteMessage message) async {
  await Firebase.initializeApp();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => Authencationcontroller(),
        ),
        ChangeNotifierProvider(
          create: (_) => Ownerviewercontroller(),
        ),
        ChangeNotifierProvider(
          create: (_) => UserViewerController(),
        ),
        ChangeNotifierProvider(
          create: (_) => GolbProviderNotification(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Car Rent',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const SplashScreen(title:'Flutter Demo Home Page'),
      ),
    );
  }
}
