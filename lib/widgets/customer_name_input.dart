import 'package:flutter/material.dart';

class CustomerNameInput extends StatefulWidget {
  final Function(String) onNameSubmitted;

  const CustomerNameInput({
    super.key,
    required this.onNameSubmitted,
  });

  @override
  State<CustomerNameInput> createState() => _CustomerNameInputState();
}

class _CustomerNameInputState extends State<CustomerNameInput> {
  final TextEditingController _nameController = TextEditingController();
  final FocusNode _nameFocusNode = FocusNode();

  @override
  void dispose() {
    _nameController.dispose();
    _nameFocusNode.dispose();
    super.dispose();
  }

  void _submitName() {
    final name = _nameController.text.trim();
    if (name.isNotEmpty) {
      widget.onNameSubmitted(name);
      _nameController.clear();
      _nameFocusNode.requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'إضافة إلى قائمة الانتظار',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _nameController,
              focusNode: _nameFocusNode,
              decoration: const InputDecoration(
                labelText: 'أدخل اسمك',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _submitName(),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _submitName,
              icon: const Icon(Icons.add),
              label: const Text('الانضمام إلى قائمة الانتظار'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueGrey.shade700,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

