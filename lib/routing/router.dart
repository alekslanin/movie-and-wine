import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wineandmovie/auth_service.dart';
import 'package:wineandmovie/routing/names.dart';
import 'package:wineandmovie/ui/account_balances_page.dart';
import 'package:wineandmovie/ui/login_page.dart';
import 'package:wineandmovie/ui/register_page.dart';
import 'package:wineandmovie/ui/wine_page.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(
    debugLabel: 'root',
  );
final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>(
    debugLabel: 'shell',
  );

final router = Provider<GoRouter>((ref) {
  final auth = ref.watch(authStateProvider);

  return GoRouter(
  //static GoRouter router = GoRouter(
    //refreshListenable: auth, // Assuming auth is a Listenable
    
    redirect: (context, state) {
      final isGoingToLogin = state.matchedLocation == '/auth';

      if (auth.isUserLoggedIn()) {
        if (isGoingToLogin) {
          return '/';
        }
      }

      return null;
    },
    
    initialLocation: '/balance',
    navigatorKey: _rootNavigatorKey,
    debugLogDiagnostics: true,
    routes: [
      GoRoute( 
        path: '/auth', 
        name: RoutingNames.login.name,
        builder: (context, state) => LoginPage(),
        routes: [ 
          GoRoute( 
            path: 'register', 
            name: RoutingNames.register.name,
            builder: (context, state) => RegisterPage()),    
        ],
      ),
      GoRoute( // main landing page after login
        name: RoutingNames.wine.name,
        path: '/',
        builder: (context, state) => const WinePage(),
      ),
      GoRoute( // main landing page after login
        name: RoutingNames.balance.name,
        path: '/balance',
        builder: (context, state) => const AccountBalancesPage(),
      ),
    ],
  );
  // Routing logic will be implemented here
}
);