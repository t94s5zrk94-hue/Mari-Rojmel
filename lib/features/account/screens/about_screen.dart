import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  static const String _appName = 'મારી રોજમેલ';
  static const String _appVersion = 'v1.0.0';
  static const String _developerName = 'Ravi Varsani';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('About')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const SizedBox(height: 16),

            CircleAvatar(
              radius: 42,
              backgroundColor: theme.colorScheme.primaryContainer,
              child: Icon(
                Icons.account_balance_wallet,
                size: 42,
                color: theme.colorScheme.primary,
              ),
            ),

            const SizedBox(height: 16),

            Center(
              child: Text(
                _appName,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 8),

            Center(
              child: Text(
                'Version $_appVersion',
                style: theme.textTheme.bodyMedium,
              ),
            ),

            const SizedBox(height: 8),

            Center(
              child: Text(
                'Gujarati Digital Expense & Income Manager',
                style: theme.textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ),

            const SizedBox(height: 32),

            Card(
              child: Column(
                children: const [
                  ListTile(
                    leading: Icon(Icons.person_outline),
                    title: Text('Developer'),
                    subtitle: Text(_developerName),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.privacy_tip_outlined),
                    title: const Text('Privacy Policy'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {},
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.description_outlined),
                    title: const Text('Terms & Conditions'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {},
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.share_outlined),
                    title: const Text('Share App'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {},
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.star_outline),
                    title: const Text('Rate App'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {},
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            Center(
              child: Text(
                '© 2026 Mari-Rojmel',
                style: theme.textTheme.bodySmall,
              ),
            ),

            const SizedBox(height: 4),

            Center(
              child: Text(
                'Made with ❤️ in India',
                style: theme.textTheme.bodySmall,
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
