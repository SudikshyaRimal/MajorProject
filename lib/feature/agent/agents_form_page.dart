import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AgentsFormPage extends StatefulWidget {
  const AgentsFormPage({super.key});

  @override
  State<AgentsFormPage> createState() => _AgentsFormPageState();
}

class _AgentsFormPageState extends State<AgentsFormPage> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedServiceType;
  String? _selectedSubServiceType;
  final TextEditingController _experienceController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  // Sample service types and sub-service types (in a real app, fetch from a data source)
  final Map<String, List<String>> _serviceData = {
    'Plumbing': ['Pipe Repair', 'Drain Cleaning', 'Fixture Installation'],
    'Electrical': ['Wiring', 'Lighting Installation', 'Circuit Repair'],
    'HVAC': ['AC Servicing', 'Heating Repair', 'Ventilation Maintenance'],
    'Cleaning': ['House Cleaning', 'Deep Cleaning', 'Carpet Cleaning'],
    'Repair': ['Appliance Repair', 'Furniture Repair', 'Gadget Repair'],
    'Gardening': ['Lawn Mowing', 'Tree Trimming', 'Garden Design'],
  };

  List<String> get _subServiceTypes =>
      _selectedServiceType != null ? _serviceData[_selectedServiceType]! : [];

  @override
  void dispose() {
    _experienceController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // In a real app, send the form data to a backend
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Application submitted successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      // Optionally, clear form or navigate back
      _formKey.currentState!.reset();
      setState(() {
        _selectedServiceType = null;
        _selectedSubServiceType = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Join as Service Provider'),
        backgroundColor: Colors.blue[600],
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Service Type
              const Text(
                'Service Type',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _selectedServiceType,
                decoration: InputDecoration(
                  labelText: 'Select Service Type',
                  labelStyle: TextStyle(color: Colors.grey[600]),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: Icon(Icons.build, color: Colors.blue[600]),
                ),
                items: _serviceData.keys
                    .map((type) => DropdownMenuItem<String>(
                  value: type,
                  child: Text(type),
                ))
                    .toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedServiceType = newValue;
                    _selectedSubServiceType = null; // Reset sub-service type
                  });
                },
                validator: (value) =>
                value == null ? 'Please select a service type' : null,
              ),
              const SizedBox(height: 16),
              // Sub-Service Type
              const Text(
                'Sub-Service Type',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _selectedSubServiceType,
                decoration: InputDecoration(
                  labelText: 'Select Sub-Service Type',
                  labelStyle: TextStyle(color: Colors.grey[600]),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: Icon(Icons.category, color: Colors.blue[600]),
                ),
                items: _subServiceTypes
                    .map((subType) => DropdownMenuItem<String>(
                  value: subType,
                  child: Text(subType),
                ))
                    .toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedSubServiceType = newValue;
                  });
                },
                validator: (value) =>
                value == null ? 'Please select a sub-service type' : null,
              ),
              const SizedBox(height: 16),
              // Experience
              const Text(
                'Experience',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _experienceController,
                decoration: InputDecoration(
                  labelText: 'Years of Experience',
                  labelStyle: TextStyle(color: Colors.grey[600]),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: Icon(Icons.work_history, color: Colors.blue[600]),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your experience';
                  }
                  final years = int.tryParse(value);
                  if (years == null || years < 0) {
                    return 'Please enter a valid number of years';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Price
              const Text(
                'Price',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(
                  labelText: 'Price (e.g., Rs. 500/hour)',
                  labelStyle: TextStyle(color: Colors.grey[600]),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: Icon(Icons.attach_money, color: Colors.blue[600]),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your price';
                  }
                  // if () {
                  //   return 'Please enter a valid price (e.g., Rs. 500/hour)';
                  // }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[600],
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Submit Application',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}