import 'package:flutter/material.dart';

const primaryviolet = Color(0xFF50295C);
const secondaryblue = Color(0xFF003355);

CustomColors lightCustomColors = const CustomColors(
  sourcePrimaryviolet: Color(0xFF50295C),
  primaryviolet: Color(0xFF814792),
  onPrimaryviolet: Color(0xFFFFFFFF),
  primaryvioletContainer: Color(0xFFFAD7FF),
  onPrimaryvioletContainer: Color(0xFF330044),
  sourceSecondaryblue: Color(0xFF003355),
  secondaryblue: Color(0xFF00629D),
  onSecondaryblue: Color(0xFFFFFFFF),
  secondaryblueContainer: Color(0xFFCFE5FF),
  onSecondaryblueContainer: Color(0xFF001D34),
);

CustomColors darkCustomColors = const CustomColors(
  sourcePrimaryviolet: Color(0xFF50295C),
  primaryviolet: Color(0xFFF0B0FF),
  onPrimaryviolet: Color(0xFF4D1660),
  primaryvioletContainer: Color(0xFF662F78),
  onPrimaryvioletContainer: Color(0xFFFAD7FF),
  sourceSecondaryblue: Color(0xFF003355),
  secondaryblue: Color(0xFF99CBFF),
  onSecondaryblue: Color(0xFF003355),
  secondaryblueContainer: Color(0xFF004A78),
  onSecondaryblueContainer: Color(0xFFCFE5FF),
);

/// Defines a set of custom colors, each comprised of 4 complementary tones.
///
/// See also:
///   * <https://m3.material.io/styles/color/the-color-system/custom-colors>
@immutable
class CustomColors extends ThemeExtension<CustomColors> {
  const CustomColors({
    required this.sourcePrimaryviolet,
    required this.primaryviolet,
    required this.onPrimaryviolet,
    required this.primaryvioletContainer,
    required this.onPrimaryvioletContainer,
    required this.sourceSecondaryblue,
    required this.secondaryblue,
    required this.onSecondaryblue,
    required this.secondaryblueContainer,
    required this.onSecondaryblueContainer,
  });

  final Color? sourcePrimaryviolet;
  final Color? primaryviolet;
  final Color? onPrimaryviolet;
  final Color? primaryvioletContainer;
  final Color? onPrimaryvioletContainer;
  final Color? sourceSecondaryblue;
  final Color? secondaryblue;
  final Color? onSecondaryblue;
  final Color? secondaryblueContainer;
  final Color? onSecondaryblueContainer;

  @override
  CustomColors copyWith({
    Color? sourcePrimaryviolet,
    Color? primaryviolet,
    Color? onPrimaryviolet,
    Color? primaryvioletContainer,
    Color? onPrimaryvioletContainer,
    Color? sourceSecondaryblue,
    Color? secondaryblue,
    Color? onSecondaryblue,
    Color? secondaryblueContainer,
    Color? onSecondaryblueContainer,
  }) {
    return CustomColors(
      sourcePrimaryviolet: sourcePrimaryviolet ?? this.sourcePrimaryviolet,
      primaryviolet: primaryviolet ?? this.primaryviolet,
      onPrimaryviolet: onPrimaryviolet ?? this.onPrimaryviolet,
      primaryvioletContainer:
          primaryvioletContainer ?? this.primaryvioletContainer,
      onPrimaryvioletContainer:
          onPrimaryvioletContainer ?? this.onPrimaryvioletContainer,
      sourceSecondaryblue: sourceSecondaryblue ?? this.sourceSecondaryblue,
      secondaryblue: secondaryblue ?? this.secondaryblue,
      onSecondaryblue: onSecondaryblue ?? this.onSecondaryblue,
      secondaryblueContainer:
          secondaryblueContainer ?? this.secondaryblueContainer,
      onSecondaryblueContainer:
          onSecondaryblueContainer ?? this.onSecondaryblueContainer,
    );
  }

  @override
  CustomColors lerp(ThemeExtension<CustomColors>? other, double t) {
    if (other is! CustomColors) {
      return this;
    }
    return CustomColors(
      sourcePrimaryviolet:
          Color.lerp(sourcePrimaryviolet, other.sourcePrimaryviolet, t),
      primaryviolet: Color.lerp(primaryviolet, other.primaryviolet, t),
      onPrimaryviolet: Color.lerp(onPrimaryviolet, other.onPrimaryviolet, t),
      primaryvioletContainer:
          Color.lerp(primaryvioletContainer, other.primaryvioletContainer, t),
      onPrimaryvioletContainer: Color.lerp(
          onPrimaryvioletContainer, other.onPrimaryvioletContainer, t),
      sourceSecondaryblue:
          Color.lerp(sourceSecondaryblue, other.sourceSecondaryblue, t),
      secondaryblue: Color.lerp(secondaryblue, other.secondaryblue, t),
      onSecondaryblue: Color.lerp(onSecondaryblue, other.onSecondaryblue, t),
      secondaryblueContainer:
          Color.lerp(secondaryblueContainer, other.secondaryblueContainer, t),
      onSecondaryblueContainer: Color.lerp(
          onSecondaryblueContainer, other.onSecondaryblueContainer, t),
    );
  }

  /// Returns an instance of [CustomColors] in which the following custom
  /// colors are harmonized with [dynamic]'s [ColorScheme.primary].
  ///
  /// See also:
  ///   * <https://m3.material.io/styles/color/the-color-system/custom-colors#harmonization>
  CustomColors harmonized(ColorScheme dynamic) {
    return copyWith();
  }
}
