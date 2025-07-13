import 'package:flutter/material.dart';
import 'dart:io';
import '../../core/image_picker_widget.dart';

class ServiceProviderForm extends StatefulWidget {
  @override
  _ServiceProviderFormState createState() => _ServiceProviderFormState();
}

class _ServiceProviderFormState extends State<ServiceProviderForm> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedCategory;
  List<String> _selectedSubCategories = [];
  String? _experience;
  String? _citizenship;
  File? _citizenshipPhoto;
  File? _certificatePhoto;

  final Map<String, List<String>> _subCategories = {
    'Cleaning': [
      'House Cleaning',
      'Sofa Cleaning',
      'Office Cleaning',
      'Carpet Cleaning',
      'Window Cleaning',
      'Deep Cleaning',
      'Move-In/Move-Out Cleaning',
      'Post-Construction Cleaning',
    ],
    'Painting': [
      'Interior Painting',
      'Exterior Painting',
      'Furniture Painting',
      'Wall Texturing',
      'Cabinet Refinishing',
    ],
    'Plumbing': [
      'Pipe Repair',
      'Drain Cleaning',
      'Solar Fitting ',
      'Shower Fitting'
      'Water Tank Installation',
      'Leak Detection',
      'Washing Machine Installation',
      'Water Meter Installation',
      'Bathtub Fitting',
      'Water Filter Installation'
      ,
    ],
  };


  bool _isFormValid() {
    return _formKey.currentState!.validate() &&
        _selectedSubCategories.isNotEmpty &&
        _citizenshipPhoto != null &&
        _certificatePhoto != null;
  }

  void _showValidationError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red[600],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Service Provider Application',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.grey[800],
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.grey[800]),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              Container(
                padding: EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 6,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Join Our Service Network',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Please fill out the information below to apply as a service provider.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24.0),

              // Form Fields Container
              Container(
                padding: EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 6,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category Dropdown
                    Text(
                      'Service Category',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800],
                      ),
                    ),
                    SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        hintText: 'Select a category',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(color: Colors.blue[400]!, width: 2),
                        ),
                        filled: true,
                        fillColor: Colors.grey[50],
                      ),
                      value: _selectedCategory,
                      items: _subCategories.keys.map((String category) {
                        return DropdownMenuItem<String>(
                          value: category,
                          child: Text(category),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          _selectedCategory = newValue;
                          _selectedSubCategories = [];
                        });
                      },
                      validator: (value) => value == null ? 'Please select a category' : null,
                    ),
                    SizedBox(height: 24.0),

                    // Sub-Category Multi-Select
                    if (_selectedCategory != null) ...[
                      Text(
                        'Sub-Categories',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[800],
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Select all services you can provide',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      SizedBox(height: 12),
                      Container(
                        padding: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Column(
                          children: _subCategories[_selectedCategory]!.map((subCategory) {
                            return CheckboxListTile(
                              title: Text(
                                subCategory,
                                style: TextStyle(fontSize: 14),
                              ),
                              value: _selectedSubCategories.contains(subCategory),
                              onChanged: (bool? value) {
                                setState(() {
                                  if (value == true) {
                                    _selectedSubCategories.add(subCategory);
                                  } else {
                                    _selectedSubCategories.remove(subCategory);
                                  }
                                });
                              },
                              activeColor: Colors.blue[400],
                              controlAffinity: ListTileControlAffinity.leading,
                              contentPadding: EdgeInsets.symmetric(horizontal: 0),
                            );
                          }).toList(),
                        ),
                      ),
                      if (_selectedSubCategories.isEmpty)
                        Padding(
                          padding: EdgeInsets.only(top: 8.0),
                          child: Text(
                            'Please select at least one sub-category',
                            style: TextStyle(
                              color: Colors.red[600],
                              fontSize: 12,
                            ),
                          ),
                        ),
                      SizedBox(height: 24.0),
                    ],

                    // Experience Input
                    Text(
                      'Years of Experience',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800],
                      ),
                    ),
                    SizedBox(height: 8),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Enter years of experience',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(color: Colors.blue[400]!, width: 2),
                        ),
                        filled: true,
                        fillColor: Colors.grey[50],
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) => _experience = value,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your experience';
                        }
                        if (int.tryParse(value) == null || int.parse(value) < 0) {
                          return 'Please enter a valid number';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 24.0),

                    // Citizenship Input
                    Text(
                      'Citizenship Number',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800],
                      ),
                    ),
                    SizedBox(height: 8),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Enter your citizenship number',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(color: Colors.blue[400]!, width: 2),
                        ),
                        filled: true,
                        fillColor: Colors.grey[50],
                      ),
                      onChanged: (value) => _citizenship = value,
                      validator: (value) => value == null || value.isEmpty ? 'Please enter citizenship number' : null,
                    ),
                    SizedBox(height: 24.0),

                    // Citizenship Photo
                    // ImagePickerWidget(
                    //   title: 'Citizenship Photo',
                    //   subtitle: 'Upload a clear photo of your citizenship document',
                    //   onImageSelected: (File? image) {
                    //     setState(() {
                    //       _citizenshipPhoto = image;
                    //     });
                    //   },
                    //   initialImage: _citizenshipPhoto,
                    // ),
                    // SizedBox(height: 24.0),

                    // Certificate Photo
                    ImagePickerWidget(
                      title: 'Certificate/Citizenship Document',
                      subtitle: 'Upload a photo of your relevant certificates or qualifications',
                      onImageSelected: (File? image) {
                        setState(() {
                          _certificatePhoto = image;
                        });
                      },
                      initialImage: _certificatePhoto,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 32.0),

              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      if (_selectedSubCategories.isEmpty) {
                        _showValidationError('Please select at least one sub-category');
                        return;
                      }
                      if (_citizenshipPhoto == null) {
                        _showValidationError('Please upload your citizenship photo');
                        return;
                      }
                      if (_certificatePhoto == null) {
                        _showValidationError('Please upload your certificate photo');
                        return;
                      }

                      // Process form data
                      print({
                        'category': _selectedCategory,
                        'subCategories': _selectedSubCategories,
                        'experience': _experience,
                        'citizenship': _citizenship,
                       // 'citizenshipPhoto': _citizenshipPhoto?.path,
                        'certificatePhoto': _certificatePhoto?.path,
                      });

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Application submitted successfully!'),
                          backgroundColor: Colors.green[600],
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[600],
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    elevation: 2,
                  ),
                  child: Text(
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

