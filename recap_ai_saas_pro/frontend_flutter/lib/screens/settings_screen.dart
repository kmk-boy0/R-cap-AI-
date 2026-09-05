import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  final bool initialUncensoredMode;
  final ValueChanged<bool>? onUncensoredModeChanged;

  const SettingsScreen({
    Key? key,
    this.initialUncensoredMode = false,
    this.onUncensoredModeChanged,
  }) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late bool _isUncensoredMode;

  @override
  void initState() {
    super.initState();
    _isUncensoredMode = widget.initialUncensoredMode;
  }

  void _toggleUncensoredMode(bool value) {
    setState(() {
      _isUncensoredMode = value;
    });
    if (widget.onUncensoredModeChanged != null) {
      widget.onUncensoredModeChanged!(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Paramètres / Sécurité'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            _isUncensoredMode ? Icons.lock_open : Icons.lock,
                            color: _isUncensoredMode ? Colors.redAccent : Colors.green,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            _isUncensoredMode ? 'Mode Non-Censuré (Uncensored)' : 'Mode Censuré (Censored)',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Switch(
                        value: _isUncensoredMode,
                        activeColor: Colors.redAccent,
                        onChanged: _toggleUncensoredMode,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _isUncensoredMode
                        ? 'Le contenu visuel et textuel est affiché dans son intégralité sans aucun masque ni restriction de modération LLM.'
                        : 'Les images comportent un flou artistique / masquage dynamique. Les passages explicites des résumés sont balisés.',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
