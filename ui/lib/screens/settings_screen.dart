import 'package:flutter/material.dart';

import '../services/user_settings_service.dart';
import '../themes/input_decorations.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _instructionsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<Map<String, dynamic>>(
          future: UserSettingService().getSettings(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Return a loader widget
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              // Return an error widget
              return const Center(child: Text('Error loading settings'));
            } else {
              _instructionsController.text =
                  snapshot.data?['settings']['instructions'] ?? '';
              return _buildForm(
                context,
                _formKey,
                _instructionsController,
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildForm(
    BuildContext context,
    GlobalKey<FormState> formKey,
    TextEditingController instructionsController,
  ) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                TextFormField(
                  controller: instructionsController,
                  maxLines: 15, // Adjust this value as required
                  decoration: blueInputDecoration(
                    label: 'Custom Instructions (1500 characters max)',
                    icon: Icons.info,
                  ),
                  validator: (value) {
                    if (value!.length > 1500) {
                      return 'Instructions must be less than 1500 characters';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 20.0),
          SizedBox(
            width: double.infinity,
            height: 60,
            child: ElevatedButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  bool success = await UserSettingService().sendInstructions({
                    'instructions': instructionsController.text,
                  });
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (success) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Instructions sent successfully'),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Error sending instructions'),
                        ),
                      );
                    }
                    Navigator.pop(context);
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueGrey,
                padding: const EdgeInsets.symmetric(vertical: 16.0),
              ),
              child: const Text(
                'Submit',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
