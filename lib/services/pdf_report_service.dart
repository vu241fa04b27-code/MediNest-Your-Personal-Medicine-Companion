import 'dart:typed_data';
import 'package:flutter/material.dart' as material;
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../models/medicine.dart';
import '../models/dose_log.dart';
import '../models/hospital_appointment.dart';
import '../models/health_journal_entry.dart';
import '../models/emergency_profile.dart';

class PdfReportService {
  static Future<Uint8List> generateMedicalReport({
    required EmergencyProfile profile,
    required List<Medicine> medicines,
    required List<DoseLog> doseLogs,
    required List<HospitalAppointment> appointments,
    required List<HealthJournalEntry> journalEntries,
    required double adherenceRate,
  }) async {
    final pdf = pw.Document();
    final now = DateTime.now();
    final dateStr = DateFormat('MMMM dd, yyyy - hh:mm a').format(now);

    final baseGreen = PdfColor.fromHex('4CAF50');
    final darkGreen = PdfColor.fromHex('2E7D32');
    final textDark = PdfColor.fromHex('1E293B');
    final lightGrey = PdfColor.fromHex('F8FAFC');
    final borderGrey = PdfColor.fromHex('CBD5E1');

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return [
            // Header
            pw.Container(
              padding: const pw.EdgeInsets.all(16),
              decoration: pw.BoxDecoration(
                color: lightGrey,
                borderRadius: const pw.BorderRadius.all(pw.Radius.circular(12)),
                border: pw.Border.all(color: baseGreen, width: 1.5),
              ),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'MediNest Clinical Health Summary',
                        style: pw.TextStyle(
                          fontSize: 20,
                          fontWeight: pw.FontWeight.bold,
                          color: darkGreen,
                        ),
                      ),
                      pw.SizedBox(height: 4),
                      pw.Text(
                        'Comprehensive Medication & Hospital Check-up Report',
                        style: pw.TextStyle(fontSize: 10, color: textDark),
                      ),
                      pw.SizedBox(height: 2),
                      pw.Text(
                        'Generated on: $dateStr',
                        style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey700),
                      ),
                    ],
                  ),
                  pw.Container(
                    padding: const pw.EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: pw.BoxDecoration(
                      color: baseGreen,
                      borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
                    ),
                    child: pw.Column(
                      children: [
                        pw.Text(
                          '${adherenceRate.toStringAsFixed(0)}%',
                          style: pw.TextStyle(
                            fontSize: 18,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.white,
                          ),
                        ),
                        pw.Text(
                          'Adherence Rate',
                          style: const pw.TextStyle(fontSize: 8, color: PdfColors.white),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            pw.SizedBox(height: 18),

            // Patient Card
            pw.Container(
              padding: const pw.EdgeInsets.all(12),
              decoration: pw.BoxDecoration(
                borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
                border: pw.Border.all(color: borderGrey),
              ),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                    pw.Text('Patient Name: ${profile.userName}', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11)),
                    pw.Text('Blood Group: ${profile.bloodGroup}', style: const pw.TextStyle(fontSize: 10)),
                  ]),
                  pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                    pw.Text('Known Allergies: ${profile.allergies}', style: const pw.TextStyle(fontSize: 10)),
                    pw.Text('Emergency Contact: ${profile.emergencyContactPhone}', style: const pw.TextStyle(fontSize: 10)),
                  ]),
                  pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                    pw.Text('Primary Doctor: ${profile.doctorName}', style: const pw.TextStyle(fontSize: 10)),
                    pw.Text('Hospital: ${profile.hospitalName}', style: const pw.TextStyle(fontSize: 10)),
                  ]),
                ],
              ),
            ),
            pw.SizedBox(height: 20),

            // Section 1: Active Prescriptions
            pw.Text(
              '1. Current Prescribed Medications',
              style: pw.TextStyle(fontSize: 13, fontWeight: pw.FontWeight.bold, color: darkGreen),
            ),
            pw.SizedBox(height: 6),
            pw.TableHelper.fromTextArray(
              headers: ['Medicine Name', 'Type', 'Schedule', 'Food Timing', 'Purpose', 'Remaining'],
              data: medicines.map((m) {
                return [
                  m.name,
                  m.type,
                  m.doseTimes.join(', '),
                  m.afterFood ? 'After Food' : (m.beforeFood ? 'Before Food' : 'Anytime'),
                  m.purpose,
                  '${m.remainingStock} tabs',
                ];
              }).toList(),
              border: pw.TableBorder.all(color: borderGrey, width: 0.5),
              headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9, color: PdfColors.white),
              headerDecoration: pw.BoxDecoration(color: baseGreen),
              cellStyle: const pw.TextStyle(fontSize: 8.5),
              cellPadding: const pw.EdgeInsets.all(6),
            ),
            pw.SizedBox(height: 20),

            // Section 2: Hospital Visits & Appointments
            pw.Text(
              '2. Hospital & Doctor Consultation History',
              style: pw.TextStyle(fontSize: 13, fontWeight: pw.FontWeight.bold, color: darkGreen),
            ),
            pw.SizedBox(height: 6),
            pw.TableHelper.fromTextArray(
              headers: ['Doctor', 'Specialization', 'Hospital', 'Appointment Date', 'Prescription Notes', 'Status'],
              data: appointments.map((a) {
                return [
                  a.doctorName,
                  a.specialization,
                  a.hospitalName,
                  DateFormat('dd MMM yyyy, hh:mm a').format(a.appointmentDateTime),
                  a.prescriptionNotes.isNotEmpty ? a.prescriptionNotes : 'Regular Check-up',
                  a.isCompleted ? 'Completed' : 'Upcoming',
                ];
              }).toList(),
              border: pw.TableBorder.all(color: borderGrey, width: 0.5),
              headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9, color: PdfColors.white),
              headerDecoration: pw.BoxDecoration(color: darkGreen),
              cellStyle: const pw.TextStyle(fontSize: 8.5),
              cellPadding: const pw.EdgeInsets.all(6),
            ),
            pw.SizedBox(height: 20),

            // Section 3: Health Journal & Symptoms Diary
            pw.Text(
              '3. Patient Symptom Journal (Last Entries)',
              style: pw.TextStyle(fontSize: 13, fontWeight: pw.FontWeight.bold, color: darkGreen),
            ),
            pw.SizedBox(height: 6),
            pw.TableHelper.fromTextArray(
              headers: ['Date', 'Mood', 'Sleep', 'Itching Severity', 'Hair Fall Severity', 'Patient Notes'],
              data: journalEntries.take(5).map((j) {
                return [
                  DateFormat('dd MMM yyyy').format(j.date),
                  j.mood,
                  '${j.sleepHours} hrs',
                  j.itching,
                  j.hairFall,
                  j.notes.isNotEmpty ? j.notes : '-',
                ];
              }).toList(),
              border: pw.TableBorder.all(color: borderGrey, width: 0.5),
              headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9, color: PdfColors.white),
              headerDecoration: pw.BoxDecoration(color: baseGreen),
              cellStyle: const pw.TextStyle(fontSize: 8.5),
              cellPadding: const pw.EdgeInsets.all(6),
            ),
            pw.SizedBox(height: 30),

            // Doctor Sign-off Box
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('Doctor\'s Feedback / Next Action:', style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold)),
                    pw.Container(
                      width: 280,
                      height: 45,
                      decoration: pw.BoxDecoration(
                        border: pw.Border.all(color: borderGrey),
                        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(6)),
                      ],
                    ),
                  ],
                ),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  children: [
                    pw.Container(width: 140, height: 1, color: borderGrey),
                    pw.SizedBox(height: 4),
                    pw.Text('Doctor Signature & Stamp', style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey700)),
                  ],
                ),
              ],
            ),
          ];
        },
      ),
    );

    return pdf.save();
  }

  static Future<void> printOrShareReport({
    required material.BuildContext context,
    required EmergencyProfile profile,
    required List<Medicine> medicines,
    required List<DoseLog> doseLogs,
    required List<HospitalAppointment> appointments,
    required List<HealthJournalEntry> journalEntries,
    required double adherenceRate,
  }) async {
    final pdfBytes = await generateMedicalReport(
      profile: profile,
      medicines: medicines,
      doseLogs: doseLogs,
      appointments: appointments,
      journalEntries: journalEntries,
      adherenceRate: adherenceRate,
    );

    await Printing.sharePdf(
      bytes: pdfBytes,
      filename: 'MediNest_Report_${profile.userName}.pdf',
    );
  }
}
