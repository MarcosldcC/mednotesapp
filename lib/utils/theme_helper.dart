import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/colors.dart';
import '../services/settings_service.dart';

class ThemeHelper {
  static Color getBackgroundColor(BuildContext context) {
    final settings = Provider.of<SettingsService>(context, listen: false);
    if (settings.highContrast) {
      return Colors.white;
    }
    return AppColors.creamCard;
  }

  static Color getTextColor(BuildContext context) {
    final settings = Provider.of<SettingsService>(context, listen: false);
    if (settings.highContrast) {
      return Colors.black;
    }
    return AppColors.darkGreenHeader;
  }

  static Color getCardColor(BuildContext context) {
    final settings = Provider.of<SettingsService>(context, listen: false);
    if (settings.highContrast) {
      return Colors.white;
    }
    return Colors.white;
  }

  static Color getBorderColor(BuildContext context) {
    final settings = Provider.of<SettingsService>(context, listen: false);
    if (settings.highContrast) {
      return Colors.black;
    }
    return AppColors.mediumGreen.withOpacity(0.3);
  }

  static Color getHeaderColor(BuildContext context) {
    final settings = Provider.of<SettingsService>(context, listen: false);
    if (settings.highContrast) {
      return Colors.black;
    }
    return AppColors.darkGreenHeader;
  }
}
