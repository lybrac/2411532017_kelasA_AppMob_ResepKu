import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resepku/providers/theme_provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // watch: nilai switch harus ikut berubah saat tema berubah
    final isDark = context.watch<ThemeProvider>().isDark;

    return Scaffold(
      appBar: AppBar(title: const Text('Pengaturan')),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Mode gelap'),
            subtitle: const Text('Ubah tampilan seluruh aplikasi'),
            secondary: Icon(isDark ? Icons.dark_mode : Icons.light_mode),
            value: isDark,
            // read: di dalam callback cukup memanggil method
            onChanged: (value) =>
                context.read<ThemeProvider>().setDarkMode(value),
          ),
        ],
      ),
    );
  }
}
