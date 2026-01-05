import 'package:go_router/go_router.dart';
import 'package:wineandmovie/routing/names.dart';
import 'package:wineandmovie/ui/login_page.dart';
import 'package:wineandmovie/ui/register_page.dart';
import 'package:wineandmovie/ui/wine_page.dart';

class AppRouter {

  /*
  * Navigate to a named route
  * as : await AppRouter.goTo(context, RoutingNames.login, params: {'id': '123'});
  * or : AppRouter.goTo(context, RoutingNames.login) or AppRouter.goTo(RoutingNames.login, params: {'id': '123'});
  */
  static Future<T?> pushReplacement<T>(
    dynamic context, 
    RoutingNames routeName, { 
      Map<String, String> params = const {},
    }
    ) {
    //return GoRouter.of(AppRouter.router.routerDelegate.navigatorKey.currentContext!).pushNamed<T>(routeName.name, pathParameters: params);
    return GoRouter.of(context).pushReplacementNamed<T>(routeName.name, pathParameters: params);
  }

  static Future<T?> push<T>(
    dynamic context, 
    RoutingNames routeName, { 
      Map<String, String> params = const {},
    }
    ) {
    //return GoRouter.of(AppRouter.router.routerDelegate.navigatorKey.currentContext!).pushNamed<T>(routeName.name, pathParameters: params);
    return GoRouter.of(context).pushNamed<T>(routeName.name, pathParameters: params);
  }


  static GoRouter router = GoRouter(
    // Define your routes here
    redirect: (context, state) { // after login redirect to home page
      return null;
    },
    initialLocation: '/auth',
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
    ],
   );  
  // Routing logic will be implemented here
}