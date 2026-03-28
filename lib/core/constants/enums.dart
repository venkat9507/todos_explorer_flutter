/// Network connectivity status.
enum NetworkStatus { connected, disconnected }

/// Todo filter options (All / Completed / Pending / Favorites).
enum TodoFilter { all, completed, pending, favorites }

/// Todo sort options.
enum TodoSort {
  titleAZ,
  titleZA,
  completedFirst,
  pendingFirst,
  idLowToHigh,
  idHighToLow,
}

/// Device screen categories based on width.
enum ScreenType {
  phone, // < 600px
  tablet, // 600–900px
  desktop; // > 900px

  static ScreenType fromWidth(double width) {
    if (width >= 900) return ScreenType.desktop;
    if (width >= 600) return ScreenType.tablet;
    return ScreenType.phone;
  }

  bool get isPhone => this == ScreenType.phone;
  bool get isTablet => this == ScreenType.tablet;
  bool get isDesktop => this == ScreenType.desktop;
  bool get isWide => this != ScreenType.phone;
}
