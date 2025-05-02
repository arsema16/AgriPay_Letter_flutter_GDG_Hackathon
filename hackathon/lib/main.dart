import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Screens
import 'package:path_provider_android/messages.g.dart';
import '../screens/splash_screen.dart';
import '../screens/farmer_home_screen.dart';
import '../screens/loan_status_screen.dart' as loan;
import '../screens/prediction_screen.dart' as prediction;
import '/screens/harvest_log_screen.dart' as harvest;
import '/screens/repayment_dashboard_screen.dart' as repayment;
import '/screens/view_profile_screen.dart';
// Providers
import 'providers/farmer_provider.dart';
import 'providers/loan_provider.dart';
import 'providers/harvest_provider.dart';
import 'providers/auth_provider.dart';

void main() => runApp(AgriPayLaterApp());

class AgriPayLaterApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => FarmerProvider()),
        ChangeNotifierProxyProvider<FarmerProvider, LoanProvider>(
          create: (_) => LoanProvider(),
          update: (_, farmerProv, loanProv) =>
              loanProv!..updateFarmer(farmerProv.farmer!),
        ),
        ChangeNotifierProvider(create: (_) => HarvestProvider()),
      ],
      child: MaterialApp(
        title: 'AgriPay Later',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
          useMaterial3: true,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashScreen(),
          '/dashboard': (context) => FarmerHomeScreen(),
          '/loan': (context) => loan.LoanStatusScreen(),
          '/harvest-log': (context) => harvest.HarvestStatusScreen(),
          '/repayment': (context) => repayment.RepaymentInfoScreen(),
          //'/register': (context) => RegistrationScreen(),
          '/prediction': (context) => prediction.PredictionScreen(),
          '/view-profile': (context) => const ViewProfileScreen(),
        },
      ),
    );
  }
}
