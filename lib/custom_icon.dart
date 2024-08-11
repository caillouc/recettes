import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum CustomIcon {
  favorite,
  history,
  home,
  search,
  list,
  meat,
  fish,
  carrot,
  dessert,
  apero,
  bread,
  other;

  Widget iconConstructor(String path, Color color, {double size = 25.0}) {
    return SvgPicture.asset(
      path,
      width: size,
      height: size,
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
    );
  }

  // create map for icon to color
  static final Map<CustomIcon, Color> _iconColor = {
    CustomIcon.favorite: Colors.amber,
    CustomIcon.history:Colors.black,
    CustomIcon.home: Colors.black,
    CustomIcon.search: Colors.black,
    CustomIcon.list: Colors.black,
    CustomIcon.meat: Colors.red,
    CustomIcon.fish: Colors.blue,
    CustomIcon.carrot: Colors.green,
    CustomIcon.dessert: Colors.purple,
    CustomIcon.apero: Colors.orange,
    CustomIcon.bread: Colors.brown,
    CustomIcon.other: Colors.black,
  };

  static final Map<CustomIcon, String> _iconBaseName = {
    CustomIcon.favorite: 'star',
    CustomIcon.history: 'folder-magnifying-glass',
    CustomIcon.home: 'home',
    CustomIcon.search: 'magnifying-glass',
    CustomIcon.list: 'list',
    CustomIcon.meat: 'meat',
    CustomIcon.fish: 'fish',
    CustomIcon.carrot: 'carrot',
    CustomIcon.dessert: 'ice-cream',
    CustomIcon.apero: 'champagne-glasses',
    CustomIcon.bread: 'bread-loaf',
    CustomIcon.other: 'utensils',
  };

  String _getRegularPath() {
    return 'assets/icons/regular_${_iconBaseName[this]}.svg';
  }

  String _getSolidPath() {
    return 'assets/icons/${_iconBaseName[this]}.svg';
  }

  Widget getColorSolidIcon(BuildContext context) {
    if (Theme.of(context).brightness == Brightness.dark && _iconColor[this] == Colors.black) {
      return iconConstructor(_getSolidPath(), Colors.white);
    }
    return iconConstructor(_getSolidPath(), _iconColor[this]!);
  }

  Widget getColorOutlinedIcon(BuildContext context) {
    if (Theme.of(context).brightness == Brightness.dark && _iconColor[this] == Colors.black) {
      return iconConstructor(_getRegularPath(), Colors.white);
    }
    return iconConstructor(_getRegularPath(), _iconColor[this]!);
  }

  Widget getColorSolidBigIcon(BuildContext context) {
    if (Theme.of(context).brightness == Brightness.dark && _iconColor[this] == Colors.black) {
      return iconConstructor(_getSolidPath(), Colors.white, size: 50.0);
    }
    return iconConstructor(_getSolidPath(), _iconColor[this]!, size: 50.0);
  }

  Widget getColorOutlinedBigIcon(BuildContext context) {
    if (Theme.of(context).brightness == Brightness.dark && _iconColor[this] == Colors.black) {
      return iconConstructor(_getSolidPath(), Colors.white, size: 50.0);
    }
    return iconConstructor(_getRegularPath(), _iconColor[this]!, size: 50.0);
  }

  Widget getBlackSolidIcon(BuildContext context) {
    // if (Theme.of(context).brightness == Brightness.dark) {
    //   return iconConstructor(_getSolidPath(), Colors.white);
    // }
    return iconConstructor(_getSolidPath(), Colors.black);
  }

  Widget getBlackOutlinedIcon(BuildContext context) {
    if (Theme.of(context).brightness == Brightness.dark) {
      return iconConstructor(_getRegularPath(), Colors.white);
    }
    return iconConstructor(_getRegularPath(), Colors.black);
  }
}
