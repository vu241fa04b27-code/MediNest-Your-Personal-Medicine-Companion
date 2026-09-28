import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import '../utils/app_colors.dart';
import '../utils/app_styles.dart';
import '../widgets/large_button.dart';

class AiFeaturesScreen extends StatefulWidget {
  const AiFeaturesScreen({super.key});

  @override
  State<AiFeaturesScreen> createState() => _AiFeaturesScreenState();
}

class _AiFeaturesScreenState extends State<AiFeaturesScreen> {
  final StorageService _storage = StorageService();

  // Chat messages for Doctor AI Chat demo
  final List<Map<String, String>> _messages = [
    {
      'sender': 'ai',
      'text': 'Hello Ammu! 🌸 I am your MediNest AI Health Assistant. You can ask me questions about your medicines, food guidelines, or side effects.',
    },
    {
      'sender': 'user',
      'text': 'Can I take Ketoconazole before breakfast?',
    },
    {
      'sender': 'ai',
      'text': 'It is recommended to take Ketoconazole 200mg right after lunch or a meal. Food helps your body absorb the medicine properly and prevents any mild stomach upset.',
    },
  ];
  final TextEditingController _chatController = TextEditingController();

  void _sendChatMessage() {
    final text = _chatController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add({'sender': 'user', 'text': text});
      _chatController.clear();
    });

    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) {
        setState(() {
          _messages.add({
            'sender': 'ai',
            'text': 'Based on your prescription for Ketoconazole and Cetirizine, be sure to complete the full recommended duration. Consult Dr. K. Ramesh if symptoms change!',
          });
        });
      }
    });
  }

  void _showScanStripDemo() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        height: MediaQuery.of(ctx).size.height * 0.75,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(4))),
            const SizedBox(height: 16),
            const Text('Scan Medicine Strip (AI Scanner)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 14),
            Container(
              height: 220,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.05),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.primaryGreen, width: 2),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const Icon(Icons.qr_code_scanner_rounded, size: 70, color: AppColors.primaryGreen),
                  Positioned(
                    bottom: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(color: Colors.black.withOpacity(0.7), borderRadius: BorderRadius.circular(8)),
                      child: const Text('Scanning strip barcode & name...', style: TextStyle(color: Colors.white, fontSize: 12)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: AppColors.primaryGreenLight, borderRadius: BorderRadius.circular(12)),
              child: const Row(
                children: [
                  Icon(Icons.check_circle_rounded, color: AppColors.primaryGreen),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Detected: Ketoconazole 200mg (Batch #KT-9821, Exp: 12/2027)',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.primaryGreenDark),
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            LargeButton(
              label: 'Autofill Medicine Form',
              type: ButtonType.primaryGreen,
              onPressed: () => Navigator.pop(ctx),
            ),
          ],
        ),
      ),
    );
  }

  void _showPrescriptionOcrDemo() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        height: MediaQuery.of(ctx).size.height * 0.70,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(4))),
            const SizedBox(height: 16),
            const Text('Prescription OCR Scanner', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: AppColors.cardBgTintedBlue, borderRadius: BorderRadius.circular(16)),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('OCR Recognized Doctor Notes:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.accentBlueDark)),
                  SizedBox(height: 8),
                  Text('Rx: Dr. K. Ramesh (Dermatologist)\n1. Tab. Ketoconazole 200mg 1 tab OD after lunch x 30d\n2. Tab. Cetirizine 10mg 1 tab HS x 15d\n3. Cap. Biotin & Multivitamin 1 cap daily', style: TextStyle(fontFamily: 'monospace', fontSize: 12)),
                ],
              ),
            ),
            const Spacer(),
            LargeButton(
              label: 'Import Prescribed Schedule',
              type: ButtonType.secondaryBlue,
              onPressed: () => Navigator.pop(ctx),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Future AI Features',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF8E1),
                  borderRadius: AppStyles.cardRadius,
                  border: Border.all(color: const Color(0xFFFFB300)),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.auto_awesome_rounded, color: Color(0xFFFF8F00), size: 28),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Smart AI Assistant Suite', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFFE65100))),
                          Text('Interactive AI tools designed to simplify medicine management.', style: TextStyle(fontSize: 12, color: AppColors.textPrimary)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // 1. Scan Medicine Strip
              _buildFeatureCard(
                title: 'Scan Medicine Strip',
                desc: 'Point camera at any tablet packaging to automatically detect name, dosage, and expiry date.',
                icon: Icons.qr_code_scanner_rounded,
                accentColor: AppColors.primaryGreen,
                buttonText: 'Try Strip Scanner',
                onPressed: _showScanStripDemo,
              ),
              const SizedBox(height: 14),

              // 2. Prescription OCR
              _buildFeatureCard(
                title: 'Prescription OCR Scanner',
                desc: 'Digitize handwritten doctor prescriptions and automatically populate medicine timings.',
                icon: Icons.document_scanner_rounded,
                accentColor: AppColors.accentBlue,
                buttonText: 'Try Prescription OCR',
                onPressed: _showPrescriptionOcrDemo,
              ),
              const SizedBox(height: 14),

              // 3. Medicine Interaction Checker
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: AppStyles.cardRadius,
                  border: Border.all(color: AppColors.border),
                  boxShadow: AppColors.cardShadow,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.biotech_rounded, color: Color(0xFF7B1FA2), size: 24),
                        SizedBox(width: 10),
                        Text('Medicine Interaction Checker', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text('Checking Ammu\'s active medications: Ketoconazole 200mg + Cetirizine 10mg + Biotin Complex.', style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: AppColors.primaryGreenLight, borderRadius: BorderRadius.circular(12)),
                      child: const Row(
                        children: [
                          Icon(Icons.verified_user_rounded, color: AppColors.primaryGreen, size: 20),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              '✓ No negative interactions detected. All medicines are compatible when taken at scheduled intervals.',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.primaryGreenDark),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // 4. AI Refill Prediction
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: AppStyles.cardRadius,
                  border: Border.all(color: AppColors.border),
                  boxShadow: AppColors.cardShadow,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.insights_rounded, color: Color(0xFF0288D1), size: 24),
                        SizedBox(width: 10),
                        Text('AI Refill Prediction', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Calculates exact run-out dates based on patient dose frequency.',
                      style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: AppColors.warningLight, borderRadius: BorderRadius.circular(12)),
                      child: const Row(
                        children: [
                          Icon(Icons.calendar_clock, color: AppColors.warning, size: 20),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Ketoconazole: 8 tablets left (1 tablet/day). Predicted stock run-out in 8 days. Automatic refill reminder scheduled for 5 days.',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.warning),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // 5. Doctor AI Chat
              const Text('Doctor AI Assistant (Elderly Friendly)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: AppStyles.cardRadius,
                  border: Border.all(color: AppColors.border),
                  boxShadow: AppColors.cardShadow,
                ),
                child: Column(
                  children: [
                    ..._messages.map((m) {
                      final isUser = m['sender'] == 'user';
                      return Align(
                        alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            color: isUser ? AppColors.accentBlueLight : AppColors.cardBgTintedGreen,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Text(
                            m['text']!,
                            style: TextStyle(
                              fontSize: 13,
                              color: isUser ? AppColors.accentBlueDark : AppColors.textPrimary,
                              fontWeight: isUser ? FontWeight.bold : FontWeight.w500,
                            ),
                          ),
                        ),
                      );
                    }),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _chatController,
                            decoration: InputDecoration(
                              hintText: 'Ask medicine questions...',
                              filled: true,
                              fillColor: AppColors.borderLight,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          style: IconButton.styleFrom(backgroundColor: AppColors.primaryGreen),
                          icon: const Icon(Icons.send_rounded, color: Colors.white),
                          onPressed: _sendChatMessage,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureCard({
    required String title,
    required String desc,
    required IconData icon,
    required Color accentColor,
    required String buttonText,
    required VoidCallback onPressed,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
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
            children: [
              Icon(icon, color: accentColor, size: 24),
              const SizedBox(width: 10),
              Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 6),
          Text(desc, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
          const SizedBox(height: 14),
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: accentColor, width: 1.5),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            icon: Icon(icon, color: accentColor, size: 18),
            label: Text(buttonText, style: TextStyle(color: accentColor, fontWeight: FontWeight.bold)),
            onPressed: onPressed,
          ),
        ],
      ),
    );
  }
}
