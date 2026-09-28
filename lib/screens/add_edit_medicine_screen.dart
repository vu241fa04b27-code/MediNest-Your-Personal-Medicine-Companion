import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../utils/uuid_util.dart';
import '../models/medicine.dart';
import '../services/storage_service.dart';
import '../services/notification_service.dart';
import '../utils/app_colors.dart';
import '../utils/app_styles.dart';
import '../widgets/large_button.dart';

class AddEditMedicineScreen extends StatefulWidget {
  final Medicine? medicineToEdit;

  const AddEditMedicineScreen({super.key, this.medicineToEdit});

  @override
  State<AddEditMedicineScreen> createState() => _AddEditMedicineScreenState();
}

class _AddEditMedicineScreenState extends State<AddEditMedicineScreen> {
  final _formKey = GlobalKey<FormState>();
  final StorageService _storage = StorageService();

  late TextEditingController _nameController;
  late TextEditingController _purposeController;
  late TextEditingController _doctorNameController;
  late TextEditingController _hospitalNameController;
  late TextEditingController _doctorPhoneController;
  late TextEditingController _hospitalPhoneController;
  late TextEditingController _hospitalAddressController;
  late TextEditingController _notesController;
  late TextEditingController _stockController;

  String _selectedType = 'Tablet';
  bool _beforeFood = false;
  bool _afterFood = true;
  String _repeat = 'Daily';
  late DateTime _startDate;
  late DateTime _endDate;
  List<TimeOfDay> _selectedTimes = [const TimeOfDay(hour: 8, minute: 0)];

  @override
  void initState() {
    super.initState();
    final med = widget.medicineToEdit;

    _nameController = TextEditingController(text: med?.name ?? '');
    _purposeController = TextEditingController(text: med?.purpose ?? '');
    _doctorNameController = TextEditingController(text: med?.doctorName ?? 'Dr. K. Ramesh');
    _hospitalNameController = TextEditingController(text: med?.hospitalName ?? 'Apollo Hospital');
    _doctorPhoneController = TextEditingController(text: med?.doctorPhone ?? '+91 98480 12345');
    _hospitalPhoneController = TextEditingController(text: med?.hospitalPhone ?? '+91 40 2345 6789');
    _hospitalAddressController = TextEditingController(text: med?.hospitalAddress ?? 'Road No. 72, Jubilee Hills, Hyderabad');
    _notesController = TextEditingController(text: med?.notes ?? '');
    _stockController = TextEditingController(text: (med?.remainingStock ?? 30).toString());

    _selectedType = med?.type ?? 'Tablet';
    _beforeFood = med?.beforeFood ?? false;
    _afterFood = med?.afterFood ?? true;
    _repeat = med?.repeat ?? 'Daily';
    _startDate = med?.startDate ?? DateTime.now();
    _endDate = med?.endDate ?? DateTime.now().add(const Duration(days: 30));

    if (med != null && med.doseTimes.isNotEmpty) {
      _selectedTimes = med.doseTimes.map((t) {
        try {
          final format = DateFormat('hh:mm a');
          final dt = format.parse(t);
          return TimeOfDay(hour: dt.hour, minute: dt.minute);
        } catch (_) {
          return const TimeOfDay(hour: 8, minute: 0);
        }
      }).toList();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _purposeController.dispose();
    _doctorNameController.dispose();
    _hospitalNameController.dispose();
    _doctorPhoneController.dispose();
    _hospitalPhoneController.dispose();
    _hospitalAddressController.dispose();
    _notesController.dispose();
    _stockController.dispose();
    super.dispose();
  }

  String _formatTimeOfDay(TimeOfDay time) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return DateFormat('hh:mm a').format(dt);
  }

  Future<void> _pickStartDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );
    if (picked != null) setState(() => _startDate = picked);
  }

  Future<void> _pickEndDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _endDate,
      firstDate: _startDate,
      lastDate: DateTime(2035),
    );
    if (picked != null) setState(() => _endDate = picked);
  }

  Future<void> _addTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && !_selectedTimes.contains(picked)) {
      setState(() => _selectedTimes.add(picked));
    }
  }

  Future<void> _saveMedicine() async {
    if (!_formKey.currentState!.validate()) return;

    final stock = int.tryParse(_stockController.text.trim()) ?? 30;
    final timesStrings = _selectedTimes.map((t) => _formatTimeOfDay(t)).toList();

    final med = Medicine(
      id: widget.medicineToEdit?.id ?? const Uuid().v4(),
      name: _nameController.text.trim(),
      type: _selectedType,
      purpose: _purposeController.text.trim(),
      doctorName: _doctorNameController.text.trim(),
      hospitalName: _hospitalNameController.text.trim(),
      doctorPhone: _doctorPhoneController.text.trim(),
      hospitalPhone: _hospitalPhoneController.text.trim(),
      hospitalAddress: _hospitalAddressController.text.trim(),
      startDate: _startDate,
      endDate: _endDate,
      beforeFood: _beforeFood,
      afterFood: _afterFood,
      doseTimes: timesStrings,
      repeat: _repeat,
      remainingStock: stock,
      totalStock: stock,
      notes: _notesController.text.trim(),
      commonSideEffects: widget.medicineToEdit?.commonSideEffects ?? ['Mild headache', 'Stomach upset'],
      warnings: widget.medicineToEdit?.warnings ?? ['Don\'t stop without doctor\'s advice.'],
    );

    if (widget.medicineToEdit != null) {
      await _storage.updateMedicine(med);
    } else {
      await _storage.addMedicine(med);
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.primaryGreenDark,
          content: Text('✓ Saved ${med.name} successfully!'),
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.medicineToEdit != null;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          isEdit ? 'Edit Medicine' : 'Add New Medicine',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Section 1: Basic Information
                _buildSectionHeader('1. Medicine Information', Icons.medication_rounded),
                const SizedBox(height: 12),

                // Medicine Name
                _buildLabel('Medicine Name *'),
                TextFormField(
                  controller: _nameController,
                  validator: (v) => v == null || v.trim().isEmpty ? 'Please enter medicine name' : null,
                  decoration: _inputDecoration('e.g. Ketoconazole 200mg'),
                ),
                const SizedBox(height: 14),

                // Form Dropdown (Tablet/Capsule/Syrup/Drops/Inhaler/Injection)
                _buildLabel('Dosage Form *'),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedType,
                      isExpanded: true,
                      items: ['Tablet', 'Capsule', 'Syrup', 'Drops', 'Inhaler', 'Injection'].map((type) {
                        return DropdownMenuItem(
                          value: type,
                          child: Text(type, style: const TextStyle(fontWeight: FontWeight.w600)),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => _selectedType = val);
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 14),

                // Purpose
                _buildLabel('Purpose / Health Condition *'),
                TextFormField(
                  controller: _purposeController,
                  validator: (v) => v == null || v.trim().isEmpty ? 'Please enter purpose' : null,
                  decoration: _inputDecoration('e.g. Controls dandruff & scalp itching'),
                ),
                const SizedBox(height: 14),

                // Stock Counter
                _buildLabel('Initial Remaining Tablets / Stock *'),
                TextFormField(
                  controller: _stockController,
                  keyboardType: TextInputType.number,
                  decoration: _inputDecoration('e.g. 30'),
                ),
                const SizedBox(height: 24),

                // Section 2: Timing & Schedule
                _buildSectionHeader('2. Timing & Frequency', Icons.alarm_rounded),
                const SizedBox(height: 12),

                // Food timing toggles (Before / After Food)
                _buildLabel('Relation to Food *'),
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _beforeFood = true;
                            _afterFood = false;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            color: _beforeFood ? AppColors.primaryGreenLight : Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: _beforeFood ? AppColors.primaryGreen : AppColors.border,
                              width: 1.5,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              '🍎 Before Food',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: _beforeFood ? AppColors.primaryGreenDark : AppColors.textPrimary,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _afterFood = true;
                            _beforeFood = false;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            color: _afterFood ? AppColors.warningLight : Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: _afterFood ? AppColors.warning : AppColors.border,
                              width: 1.5,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              '🍲 After Food',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: _afterFood ? AppColors.warning : AppColors.textPrimary,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Time picker
                _buildLabel('Dose Timings *'),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ..._selectedTimes.map((t) => Chip(
                          backgroundColor: AppColors.accentBlueLight,
                          label: Text(
                            _formatTimeOfDay(t),
                            style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.accentBlueDark),
                          ),
                          onDeleted: _selectedTimes.length > 1
                              ? () => setState(() => _selectedTimes.remove(t))
                              : null,
                        )),
                    ActionChip(
                      avatar: const Icon(Icons.add, size: 18, color: AppColors.accentBlue),
                      label: const Text('Add Time', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.accentBlue)),
                      backgroundColor: Colors.white,
                      onPressed: _addTime,
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Repeat options
                _buildLabel('Repeat Frequency *'),
                Row(
                  children: ['Daily', 'Weekly', 'Custom'].map((opt) {
                    final isSel = _repeat == opt;
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: ChoiceChip(
                          label: Center(
                            child: Text(
                              opt,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: isSel ? Colors.white : AppColors.textPrimary,
                              ),
                            ),
                          ),
                          selected: isSel,
                          selectedColor: AppColors.primaryGreen,
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          onSelected: (val) {
                            if (val) setState(() => _repeat = opt);
                          },
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 14),

                // Start & End Date Pickers
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLabel('Start Date'),
                          InkWell(
                            onTap: _pickStartDate,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: AppColors.border),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(DateFormat('dd MMM yyyy').format(_startDate)),
                                  const Icon(Icons.calendar_today_rounded, size: 18, color: AppColors.textSecondary),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLabel('End Date'),
                          InkWell(
                            onTap: _pickEndDate,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: AppColors.border),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(DateFormat('dd MMM yyyy').format(_endDate)),
                                  const Icon(Icons.calendar_month_rounded, size: 18, color: AppColors.textSecondary),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Section 3: Prescribing Doctor & Hospital
                _buildSectionHeader('3. Doctor & Hospital Contacts', Icons.local_hospital_rounded),
                const SizedBox(height: 12),

                _buildLabel('Doctor Name'),
                TextFormField(
                  controller: _doctorNameController,
                  decoration: _inputDecoration('e.g. Dr. K. Ramesh (Dermatologist)'),
                ),
                const SizedBox(height: 12),

                _buildLabel('Doctor Phone Number'),
                TextFormField(
                  controller: _doctorPhoneController,
                  keyboardType: TextInputType.phone,
                  decoration: _inputDecoration('+91 98480 12345'),
                ),
                const SizedBox(height: 12),

                _buildLabel('Hospital Name'),
                TextFormField(
                  controller: _hospitalNameController,
                  decoration: _inputDecoration('e.g. Apollo Hospital'),
                ),
                const SizedBox(height: 12),

                _buildLabel('Hospital Phone Number'),
                TextFormField(
                  controller: _hospitalPhoneController,
                  keyboardType: TextInputType.phone,
                  decoration: _inputDecoration('+91 40 2345 6789'),
                ),
                const SizedBox(height: 12),

                _buildLabel('Hospital Address'),
                TextFormField(
                  controller: _hospitalAddressController,
                  maxLines: 2,
                  decoration: _inputDecoration('Full hospital address...'),
                ),
                const SizedBox(height: 14),

                // Medicine Photo placeholder
                _buildLabel('Medicine Photo (Optional)'),
                Container(
                  width: double.infinity,
                  height: 90,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border, style: BorderStyle.solid),
                  ),
                  child: InkWell(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Camera & gallery picker ready.')),
                      );
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.camera_alt_outlined, color: AppColors.accentBlue, size: 30),
                        SizedBox(width: 10),
                        Text(
                          'Tap to Capture Medicine Photo',
                          style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.accentBlue),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 14),

                _buildLabel('Doctor Notes / Special Instructions'),
                TextFormField(
                  controller: _notesController,
                  maxLines: 2,
                  decoration: _inputDecoration('e.g. Take with a glass of warm water...'),
                ),
                const SizedBox(height: 30),

                // Big Save Button
                LargeButton(
                  label: isEdit ? 'Update Medicine' : 'Save Medicine',
                  icon: Icons.save_rounded,
                  type: ButtonType.primaryGreen,
                  height: 56,
                  fontSize: 18,
                  onPressed: _saveMedicine,
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primaryGreen, size: 20),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryGreenDark,
          ),
        ),
      ],
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 14),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.primaryGreen, width: 2),
      ),
    );
  }
}
