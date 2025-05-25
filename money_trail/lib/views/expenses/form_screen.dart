import 'package:flutter/material.dart';
import 'package:money_trail/core/services/api_client.dart';
import 'package:provider/provider.dart';

class FormScreen extends StatefulWidget {
  const FormScreen({Key? key}) : super(key: key);

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _shopController = TextEditingController();
  final _otherCategoryController = TextEditingController();
  String? _selectedCategory;
  DateTime? _selectedDate;

  final List<String> _categories = [
    'Groceries',
    'Dining',
    'Transport',
    'Utilities',
    'Entertainment',
    'Health',
    'Rent',
    'Education',
    'Shopping',
    'Others',
  ];

  @override
  void dispose() {
    _amountController.dispose();
    _shopController.dispose();
    _otherCategoryController.dispose();
    super.dispose();
  }

  Future<void> _submitExpense() async {
    if (_formKey.currentState?.validate() ?? false) {
      final category = _selectedCategory == 'Others'
          ? _otherCategoryController.text.trim()
          : _selectedCategory;

      final expenseData = {
        'amount': double.parse(_amountController.text.trim()),
        'shop_name': _shopController.text.trim(),
        'purpose': category,
        'timestamp': _selectedDate?.toIso8601String(),
      };

      try {
        final apiClient = context.read<ApiClient>();
        final response = await apiClient.post('/expenses/manual', expenseData);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Expense submitted successfully!')),
        );

        // Clear form
        _formKey.currentState?.reset();
        setState(() {
          _selectedCategory = null;
          _selectedDate = null;
          _otherCategoryController.clear();
        });
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
      }
    }
  }

  Future<void> _pickDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Expense Form')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Amount'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the amount';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _shopController,
                decoration: const InputDecoration(labelText: 'Shop Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the shop name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                items: _categories
                    .map(
                      (category) => DropdownMenuItem(
                        value: category,
                        child: Text(category),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value;
                  });
                },
                decoration: const InputDecoration(labelText: 'Category'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a category';
                  }
                  return null;
                },
              ),
              if (_selectedCategory == 'Others') ...[
                const SizedBox(height: 16),
                TextFormField(
                  controller: _otherCategoryController,
                  decoration: const InputDecoration(
                    labelText: 'Specify Category',
                  ),
                  validator: (value) {
                    if (_selectedCategory == 'Others' &&
                        (value == null || value.isEmpty)) {
                      return 'Please specify the category';
                    }
                    return null;
                  },
                ),
              ],
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _selectedDate == null
                          ? 'No date selected'
                          : 'Date: ${_selectedDate!.toLocal()}'.split(' ')[0],
                    ),
                  ),
                  TextButton(
                    onPressed: _pickDate,
                    child: const Text('Select Date'),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submitExpense,
                child: const Text('Submit Expense'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
