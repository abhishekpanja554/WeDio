import 'package:WEdio/Screens/call_screen.dart';
import 'package:WEdio/Screens/chat_page.dart';
import 'package:WEdio/Screens/home_page.dart';
import 'package:WEdio/Screens/login_page.dart';
import 'package:WEdio/Screens/signip_page.dart';
import 'package:WEdio/Screens/splash.dart';
import 'package:WEdio/main.dart';
import 'package:WEdio/models/class_models.dart';
import 'package:go_router/go_router.dart';

final router = GoRouter(
  navigatorKey: NavigationService.navigatorKey,
  initialLocation: SplashScreen.id,
  routes: [
    GoRoute(
      path: HomePage.id,
      builder: (context, state) => HomePage(),
    ),
    GoRoute(
      path: LoginPage.id,
      builder: (context, state) => LoginPage(),
    ),
    GoRoute(
      path: SignupPage.id,
      builder: (context, state) => SignupPage(),
    ),
    GoRoute(
      path: SplashScreen.id,
      builder: (context, state) => SplashScreen(),
    ),
    GoRoute(
      path: CallScreen.id,
      builder: (context, state) {
        CallScreenArgs arguments = state.extra as CallScreenArgs;
        return CallScreen(
          calleeId: arguments.calleeId,
          calleeName: arguments.calleeName,
          callerId: arguments.callerId,
          offer: arguments.offer,
          key: arguments.key,
        );
      },
    ),
    GoRoute(
      path: ChatPage.id,
      builder: (context, state) {
        ChatPageArgs arguments = state.extra as ChatPageArgs;
        return ChatPage(
          chatParticipant: arguments.chatParticipant,
          conversationId: arguments.conversationId,
        );
      },
    ),
  ],
);
