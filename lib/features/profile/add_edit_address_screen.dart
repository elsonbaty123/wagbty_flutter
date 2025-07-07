import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../models/user_model.dart';
import '../../providers/user_provider.dart';
import '../../services/location_service.dart';
import '../../widgets/main_scaffold.dart';

class AddEditAddressScreen extends ConsumerStatefulWidget {
  final UserAddress? address;
  
  const AddEditAddressScreen({
    super.key,
    this.address,
  });

  @override
  ConsumerState<AddEditAddressScreen> createState() => _AddEditAddressScreenState();
}

class _AddEditAddressScreenState extends ConsumerState<AddEditAddressScreen> {
  final _formKey = GlobalKey<FormState>();
  final _labelController = TextEditingController();
  final _addressLine1Controller = TextEditingController();
  final _addressLine2Controller = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _postalCodeController = TextEditingController();
  
  String? _selectedCountry = 'السعودية';
  bool _isDefault = false;
  bool _isLoading = false;
  LatLng? _selectedLocation;

  @override
  void initState() {
    super.initState();
    if (widget.address != null) {
      final address = widget.address!;
      _labelController.text = address.label;
      _addressLine1Controller.text = address.addressLine1;
      _addressLine2Controller.text = address.addressLine2 ?? '';
      _cityController.text = address.city;
      _stateController.text = address.state ?? '';
      _postalCodeController.text = address.postalCode ?? '';
      _selectedCountry = address.country;
      _isDefault = address.isDefault;
      _selectedLocation = address.latitude != null && address.longitude != null
          ? LatLng(address.latitude!, address.longitude!)
          : null;
    }
  }

  @override
  void dispose() {
    _labelController.dispose();
    _addressLine1Controller.dispose();
    _addressLine2Controller.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _postalCodeController.dispose();
    super.dispose();
  }

  Future<void> _saveAddress() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() => _isLoading = true);
    
    try {
      final address = UserAddress(
        id: widget.address?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        label: _labelController.text.trim(),
        addressLine1: _addressLine1Controller.text.trim(),
        addressLine2: _addressLine2Controller.text.trim().isNotEmpty
            ? _addressLine2Controller.text.trim()
            : null,
        city: _cityController.text.trim(),
        state: _stateController.text.trim().isNotEmpty
            ? _stateController.text.trim()
            : null,
        country: _selectedCountry!,
        postalCode: _postalCodeController.text.trim().isNotEmpty
            ? _postalCodeController.text.trim()
            : null,
        latitude: _selectedLocation?.latitude,
        longitude: _selectedLocation?.longitude,
        isDefault: _isDefault,
      );
      
      if (widget.address == null) {
        await ref.read(userProvider.notifier).addAddress(address);
      } else {
        await ref.read(userProvider.notifier).updateAddress(address);
      }
      
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.address == null
                ? 'تمت إضافة العنوان بنجاح'
                : 'تم تحديث العنوان بنجاح',
          ),
        ),
      );
      
      if (!mounted) return;
      context.pop();
    } catch (e) {
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'حدث خطأ: ${e.toString()}',
          ),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isEdit = widget.address != null;
    
        return MainScaffold(
      currentIndex: 4,
      appBar: AppBar(
        title: Text(isEdit ? 'تعديل العنوان' : 'إضافة عنوان جديد'),
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _saveAddress,
            child: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('حفظ'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Address Label
              TextFormField(
                controller: _labelController,
                textDirection: TextDirection.rtl,
                decoration: const InputDecoration(
                  labelText: 'تسمية العنوان',
                  hintText: 'مثال: المنزل، العمل، آخر',
                  prefixIcon: Icon(Icons.label_outline),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'الرجاء إدخال تسمية للعنوان';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              // Address Search
              AddressSearchField(
                controller: _addressLine1Controller,
                hintText: 'ابحث عن عنوانك',
                labelText: 'العنوان',
                onLocationSelected: (position) {
                  if (position != null) {
                    setState(() {
                      _selectedLocation = position;
                    });
                  }
                },
              ),
              const SizedBox(height: 16),
              
              // Address Line 2 (Optional)
              TextFormField(
                controller: _addressLine2Controller,
                textDirection: TextDirection.rtl,
                decoration: const InputDecoration(
                  labelText: 'تفاصيل العنوان (اختياري)',
                  hintText: 'الشقة، الطابق، المبنى، إلخ',
                  prefixIcon: Icon(Icons.home_outlined),
                ),
              ),
              const SizedBox(height: 16),
              
              // City
              TextFormField(
                controller: _cityController,
                textDirection: TextDirection.rtl,
                decoration: const InputDecoration(
                  labelText: 'المدينة',
                  prefixIcon: Icon(Icons.location_city_outlined),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'الرجاء إدخال المدينة';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              // State/Province (Optional)
              TextFormField(
                controller: _stateController,
                textDirection: TextDirection.rtl,
                decoration: const InputDecoration(
                  labelText: 'المنطقة (اختياري)',
                  prefixIcon: Icon(Icons.map_outlined),
                ),
              ),
              const SizedBox(height: 16),
              
              // Country
              DropdownButtonFormField<String>(
                value: _selectedCountry,
                decoration: const InputDecoration(
                  labelText: 'الدولة',
                  prefixIcon: Icon(Icons.public_outlined),
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'السعودية',
                    child: Text('المملكة العربية السعودية'),
                  ),
                  DropdownMenuItem(
                    value: 'مصر',
                    child: Text('مصر'),
                  ),
                  DropdownMenuItem(
                    value: 'الإمارات',
                    child: Text('الإمارات العربية المتحدة'),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedCountry = value;
                    });
                  }
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'الرجاء اختيار الدولة';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              // Postal Code (Optional)
              TextFormField(
                controller: _postalCodeController,
                textDirection: TextDirection.ltr,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'الرمز البريدي (اختياري)',
                  prefixIcon: Icon(Icons.local_post_office_outlined),
                ),
              ),
              const SizedBox(height: 16),
              
              // Set as Default
              SwitchListTile(
                title: const Text('تعيين كعنوان افتراضي'),
                value: _isDefault,
                onChanged: (value) {
                  setState(() {
                    _isDefault = value;
                  });
                },
                secondary: const Icon(Icons.star_outline),
              ),
              
              // Save Button
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : _saveAddress,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(isEdit ? 'حفظ التغييرات' : 'إضافة العنوان'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
