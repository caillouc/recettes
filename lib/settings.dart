import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'package:recettes/main.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  void initState() {
    super.initState();
    settings.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
      child: SizedBox(
        height: 200,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Dark Mode : ",
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.brightness_4,
                      size: 30,
                      color: settings.isSystemMode()
                          ? Theme.of(context).primaryColor
                          : Colors.grey,
                    ),
                    onPressed: () {
                      settings.toggleSystemMode();
                    },
                    tooltip: 'System Theme',
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.dark_mode,
                      size: 30,
                      color: settings.isDarkMode()
                          ? Theme.of(context).primaryColor
                          : Colors.grey,
                    ),
                    onPressed: () {
                      settings.toggleDarkMode();
                    },
                    tooltip: 'Dark Mode',
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.light_mode,
                      size: 30,
                      color: settings.isLightMode()
                          ? Theme.of(context).primaryColor
                          : Colors.grey,
                    ),
                    onPressed: () {
                      settings.toggleLightMode();
                    },
                    tooltip: 'Light Mode',
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Historique : ",
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  Switch(
                      value: settings.showHistory(),
                      activeColor: Theme.of(context).primaryColor,
                      onChanged: (value) {
                        settings.setHistory(value);
                      },)
                ],
              ),
              const Divider(),
              Text(
                "Bugs, Nouvelles recettes, Questions :",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              GestureDetector(
                onTap: () async {
                  const url =
                      'mailto:recettes.gm@clsn.fr?subject=Bug, Nouvelle recette, Question&body=';
                  if (await canLaunchUrlString(url)) {
                    await launchUrlString(url);
                  } else {
                    throw 'Could not launch $url';
                  }
                },
                child: Text(
                  "recettes.gm@clsn.fr",
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: Theme.of(context).primaryColor,
                        // underline in color of primaryColor
                        decoration: TextDecoration.underline,
                        decorationColor: Theme.of(context).primaryColor,
                      ),
                ),
              ),
            ],
          ),
          // Contact message
        ),
      ),
    );
  }
}
