import 'package:flutter/material.dart';

class AddListingScreen extends StatefulWidget {
  const AddListingScreen({Key? key}) : super(key: key);

  @override
  State<AddListingScreen> createState() => _AddListingScreenState();
}

class _AddListingScreenState extends State<AddListingScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Form controllers
  final TextEditingController _cropNameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _wantsController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  
  // Form values
  String? _selectedCropType;
  String? _selectedQuality = 'Medium';
  String? _selectedUnit = 'kg';
  bool _isOrganic = false;
  String? _selectedLocation;
  
  // Image placeholder
  String? _selectedImage;

  // Crop types
  final List<String> _cropTypes = [
    'Maize',
    'Beans',
    'Groundnuts',
    'Pigeon Peas',
    'Sorghum',
    'Millet',
    'Cassava',
    'Sweet Potato',
    'Rice',
    'Soybean',
    'Cowpea',
    'Pumpkin',
    'Tomato',
    'Cabbage',
    'Onion',
    'Other',
  ];

  final List<String> _locations = [
    'Blantyre',
    'Lilongwe',
    'Mzuzu',
    'Zomba',
    'Mangochi',
    'Kasungu',
    'Salima',
    'Mulanje',
    'Thyolo',
    'Dedza',
  ];

  final List<String> _units = ['kg', 'g', 'bags', 'plants', 'bundles'];

  @override
  void dispose() {
    _cropNameController.dispose();
    _quantityController.dispose();
    _wantsController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _pickImage() {
    // In real app, this would use image_picker package
    setState(() {
      _selectedImage = '📸';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Image picker would open here (requires image_picker package)'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _submitListing() {
    if (_formKey.currentState!.validate()) {
      if (_selectedImage == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please add a photo of your seeds'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      // In real app, this would save to Firebase
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Listing created successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      
      // Navigate back
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Add Seed Listing'),
        backgroundColor: Colors.green[600],
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header info banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              color: Colors.green[50],
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.green[700]),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Share your seeds with the community. No cash needed!',
                      style: TextStyle(
                        color: Colors.green[800],
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Form
            Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Photo Upload Section
                    _buildSectionTitle('Seed Photo'),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        width: double.infinity,
                        height: 200,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: _selectedImage == null
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.add_photo_alternate,
                                    size: 64,
                                    color: Colors.grey[400],
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    'Tap to add photo',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Clear photos help farmers decide',
                                    style: TextStyle(
                                      color: Colors.grey[500],
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              )
                            : Center(
                                child: Text(
                                  _selectedImage!,
                                  style: const TextStyle(fontSize: 80),
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Crop Type
                    _buildSectionTitle('Crop Type'),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: _selectedCropType,
                      decoration: _inputDecoration('Select crop type'),
                      items: _cropTypes.map((crop) {
                        return DropdownMenuItem(
                          value: crop,
                          child: Text(crop),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedCropType = value;
                        });
                      },
                      validator: (value) {
                        if (value == null) return 'Please select a crop type';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Crop Name/Variety (if Other or specific variety)
                    _buildSectionTitle('Crop Name/Variety (Optional)'),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _cropNameController,
                      decoration: _inputDecoration('e.g., SC627, Hybrid, Local variety'),
                    ),
                    const SizedBox(height: 16),

                    // Quantity
                    _buildSectionTitle('Quantity Available'),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: TextFormField(
                            controller: _quantityController,
                            keyboardType: TextInputType.number,
                            decoration: _inputDecoration('Enter amount'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Enter quantity';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: _selectedUnit,
                            decoration: _inputDecoration('Unit'),
                            items: _units.map((unit) {
                              return DropdownMenuItem(
                                value: unit,
                                child: Text(unit),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedUnit = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Quality
                    _buildSectionTitle('Seed Quality'),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: Column(
                        children: [
                          _buildRadioOption('High', 'Premium quality, certified'),
                          Divider(height: 1, color: Colors.grey[300]),
                          _buildRadioOption('Medium', 'Good quality, reliable'),
                          Divider(height: 1, color: Colors.grey[300]),
                          _buildRadioOption('Low', 'Basic quality, budget option'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Organic checkbox
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: CheckboxListTile(
                        title: const Text('Organic/Natural'),
                        subtitle: const Text('No chemical fertilizers or pesticides'),
                        value: _isOrganic,
                        activeColor: Colors.green[600],
                        onChanged: (value) {
                          setState(() {
                            _isOrganic = value ?? false;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Location
                    _buildSectionTitle('Location'),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: _selectedLocation,
                      decoration: _inputDecoration('Select your location'),
                      items: _locations.map((location) {
                        return DropdownMenuItem(
                          value: location,
                          child: Text(location),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedLocation = value;
                        });
                      },
                      validator: (value) {
                        if (value == null) return 'Please select location';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // What do you want in return
                    _buildSectionTitle('What do you want in return?'),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _wantsController,
                      decoration: _inputDecoration(
                        'e.g., Beans, Groundnuts, or Tomato seedlings',
                      ),
                      maxLines: 2,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please specify what you want';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Additional description
                    _buildSectionTitle('Additional Details (Optional)'),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: _inputDecoration(
                        'Any other information about the seeds...',
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 32),

                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _submitListing,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green[600],
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                        ),
                        child: const Text(
                          'Post Listing',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey[400]),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.green[600]!, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }

  Widget _buildRadioOption(String value, String subtitle) {
    return RadioListTile<String>(
      title: Text(
        value,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
      ),
      value: value,
      groupValue: _selectedQuality,
      activeColor: Colors.green[600],
      onChanged: (val) {
        setState(() {
          _selectedQuality = val;
        });
      },
    );
  }
}