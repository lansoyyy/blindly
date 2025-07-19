import 'package:flutter/material.dart';
import '../utils/colors.dart';

class AccountSetupScreen extends StatefulWidget {
  const AccountSetupScreen({super.key});

  @override
  State<AccountSetupScreen> createState() => _AccountSetupScreenState();
}

class _AccountSetupScreenState extends State<AccountSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _bioController = TextEditingController();

  String? _selectedGender;
  String? _selectedPreference;
  String? _selectedCity;

  // Philippines major cities
  final List<String> _philippineCities = [
    'Manila',
    'Quezon City',
    'Caloocan',
    'Las Piñas',
    'Makati',
    'Malabon',
    'Mandaluyong',
    'Marikina',
    'Muntinlupa',
    'Navotas',
    'Parañaque',
    'Pasay',
    'Pasig',
    'San Juan',
    'Taguig',
    'Valenzuela',
    'Pateros',
    'Cebu City',
    'Davao City',
    'Zamboanga City',
    'Antipolo',
    'Cagayan de Oro',
    'Bacolod',
    'Iloilo City',
    'General Santos',
    'Iligan',
    'Mandaue',
    'Dagupan',
    'Baguio',
    'Butuan',
    'Angeles',
    'Olongapo',
    'Batangas City',
    'San Fernando (La Union)',
    'San Fernando (Pampanga)',
    'Laoag',
    'Tarlac City',
    'San Carlos (Pangasinan)',
    'Urdaneta',
    'Cabanatuan',
    'San Jose del Monte',
    'Malolos',
    'Meycauayan',
    'Santa Rosa',
    'Biñan',
    'Cabuyao',
    'San Pablo',
    'Lucena',
    'Tayabas',
    'Puerto Princesa',
    'Other',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: textLight),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Setup Profile',
          style: TextStyle(
            color: textLight,
            fontFamily: 'Medium',
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Tell us about yourself',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: textLight,
                    fontFamily: 'Bold',
                  ),
                ),

                const SizedBox(height: 10),

                const Text(
                  'This information will be shared when you reveal your identity',
                  style: TextStyle(
                    fontSize: 14,
                    color: textGrey,
                    fontFamily: 'Regular',
                  ),
                ),

                const SizedBox(height: 30),

                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Name Field
                        _buildTextField(
                          controller: _nameController,
                          label: 'Full Name',
                          hint: 'Enter your full name',
                          icon: Icons.person,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your name';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 20),

                        // Age Field
                        _buildTextField(
                          controller: _ageController,
                          label: 'Age',
                          hint: 'Enter your age',
                          icon: Icons.cake,
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your age';
                            }
                            final age = int.tryParse(value);
                            if (age == null || age < 18 || age > 100) {
                              return 'Please enter a valid age (18-100)';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 20),

                        // Gender Selection
                        const Text(
                          'Gender',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: textLight,
                            fontFamily: 'Medium',
                          ),
                        ),

                        const SizedBox(height: 10),

                        _buildGenderSelection(),

                        const SizedBox(height: 20),

                        // Preference Selection
                        const Text(
                          'Looking for',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: textLight,
                            fontFamily: 'Medium',
                          ),
                        ),

                        const SizedBox(height: 10),

                        _buildPreferenceSelection(),

                        const SizedBox(height: 20),

                        // City Selection
                        const Text(
                          'City',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: textLight,
                            fontFamily: 'Medium',
                          ),
                        ),

                        const SizedBox(height: 10),

                        _buildCityDropdown(),

                        const SizedBox(height: 20),

                        // Bio Field
                        const Text(
                          'Bio (Optional)',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: textLight,
                            fontFamily: 'Medium',
                          ),
                        ),

                        const SizedBox(height: 10),

                        _buildBioField(),

                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),

                // Continue Button
                Container(
                  width: double.infinity,
                  height: 55,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [primary, primary.withOpacity(0.8)],
                    ),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: primary.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: TextButton(
                    onPressed: _handleContinue,
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: const Text(
                      'Continue',
                      style: TextStyle(
                        color: buttonText,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Medium',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: textLight,
            fontFamily: 'Medium',
          ),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          style: const TextStyle(
            color: textLight,
            fontFamily: 'Regular',
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
              color: textGrey,
              fontFamily: 'Regular',
            ),
            prefixIcon: Icon(icon, color: primary),
            filled: true,
            fillColor: surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: primary, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red, width: 2),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGenderSelection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _selectedGender != null ? primary : Colors.transparent,
          width: 2,
        ),
      ),
      child: Column(
        children: [
          _buildRadioTile('Male', 'Male'),
          const SizedBox(height: 10),
          _buildRadioTile('Female', 'Female'),
          const SizedBox(height: 10),
          _buildRadioTile('Non-binary', 'Non-binary'),
        ],
      ),
    );
  }

  Widget _buildRadioTile(String title, String value) {
    return RadioListTile<String>(
      title: Text(
        title,
        style: const TextStyle(
          color: textLight,
          fontFamily: 'Regular',
        ),
      ),
      value: value,
      groupValue: _selectedGender,
      onChanged: (newValue) {
        setState(() {
          _selectedGender = newValue;
        });
      },
      activeColor: primary,
      contentPadding: EdgeInsets.zero,
    );
  }

  Widget _buildPreferenceSelection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _selectedPreference != null ? primary : Colors.transparent,
          width: 2,
        ),
      ),
      child: Column(
        children: [
          _buildPreferenceRadioTile('Men', 'Men'),
          const SizedBox(height: 10),
          _buildPreferenceRadioTile('Women', 'Women'),
          const SizedBox(height: 10),
          _buildPreferenceRadioTile('Everyone', 'Everyone'),
        ],
      ),
    );
  }

  Widget _buildPreferenceRadioTile(String title, String value) {
    return RadioListTile<String>(
      title: Text(
        title,
        style: const TextStyle(
          color: textLight,
          fontFamily: 'Regular',
        ),
      ),
      value: value,
      groupValue: _selectedPreference,
      onChanged: (newValue) {
        setState(() {
          _selectedPreference = newValue;
        });
      },
      activeColor: primary,
      contentPadding: EdgeInsets.zero,
    );
  }

  Widget _buildCityDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _selectedCity != null ? primary : Colors.transparent,
          width: 2,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedCity,
          hint: const Text(
            'Select your city',
            style: TextStyle(
              color: textGrey,
              fontFamily: 'Regular',
            ),
          ),
          icon: const Icon(Icons.keyboard_arrow_down, color: primary),
          dropdownColor: surface,
          style: const TextStyle(
            color: textLight,
            fontFamily: 'Regular',
          ),
          onChanged: (newValue) {
            setState(() {
              _selectedCity = newValue;
            });
          },
          items: _philippineCities.map<DropdownMenuItem<String>>((String city) {
            return DropdownMenuItem<String>(
              value: city,
              child: Text(city),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildBioField() {
    return Container(
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.transparent,
          width: 2,
        ),
      ),
      child: TextFormField(
        controller: _bioController,
        maxLines: 4,
        style: const TextStyle(
          color: textLight,
          fontFamily: 'Regular',
        ),
        decoration: const InputDecoration(
          hintText: 'Tell us about yourself...',
          hintStyle: TextStyle(
            color: textGrey,
            fontFamily: 'Regular',
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(16),
        ),
      ),
    );
  }

  void _handleContinue() {
    if (_formKey.currentState!.validate() &&
        _selectedGender != null &&
        _selectedPreference != null &&
        _selectedCity != null) {
      // Navigate to image upload screen
      Navigator.pushNamed(context, '/upload-images');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all required fields'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
