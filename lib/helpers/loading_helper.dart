import 'package:flutter/material.dart';
import 'loading_indicators.dart';

import 'navigation_service.dart';

extension Loader<T> on Future<T> {
  Future<T> waitingForFutureWithoutBg() async {
    showDialog(
      context: NavigationService.context!,
      barrierDismissible: false,
      builder: (context) => loadingIndicatorCircle(context: context),
    );

    try {
      // Wait for the original future to complete
      T result = await this;
      return result;
    } finally {
      // Close the loading dialog
      NavigationService.goBackCall();
    }
  }
}

void loadingShow() {
  showDialog(
    context: NavigationService.context!,
    barrierDismissible: false,
    builder: (context) => loadingIndicatorCircle(context: context),
  );
}

void loadingHide() {
  NavigationService.goBackCall();
}
