import 'package:flutter/material.dart';

class Ayarlar extends StatefulWidget {
  const Ayarlar({Key? key}) : super(key: key);

  @override
  State<Ayarlar> createState() => _AyarlarState();
}

class _AyarlarState extends State<Ayarlar> {
  bool _notificationsEnabled = true;
  bool _syncDataEnabled = true;
  String _selectedLanguage = 'English';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios_new_rounded),
        ),
        title: Text('Settings'),
        backgroundColor: const Color.fromARGB(255, 10, 61, 113),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          SwitchListTile(
            title: const Text('Notifications'),
            value: _notificationsEnabled,
            onChanged: (value) {
              setState(() {
                _notificationsEnabled = value;
                // Here you can turn notifications on or off.
              });
            },
          ),
          SwitchListTile(
            title: const Text('Sync Data'),
            value: _syncDataEnabled,
            onChanged: (value) {
              setState(() {
                _syncDataEnabled = value;
                // Here you can turn data synchronization on or off.
              });
            },
          ),
          ListTile(
            title: const Text('Language'),
            subtitle: Text(_selectedLanguage),
            onTap: () async {
              String? language = await _showLanguageDialog();
              if (language != null) {
                setState(() {
                  _selectedLanguage = language;
                  // Changing the language option can be done here.
                });
              }
            },
          ),
        ],
      ),
    );
  }

  Future<String?> _showLanguageDialog() async {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Language'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                ListTile(
                  title: const Text('English'),
                  onTap: () {
                    Navigator.pop(context, 'English');
                  },
                ),
                ListTile(
                  title: const Text('Türkçe'),
                  onTap: () {
                    Navigator.pop(context, 'Türkçe');
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
