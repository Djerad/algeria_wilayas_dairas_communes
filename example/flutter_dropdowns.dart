// Flutter usage: wilaya dropdown -> commune dropdown.
import 'package:algeria_cities/algeria_cities.dart';
import 'package:flutter/material.dart';

class WilayaCommunePicker extends StatefulWidget {
  const WilayaCommunePicker({super.key});
  @override
  State<WilayaCommunePicker> createState() => _State();
}

class _State extends State<WilayaCommunePicker> {
  Wilaya? _wilaya;
  Commune? _commune;

  @override
  Widget build(BuildContext context) {
    final communes =
        _wilaya == null ? <Commune>[] : AlgeriaCities.communesOf(_wilaya!.code);
    return Column(children: [
      DropdownButton<Wilaya>(
        hint: const Text('Wilaya'),
        value: _wilaya,
        isExpanded: true,
        items: AlgeriaCities.wilayas
            .map((w) => DropdownMenuItem(
                value: w, child: Text('${w.code} - ${w.name}')))
            .toList(),
        onChanged: (w) => setState(() {
          _wilaya = w;
          _commune = null;
        }),
      ),
      DropdownButton<Commune>(
        hint: const Text('Commune'),
        value: _commune,
        isExpanded: true,
        items: communes
            .map((c) => DropdownMenuItem(value: c, child: Text(c.name)))
            .toList(),
        onChanged: (c) => setState(() => _commune = c),
      ),
    ]);
  }
}
