import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

// Model for Service
class Service {
  final String id;
  final String name;
  final List<SubService> subServices;

  Service({required this.id, required this.name, required this.subServices});
}

// Model for SubService
class SubService {
  final String id;
  final String name;
  final String serviceId;

  SubService({required this.id, required this.name, required this.serviceId});
}

class ProfileCreationPage extends StatefulWidget {
  const ProfileCreationPage({super.key});

  @override
  State<ProfileCreationPage> createState() => _ProfileCreationPageState();
}

class _ProfileCreationPageState extends State<ProfileCreationPage> {
  int _currentStep = 0;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  Service? _selectedService;
  SubService? _selectedSubService;
  final TextEditingController _experienceController = TextEditingController();
  String? _selectedPricingType;
  final TextEditingController _priceController = TextEditingController();

  // Sample data for services and sub-services
  final List<Service> _services = [
    Service(
      id: '1',
      name: 'Painting',
      subServices: [
        SubService(id: '1a', name: 'Wall Painting', serviceId: '1'),
        SubService(id: '1b', name: 'Furniture Painting', serviceId: '1'),
      ],
    ),
    Service(
      id: '2',
      name: 'Cleaning',
      subServices: [
        SubService(id: '2a', name: 'House Cleaning', serviceId: '2'),
        SubService(id: '2b', name: 'Office Cleaning', serviceId: '2'),
      ],
    ),
  ];

  final List<String> _pricingTypes = ['Per Hour', 'Per Day', 'Per Project'];

  // API call to save profile
  Future<bool> _saveProfile() async {
    final url = Uri.parse('https://api.example.com/provider/profile');
    final body = {
      'name': _nameController.text,
      'serviceId': _selectedService?.id,
      'subServiceId': _selectedSubService?.id,
      'experience': _experienceController.text,
      'pricingType': _selectedPricingType,
      'price': _priceController.text,
    };

    try {
      // final response = await Dio().post(
      //   url,
      //   headers: {'Content-Type': 'application/json'},
      //   body: json.encode(body),
      // );
      // if (response.statusCode == 201) {
      //   print('Profile saved successfully');
      //   return true;
      // } else {
      //   print('Failed to save profile: ${response.body}');
      //   return false;
      // }

      return true;
    } catch (e) {
      print('Error saving profile: $e');
      return false;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _experienceController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Your Profile'),
        backgroundColor: Colors.blue[600],
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: Stepper(
          currentStep: _currentStep,
          onStepContinue: () {
            if (_currentStep == 0 && _nameController.text.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Please enter your name')),
              );
              return;
            }
            if (_currentStep == 1 && _selectedService == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Please select a service')),
              );
              return;
            }
            if (_currentStep == 2 && _selectedSubService == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Please select a sub-service')),
              );
              return;
            }
            if (_currentStep == 3 && _experienceController.text.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Please enter your experience')),
              );
              return;
            }
            if (_currentStep == 4 && (_selectedPricingType == null || _priceController.text.isEmpty)) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Please select pricing type and enter price')),
              );
              return;
            }
            if (_currentStep < 4) {
              setState(() {
                _currentStep += 1;
              });
            } else {
              _saveProfile().then((success) {
                if (success) {
                  Navigator.pop(context); // Navigate back or to a success screen
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Profile created successfully!')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Failed to create profile')),
                  );
                }
              });
            }
          },
          onStepCancel: () {
            if (_currentStep > 0) {
              setState(() {
                _currentStep -= 1;
              });
            }
          },
          steps: [
            Step(
              title: const Text('Enter Your Name'),
              content: TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Full Name',
                  prefixIcon: Icon(Icons.person, color: Colors.blue[600]),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              isActive: _currentStep >= 0,
            ),
            Step(
              title: const Text('Select Service'),
              content: DropdownButtonFormField<Service>(
                value: _selectedService,
                decoration: InputDecoration(
                  labelText: 'Service',
                  prefixIcon: Icon(Icons.build, color: Colors.blue[600]),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                items: _services.map((service) {
                  return DropdownMenuItem<Service>(
                    value: service,
                    child: Text(service.name),
                  );
                }).toList(),
                onChanged: (Service? newValue) {
                  setState(() {
                    _selectedService = newValue;
                    _selectedSubService = null; // Reset sub-service when service changes
                  });
                },
              ),
              isActive: _currentStep >= 1,
            ),
            Step(
              title: const Text('Select Sub-Service'),
              content: DropdownButtonFormField<SubService>(
                value: _selectedSubService,
                decoration: InputDecoration(
                  labelText: 'Sub-Service',
                  prefixIcon: Icon(Icons.category, color: Colors.blue[600]),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                items: _selectedService?.subServices.map((subService) {
                  return DropdownMenuItem<SubService>(
                    value: subService,
                    child: Text(subService.name),
                  );
                }).toList() ?? [],
                onChanged: (SubService? newValue) {
                  setState(() {
                    _selectedSubService = newValue;
                  });
                },
              ),
              isActive: _currentStep >= 2,
            ),
            Step(
              title: const Text('Years of Experience'),
              content: TextFormField(
                controller: _experienceController,
                decoration: InputDecoration(
                  labelText: 'Years of Experience',
                  prefixIcon: Icon(Icons.work_history, color: Colors.blue[600]),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                keyboardType: TextInputType.number,
              ),
              isActive: _currentStep >= 3,
            ),
            Step(
              title: const Text('Set Pricing'),
              content: Column(
                children: [
                  DropdownButtonFormField<String>(
                    value: _selectedPricingType,
                    decoration: InputDecoration(
                      labelText: 'Pricing Type',
                      prefixIcon: Icon(Icons.attach_money, color: Colors.blue[600]),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    items: _pricingTypes.map((type) {
                      return DropdownMenuItem<String>(
                        value: type,
                        child: Text(type),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedPricingType = newValue;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _priceController,
                    decoration: InputDecoration(
                      labelText: 'Price (e.g., 500)',
                      prefixIcon: Icon(Icons.price_check, color: Colors.blue[600]),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ],
              ),
              isActive: _currentStep >= 4,
            ),
          ],
        ),
      ),
    );
  }
}