import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:hellenic_shipping_services/core/constants/colors.dart';
import 'package:hellenic_shipping_services/screens/widget/custom_text.dart';
import 'package:toastification/toastification.dart';

class AnimationConstants {
  static const Duration forwardTransitionDuration = Duration(milliseconds: 400);
  static const Duration reverseTransitionDuration = Duration(milliseconds: 400);
  static final Tween<double> scaleTween = Tween<double>(begin: 0.9, end: 1.0);
  static final Tween<double> rotationTween = Tween<double>(
    begin: 0.92,
    end: 1.0,
  );
  static final Tween<Offset> slideFromRightTween = Tween<Offset>(
    begin: const Offset(1.0, 0.0),
    end: Offset.zero,
  );
  static final Tween<Offset> slideFromLeftTween = Tween<Offset>(
    begin: const Offset(-1.0, 0.0),
    end: Offset.zero,
  );
}

class WidgetConstants {
  static const EdgeInsets horizontalPadding15 = EdgeInsets.symmetric(
    horizontal: 15,
  );
  static const EdgeInsets horizontalPadding20 = EdgeInsets.symmetric(
    horizontal: 20,
  );
  static const EdgeInsets verticalPadding8 = EdgeInsets.symmetric(vertical: 8);
  static const EdgeInsets allPadding15 = EdgeInsets.all(15);
  static const EdgeInsets allPadding20 = EdgeInsets.all(20);

  // Common border radius values
  static const double borderRadius8 = 8.0;
  static const double borderRadius12 = 12.0;
  static const double borderRadius16 = 16.0;
  static const double borderRadius20 = 20.0;
}

class Wpad extends StatelessWidget {
  final Widget child;

  const Wpad({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(padding: WidgetConstants.horizontalPadding15, child: child);
  }
}

class ListConfig extends StatelessWidget {
  final Widget child;
  const ListConfig({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      removeBottom: true,
      removeLeft: true,
      removeRight: true,
      child: ScrollConfiguration(
        behavior: ScrollBehavior().copyWith(overscroll: false),
        child: child,
      ),
    );
  }
}

void scaffoldMsg({
  required BuildContext context,
  required String content,
  Color? bcolor,
}) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: bcolor ?? Colors.red,
      content: Txt(content, color: Colors.white, font: Font.medium),
    ),
  );
}

class ToastManager {
  static ToastificationItem? _current;
  static void showSingle(
    BuildContext context, {
    required String title,
    String? subtitle,
    ToastificationType type = ToastificationType.info,
    ToastificationStyle style = ToastificationStyle.flat,
    Color? textcolor,
    int duration = 2,
    Function(ToastificationItem)? onTap,
  }) {
    if (_current != null) {
      Toastification().dismiss(_current!, showRemoveAnimation: false);
      _current = null;
    } else {
      Toastification().dismissAll(delayForAnimation: false);
    }
    _current = Toastification().show(
      dismissDirection: DismissDirection.up,
      style: style,
      backgroundColor: Theme.of(context).colorScheme.surface,
      context: context,
      borderSide: BorderSide(color: Color(0xFFFFBF00)),
      description: subtitle != null
          ? Txt(
              subtitle,
              color: textcolor ?? Theme.of(context).colorScheme.onSurface,
              font: Font.medium,
              size: 13.sp,
            )
          : null,
      title: Txt(
        title,
        color: textcolor ?? Theme.of(context).colorScheme.onSurface,
        font: Font.medium,
        size: 16.sp,
      ),
      type: type,
      alignment: Alignment.topCenter,
      autoCloseDuration: Duration(seconds: duration),
      callbacks: ToastificationCallbacks(onTap: onTap),
    );
  }
}

Route pageTransition({
  required BuildContext context,
  required target,
  int type = 10,
}) {
  switch (type) {
    case 1:
      return PageRouteBuilder(
        transitionDuration: AnimationConstants.forwardTransitionDuration,
        reverseTransitionDuration: AnimationConstants.reverseTransitionDuration,
        pageBuilder: (_, __, ___) => target,
        transitionsBuilder: (_, animation, __, child) {
          final curved = CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
            reverseCurve: Curves.easeInCubic,
          );
          return RepaintBoundary(
            child: FadeTransition(opacity: curved, child: child),
          );
        },
      );
    case 2:
      return PageRouteBuilder(
        transitionDuration: AnimationConstants.forwardTransitionDuration,
        reverseTransitionDuration: AnimationConstants.reverseTransitionDuration,
        pageBuilder: (_, __, ___) => target,
        transitionsBuilder: (_, animation, __, child) {
          final curved = CurvedAnimation(
            parent: animation,
            curve: Curves.easeIn,
            reverseCurve: Curves.easeOut,
          );
          return RepaintBoundary(
            child: SlideTransition(
              position: AnimationConstants.slideFromRightTween.animate(curved),
              child: child,
            ),
          );
        },
      );
    case 3:
      return PageRouteBuilder(
        transitionDuration: AnimationConstants.forwardTransitionDuration,
        reverseTransitionDuration: AnimationConstants.reverseTransitionDuration,
        pageBuilder: (_, __, ___) => target,
        transitionsBuilder: (_, animation, __, child) {
          final curved = CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
            reverseCurve: Curves.easeInCubic,
          );
          return RepaintBoundary(
            child: SlideTransition(
              position: AnimationConstants.slideFromLeftTween.animate(curved),
              child: child,
            ),
          );
        },
      );
    case 4:
      return PageRouteBuilder(
        transitionDuration: AnimationConstants.forwardTransitionDuration,
        reverseTransitionDuration: AnimationConstants.reverseTransitionDuration,
        pageBuilder: (_, __, ___) => target,
        transitionsBuilder: (_, animation, __, child) {
          final curved = CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutBack,
            reverseCurve: Curves.easeInBack,
          );
          return RepaintBoundary(
            child: ScaleTransition(
              scale: AnimationConstants.scaleTween.animate(curved),
              child: child,
            ),
          );
        },
      );
    case 5:
      return PageRouteBuilder(
        transitionDuration: AnimationConstants.forwardTransitionDuration,
        reverseTransitionDuration: AnimationConstants.reverseTransitionDuration,
        pageBuilder: (_, __, ___) => target,
        transitionsBuilder: (_, animation, __, child) {
          final curved = CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
            reverseCurve: Curves.easeInCubic,
          );
          return RepaintBoundary(
            child: RotationTransition(
              turns: AnimationConstants.rotationTween.animate(curved),
              child: child,
            ),
          );
        },
      );
    default:
      return MaterialPageRoute(builder: (_) => target);
  }
}

String getErrorMessage(int statusCode) {
  switch (statusCode) {
    case 400:
      return "Something went wrong with your request.";
    case 401:
      return "You’re not logged in.";
    case 403:
      return "You don’t have permission to do this.";
    case 404:
      return "Oops! The page or data you’re looking for isn’t here.";
    case 408:
      return "The connection took too long.";
    case 429:
      return "You’re going too fast. Please wait a moment.";
    case 500:
      return "Something broke on our side.";
    case 502:
      return "The server had trouble responding.";
    case 503:
      return "The service is temporarily down.";
    case 504:
      return "Server took too long to respond.";
    default:
      return "An unexpected error occurred. Please try again.";
  }
}
