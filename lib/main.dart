import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_ecommerce_app/src/config/route.dart';
import 'package:flutter_ecommerce_app/src/pages/main_page.dart';
import 'package:flutter_ecommerce_app/src/pages/product_detail_page.dart';
import 'package:flutter_ecommerce_app/src/providers/providers.dart';
import 'package:flutter_ecommerce_app/src/themes/theme.dart';
import 'package:flutter_ecommerce_app/src/utils/error_handler.dart';
import 'package:flutter_ecommerce_app/src/widgets/auth_gate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

Future<void> main() async {
  // Ensure Flutter engine is ready for platform calls (SharedPreferences/Supabase)
  WidgetsFlutterBinding.ensureInitialized();
  
  // 1. Load environment variables for security
  await dotenv.load(fileName: ".env");
  
  // 2. Initialize Supabase Cloud
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );
  AppErrorHandler.init(rootScaffoldMessengerKey);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // These providers handle all logic and Local Persistence (SharedPreferences)
        ChangeNotifierProvider(create: (_) => UserPreferencesProvider()), // Theme
        ChangeNotifierProvider(create: (_) => FavoritesProvider()),       // Persistent Likes
        ChangeNotifierProvider(create: (_) => CartProvider()),            // Persistent Cart
        ChangeNotifierProvider(create: (_) => ProductProvider()),         // Cloud Products
        ChangeNotifierProvider(create: (_) => CategoryProvider()),        // Cloud Categories
        Provider(create: (_) => OrdersProvider()),                        // Orders stream
      ],
      child: Consumer<UserPreferencesProvider>(
        builder: (context, userPref, child) {
          // 3. Dynamic Theme Selection
          final baseTheme = userPref.isDarkTheme
              ? AppTheme.darkTheme
              : AppTheme.lightTheme;
          
          // Apply Mulish Font with correct colors based on theme
          final textTheme = GoogleFonts.mulishTextTheme(baseTheme.textTheme)
              .apply(
                bodyColor: baseTheme.textTheme.bodyLarge?.color,
                displayColor: baseTheme.textTheme.bodyLarge?.color,
              );

          return MaterialApp(
            title: 'Nexus Store',
            theme: baseTheme.copyWith(textTheme: textTheme),
            debugShowCheckedModeBanner: false,
            scaffoldMessengerKey: rootScaffoldMessengerKey,
            
            // 4. Entry Point: AuthGate checks if user is logged in
            home: const AuthGate(),
            
            // Named Routes
            routes: Routes.getRoute(),
            
            // Dynamic/Complex Transitions
            onGenerateRoute: (RouteSettings? settings) {
              if (settings?.name != null && settings!.name!.contains('detail')) {
                return CustomRoute<bool>(
                  builder: (BuildContext context) => const ProductDetailPage(),
                  settings: settings,
                );
              } else {
                return CustomRoute<bool>(
                  builder: (BuildContext context) => const MainPage(
                    key: ValueKey('main_root'), 
                  ),
                  settings: settings,
                );
              }
            },
          );
        },
      ),
    );
  }
}
