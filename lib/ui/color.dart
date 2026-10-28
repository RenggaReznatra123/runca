import 'package:flutter/material.dart';

// color pallette plarita
class AppPalette {
  const AppPalette._();

  // Base
  static const Color baseWhite = Color(0xFFFFFFFF);
  static const Color baseBlack = Color(0xFF000000);
  // Transparan penuh untuk pengganti Colors.transparent.
  static const Color transparent = Color(0x00000000);
  // Overlay hitam 54% untuk pengganti Colors.black54.
  static const Color overlayBlack54 = Color(0x8A000000);

  // Text
  static const Color textNeutralPrimary = Color(0xFF333333);
  static const Color textNeutralSecondary = Color(0xFFAAAAAA);
  static const Color textWhitePrimary = Color(0xFFFFFFFF);
  static const Color textWhiteSecondary = Color(0xFFD1D1D1);
  static const Color textDisabled = Color(0xFFC0C0C0);
  static const Color textPrimary = Color(0xFF1767F9);
  static const Color textSecondary = Color(0xFFDB4B00);
  static const Color textDanger = Color(0xFFD82027);
  static const Color textSuccess = Color(0xFF2C831B);
  static const Color textWarning = Color(0xFFDB7200);
  static const Color textInfo = Color(0xFF1863E2);
  static const Color textButtonPrimary = Color(0xFFFFFFFF);
  static const Color textButtonSecondaryDefault = Color(0xFF2E87FF);
  static const Color textButtonSecondaryHover = Color(0xFF1052EB);
  static const Color textButtonSecondaryPressed = Color(0xFF1440B9);
  static const Color textButtonOutlined = Color(0xFF333333);
  static const Color textButtonDanger = Color(0xFFFFFFFF);
  static const Color textButtonSuccess = Color(0xFFFFFFFF);
  static const Color textButtonWarning = Color(0xFFFFFFFF);

  // Icon
  static const Color iconNeutralPrimary = Color(0xFF333333);
  static const Color iconNeutralSecondary = Color(0xFFAAAAAA);
  static const Color iconWhite = Color(0xFFFFFFFF);
  static const Color iconDisabled = Color(0xFFC0C0C0);
  static const Color iconPrimary = Color(0xFF1767F9);
  static const Color iconSecondary = Color(0xFFDB4B00);
  static const Color iconDanger = Color(0xFFD82027);
  static const Color iconSuccess = Color(0xFF2C831B);
  static const Color iconWarning = Color(0xFFDB7200);
  static const Color iconInfo = Color(0xFF1863E2);
  static const Color iconButtonPrimary = Color(0xFFFFFFFF);
  static const Color iconTextIconSecondaryDefault = Color(0xFF0199F6);
  static const Color iconButtonSecondaryHover = Color(0xFF1767F9);
  static const Color iconButtonSecondaryPressed = Color(0xFF1440B9);
  static const Color iconButtonOutlined = Color(0xFF333333);
  static const Color iconButtonDanger = Color(0xFFFFFFFF);
  static const Color iconButtonSuccess = Color(0xFFFFFFFF);
  static const Color iconButtonWarning = Color(0xFFFFFFFF);

  // Bg
  static const Color bg = Color(0xFFFFFFFF);
  static const Color bgPrimary = Color(0xFFFAFAFA);
  static const Color bgBlack = Color(0xFF333333);
  static const Color bgSurfaceNeutral = Color(0xFFF7F7F7);
  static const Color bgSurfaceNeutral2 = Color(0xFFE3E3E3);
  static const Color bgSurfacePrimary = Color(0xFFEEF7FF);
  static const Color bgSurfaceSecondary = Color(0xFFFFF8EC);
  static const Color bgSurfaceDanger = Color(0xFFFFF2F1);
  static const Color bgSurfaceSuccess = Color(0xFFF4FCF1);
  static const Color bgSurfaceWarning = Color(0xFFFFFBEC);
  static const Color bgSurfaceInfo = Color(0xFFEFF6FF);
  static const Color bgHoverNeutral = Color(0xFFE3E3E3);
  static const Color bgHoverPrimary = Color(0xFFBADDFF);
  static const Color bgHoverDanger = Color(0xFFFEE5D4);
  static const Color bgHoverSuccess = Color(0xFFE7F9D4);
  static const Color bgHoverWarning = Color(0xFFFFF1CC);
  static const Color bgHoverInfo = Color(0xFFD0E7FD);
  static const Color bgFillNeutral = Color(0xFFAAAAAA);
  static const Color bgFillPrimary = Color(0xFF1767F9);
  static const Color bgFillSecondary = Color(0xFFDB4B00);
  static const Color bgFillDanger = Color(0xFFFC372D);
  static const Color bgFillSuccess = Color(0xFF2C831B);
  static const Color bgFillWarning = Color(0xFFDB7200);
  static const Color bgFillInfo = Color(0xFF1863E2);
  static const Color bgButtonPrimaryDefault = Color(0xFF1767F9);
  static const Color bgButtonPrimaryHover = Color(0xFF0060AA);
  static const Color bgButtonPrimaryPressed = Color(0xFF1440B9);
  static const Color bgButtonSecondaryDefault = Color(0xFFEEF7FF);
  static const Color bgButtonOutlinedDefault = Color(0xFFFFFFFF);
  static const Color bgButtonOutlinedHover = Color(0xFFF0F0F0);
  static const Color bgButtonOutlinedPressed = Color(0xFFE3E3E3);
  static const Color bgButtonDangerDefault = Color(0xFFFC372D);
  static const Color bgButtonDangerHover = Color(0xFFD82027);
  static const Color bgButtonDangerPressed = Color(0xFFD82027);
  static const Color bgButtonSuccessDefault = Color(0xFF419926);
  static const Color bgButtonSuccessHover = Color(0xFF2C831B);
  static const Color bgButtonSuccessPressed = Color(0xFF1B6E13);
  static const Color bgButtonWarningDefault = Color(0xFFDB7200);
  static const Color bgButtonWarningHover = Color(0xFFB75700);
  static const Color bgButtonWarningPressed = Color(0xFF933F00);
  static const Color bgDisabled = Color(0xFFE3E3E3);
  static const Color bgForm = Color(0xFFFFFFFF);
  static const Color bgModal = Color(0xFFFFFFFF);
  static const Color bgBackdrop = Color(0x33818181); // Figma #81818133
  static const Color bgSwitch = Color(0xFFD1D1D1);
  static const Color bgButtonSwitch = Color(0xFFFFFFFF);

  // Border
  static const Color borderNeutral = Color(0xFFE3E3E3);
  static const Color borderTransparentDark = Color(
    0x0A0A0A0A,
  ); // Figma #0a0a0a0a
  static const Color borderTransparentLight = Color(
    0x1FFFFFFF,
  ); // Figma #ffffff1f
  static const Color borderPrimary = Color(0xFF1767F9);
  static const Color borderSecondary = Color(0xFFDB4B00);
  static const Color borderDanger = Color(0xFFD82027);
  static const Color borderSuccess = Color(0xFF2C831B);
  static const Color borderWarning = Color(0xFFFFB43F);
  static const Color borderInfo = Color(0xFF1863E2);
  static const Color borderDisabled = Color(0xFFD1D1D1);
  static const Color borderFillNeutral = Color(0xFF969696);
  static const Color borderFillPrimary = Color(0xFF1767F9);
  static const Color borderFillSecondary = Color(0xFFDB4B00);
  static const Color borderFillDanger = Color(0xFFD82027);
  static const Color borderFillSuccess = Color(0xFF2C831B);
  static const Color borderFillWarning = Color(0xFFFFB43F);
  static const Color borderFillInfo = Color(0xFF1863E2);
  static const Color borderButtonOutlinedDefault = Color(0xFFD1D1D1);
  static const Color borderButtonOutlinedFocused = Color(0xFF1767F9);
  static const Color borderButtonOutlinedPressed = Color(0xFFC0C0C0);
  static const Color borderFocused = Color(0x331440B9); // Figma #1440b933
  static const Color borderButtonDangerFocused = Color(
    0x33D82027,
  ); // Figma #d8202733
  static const Color borderButtonSuccessFocused = Color(
    0x332C831B,
  ); // Figma #2c831b33
  static const Color borderButtonWarningFocused = Color(
    0x33FFB43F,
  ); // Figma #ffb43f33
  static const Color borderFormDefault = Color(0xFFE3E3E3);
  static const Color borderFormDanger = Color(0xFFD82027);

  // Profile dan Settings
  static const Color profileAccent = Color(0xFF0284C7);
  static const Color profileMutedText = Color(0xFF8293AD);
  static const Color profileMutedIcon = Color(0xFF91A2BB);
  static const Color profileDarkText = Color(0xFF172033);
  static const Color settingsDarkText = Color(0xFF343943);
  static const Color profileSoftBorder = Color(0xFFC8D4E3);
  static const Color profileDangerBackground = Color(0xFFFFF0F0);
  static const Color profileDangerText = Color(0xFFFF3030);
  static const Color settingsDangerButton = Color(0xFFFF3838);
  static const Color achievementGold = Color(0xFFF5B82E);
}
