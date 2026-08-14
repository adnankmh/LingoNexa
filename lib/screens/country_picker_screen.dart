import 'package:flutter/material.dart';

import '../core/app_state.dart';
import '../data/country_catalog.dart';

class CountryPickerScreen extends StatefulWidget {
  const CountryPickerScreen({super.key});

  @override
  State<CountryPickerScreen> createState() => _CountryPickerScreenState();
}

class _CountryPickerScreenState extends State<CountryPickerScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    final query = _query.trim().toLowerCase();
    final countries = CountryCatalog.all
        .where((country) => query.isEmpty ||
            country.name.toLowerCase().contains(query) ||
            country.code.toLowerCase().contains(query))
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Country & flag')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
                child: TextField(
                  onChanged: (value) => setState(() => _query = value),
                  decoration: const InputDecoration(
                    hintText: 'Search countries…',
                    prefixIcon: Icon(Icons.search_rounded),
                  ),
                ),
              ),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 24),
                  itemCount: countries.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final country = countries[index];
                    final selected = state.countryCode == country.code;
                    return ListTile(
                      leading: Text(country.flag,
                          style: const TextStyle(fontSize: 27)),
                      title: Text(country.name,
                          style: const TextStyle(fontWeight: FontWeight.w800)),
                      subtitle: Text(country.code),
                      trailing: selected
                          ? const Icon(Icons.check_circle_rounded)
                          : null,
                      onTap: () async {
                        await state.setCountryCode(country.code);
                        if (context.mounted) Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
