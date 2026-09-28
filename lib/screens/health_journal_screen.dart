import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../utils/uuid_util.dart';
import '../models/health_journal_entry.dart';
import '../services/storage_service.dart';
import '../utils/app_colors.dart';
import '../utils/app_styles.dart';
import '../widgets/large_button.dart';

class HealthJournalScreen extends StatefulWidget {
  const HealthJournalScreen({super.key});

  @override
  State<HealthJournalScreen> createState() => _HealthJournalScreenState();
}

class _HealthJournalScreenState extends State<HealthJournalScreen> {
  final StorageService _storage = StorageService();

  String _selectedMood = '😊';
  double _sleepHours = 8.0;
  String _energyLevel = 'Normal';
  String _selectedItching = 'Mild';
  String _selectedHairFall = 'Less';
  final TextEditingController _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _storage.addListener(_onStorageChanged);
  }

  void _onStorageChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _storage.removeListener(_onStorageChanged);
    _notesController.dispose();
    super.dispose();
  }

  void _saveEntry() async {
    final entry = HealthJournalEntry(
      id: const Uuid().v4(),
      date: DateTime.now(),
      mood: _selectedMood,
      sleepHours: _sleepHours,
      energyLevel: _energyLevel,
      itching: _selectedItching,
      hairFall: _selectedHairFall,
      notes: _notesController.text.trim(),
    );

    await _storage.addJournalEntry(entry);
    _notesController.clear();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: AppColors.primaryGreenDark,
          content: Text('✓ Today\'s health diary entry saved!'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final todayStr = DateFormat('MMMM dd, yyyy').format(DateTime.now());
    final entries = _storage.journalEntries;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        titleSpacing: 20,
        title: const Text(
          'Health Journal',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Today's Entry Form Container
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: AppStyles.cardRadius,
                  border: Border.all(color: AppColors.border),
                  boxShadow: AppColors.cardShadow,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Daily Health Diary',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.primaryGreenLight,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            todayStr,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryGreenDark,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Mood selector
                    const Text('How are you feeling today? (Mood)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildMoodOption('😊', 'Happy'),
                        _buildMoodOption('😐', 'Okay'),
                        _buildMoodOption('😔', 'Low'),
                        _buildMoodOption('😣', 'In Pain'),
                      ],
                    ),
                    const SizedBox(height: 18),

                    // Sleep Hours
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Sleep Duration', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        Text('${_sleepHours.toStringAsFixed(1)} Hours', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.accentBlueDark)),
                      ],
                    ),
                    Slider(
                      value: _sleepHours,
                      min: 3.0,
                      max: 12.0,
                      divisions: 18,
                      activeColor: AppColors.accentBlue,
                      label: '${_sleepHours.toStringAsFixed(1)} hrs',
                      onChanged: (val) => setState(() => _sleepHours = val),
                    ),
                    const SizedBox(height: 14),

                    // Energy Level
                    const Text('Energy Level', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    const SizedBox(height: 8),
                    Row(
                      children: ['Low', 'Normal', 'High'].map((lvl) {
                        final isSel = _energyLevel == lvl;
                        return Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: ChoiceChip(
                              label: Center(
                                child: Text(
                                  lvl,
                                  style: TextStyle(fontWeight: FontWeight.bold, color: isSel ? Colors.white : AppColors.textPrimary),
                                ),
                              ),
                              selected: isSel,
                              selectedColor: AppColors.primaryGreen,
                              backgroundColor: Colors.white,
                              onSelected: (val) {
                                if (val) setState(() => _energyLevel = lvl);
                              },
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 18),

                    // Symptom 1: Itching
                    const Text('Itching Severity', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    const SizedBox(height: 8),
                    Row(
                      children: ['None', 'Mild', 'Moderate', 'Severe'].map((itch) {
                        final isSel = _selectedItching == itch;
                        return Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 3),
                            child: ChoiceChip(
                              label: Text(
                                itch,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: isSel ? Colors.white : AppColors.textPrimary,
                                ),
                              ),
                              selected: isSel,
                              selectedColor: itch == 'Severe' ? AppColors.danger : AppColors.primaryGreen,
                              backgroundColor: Colors.white,
                              onSelected: (val) {
                                if (val) setState(() => _selectedItching = itch);
                              },
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 18),

                    // Symptom 2: Hair Fall
                    const Text('Hair Fall Severity', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    const SizedBox(height: 8),
                    Row(
                      children: ['None', 'Less', 'Moderate', 'Heavy'].map((fall) {
                        final isSel = _selectedHairFall == fall;
                        return Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 3),
                            child: ChoiceChip(
                              label: Text(
                                fall,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: isSel ? Colors.white : AppColors.textPrimary,
                                ),
                              ),
                              selected: isSel,
                              selectedColor: fall == 'Heavy' ? AppColors.danger : AppColors.primaryGreen,
                              backgroundColor: Colors.white,
                              onSelected: (val) {
                                if (val) setState(() => _selectedHairFall = fall);
                              },
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 18),

                    // Notes
                    const Text('Notes / Remarks', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _notesController,
                      maxLines: 2,
                      decoration: InputDecoration(
                        hintText: 'e.g. Scalp feels cooler after Ketoconazole tablet...',
                        filled: true,
                        fillColor: AppColors.borderLight.withOpacity(0.5),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.border)),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Save Entry Button
                    LargeButton(
                      label: 'Save Today\'s Entry ✓',
                      icon: Icons.check_circle_outline_rounded,
                      type: ButtonType.primaryGreen,
                      height: 52,
                      onPressed: _saveEntry,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Past Journal Entries Timeline
              const Text(
                'Past Diary Entries',
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 12),

              if (entries.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Center(child: Text('No journal entries yet. Save your first entry above!')),
                )
              else
                ...entries.map((entry) => Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: AppStyles.cardRadius,
                        border: Border.all(color: AppColors.border),
                        boxShadow: AppColors.cardShadow,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                DateFormat('MMMM dd, yyyy').format(entry.date),
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                              Text(entry.mood, style: const TextStyle(fontSize: 24)),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 6,
                            children: [
                              _buildPill('Itching: ${entry.itching}', AppColors.accentBlueLight, AppColors.accentBlueDark),
                              _buildPill('Hair Fall: ${entry.hairFall}', AppColors.warningLight, AppColors.warning),
                              _buildPill('${entry.sleepHours}h Sleep', AppColors.primaryGreenLight, AppColors.primaryGreenDark),
                              _buildPill('Energy: ${entry.energyLevel}', AppColors.borderLight, AppColors.textPrimary),
                            ],
                          ),
                          if (entry.notes.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            Text(
                              entry.notes,
                              style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                            ),
                          ],
                        ],
                      ),
                    )),

              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMoodOption(String emoji, String label) {
    final isSel = _selectedMood == emoji;
    return InkWell(
      onTap: () => setState(() => _selectedMood = emoji),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isSel ? AppColors.primaryGreenLight : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isSel ? AppColors.primaryGreen : Colors.transparent, width: 2),
        ),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 32)),
            const SizedBox(height: 4),
            Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: isSel ? AppColors.primaryGreenDark : AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }

  Widget _buildPill(String text, Color bg, Color fg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(8)),
      child: Text(text, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: fg)),
    );
  }
}
