import 'package:flutter/material.dart';
import '../../../l10n/generated/app_localizations.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  static const String _appName = 'મારી રોજમેલ';
  static const String _appVersion = 'v1.0.0';
  static const String _developerName = 'Ravi Varsani';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.about)),
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
                AppLocalizations.of(context)!.versionLabel(_appVersion),
                style: theme.textTheme.bodyMedium,
              ),
            ),

            const SizedBox(height: 8),

            Center(
              child: Text(
                AppLocalizations.of(context)!.appTagline,
                style: theme.textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ),

            const SizedBox(height: 32),

            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.person_outline),
                    title: Text(AppLocalizations.of(context)!.developer),
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
                    title: Text(AppLocalizations.of(context)!.privacyPolicy),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {},
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.description_outlined),
                    title: Text(AppLocalizations.of(context)!.termsConditions),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {},
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.share_outlined),
                    title: Text(AppLocalizations.of(context)!.shareApp),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {},
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.star_outline),
                    title: Text(AppLocalizations.of(context)!.rateApp),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {},
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            Center(
              child: Text(
                AppLocalizations.of(context)!.copyright,
                style: theme.textTheme.bodySmall,
              ),
            ),

            const SizedBox(height: 4),

            Center(
              child: Text(
                AppLocalizations.of(context)!.madeInIndia,
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
