import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../models/ticket.dart';

class TicketPrintService {
  static Future<void> printTicket(Ticket ticket) async {
    final pdf = pw.Document();

    // Generar QR code
    final qrImage = await QrPainter(
      data: ticket.nombre,
      version: QrVersions.auto,
      color: const Color(0xFF000000),
      emptyColor: const Color(0xFFFFFFFF),
    ).toImageData(200);

    final qrBytes = qrImage!.buffer.asUint8List();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a6,
        build: (pw.Context context) {
          return pw.Container(
            padding: const pw.EdgeInsets.all(20),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.grey, width: 2),
              borderRadius: const pw.BorderRadius.all(pw.Radius.circular(10)),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Header con logo y título
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          'GESTOR DE TICKETS',
                          style: pw.TextStyle(
                            fontSize: 16,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.blue,
                          ),
                        ),
                        pw.SizedBox(height: 4),
                        pw.Text(
                          'WiFi Access Ticket',
                          style: pw.TextStyle(
                            fontSize: 12,
                            color: PdfColors.grey,
                          ),
                        ),
                      ],
                    ),
                    pw.Container(
                      width: 60,
                      height: 60,
                      decoration: pw.BoxDecoration(
                        color: PdfColors.blue,
                        borderRadius: const pw.BorderRadius.all(
                          pw.Radius.circular(8),
                        ),
                      ),
                      child: pw.Center(
                        child: pw.Text(
                          'WiFi',
                          style: pw.TextStyle(
                            color: PdfColors.white,
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                pw.SizedBox(height: 20),

                // Código del ticket
                pw.Container(
                  width: double.infinity,
                  padding: const pw.EdgeInsets.all(15),
                  decoration: pw.BoxDecoration(
                    color: PdfColors.grey.shade(100),
                    borderRadius: const pw.BorderRadius.all(
                      pw.Radius.circular(8),
                    ),
                    border: pw.Border.all(color: PdfColors.grey.shade(300)),
                  ),
                  child: pw.Column(
                    children: [
                      pw.Text(
                        'CÓDIGO DE ACCESO',
                        style: pw.TextStyle(
                          fontSize: 10,
                          color: PdfColors.grey.shade(600),
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.SizedBox(height: 8),
                      pw.Text(
                        ticket.nombre,
                        style: pw.TextStyle(
                          fontSize: 32,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.black,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                ),

                pw.SizedBox(height: 20),

                // QR Code
                pw.Center(
                  child: pw.Column(
                    children: [
                      pw.Image(
                        pw.MemoryImage(qrBytes),
                        width: 120,
                        height: 120,
                      ),
                      pw.SizedBox(height: 8),
                      pw.Text(
                        'Escanear para conectar',
                        style: pw.TextStyle(
                          fontSize: 10,
                          color: PdfColors.grey.shade(600),
                        ),
                      ),
                    ],
                  ),
                ),

                pw.SizedBox(height: 20),

                // Información del ticket
                pw.Container(
                  padding: const pw.EdgeInsets.all(12),
                  decoration: pw.BoxDecoration(
                    color: PdfColors.white,
                    borderRadius: const pw.BorderRadius.all(
                      pw.Radius.circular(6),
                    ),
                    border: pw.Border.all(color: PdfColors.grey.shade(300)),
                  ),
                  child: pw.Column(
                    children: [
                      _buildInfoRow('Estado:', _getStatusText(ticket.status)),
                      if (ticket.cliente != null && ticket.cliente!.isNotEmpty)
                        _buildInfoRow('Cliente:', ticket.cliente!),
                      _buildInfoRow(
                        'Fecha:',
                        _formatDate(ticket.fechaCreacion),
                      ),
                      if (ticket.fechaUso != null)
                        _buildInfoRow('Usado:', _formatDate(ticket.fechaUso!)),
                    ],
                  ),
                ),

                pw.SizedBox(height: 15),

                // Footer
                pw.Container(
                  width: double.infinity,
                  padding: const pw.EdgeInsets.all(10),
                  decoration: pw.BoxDecoration(
                    color: PdfColors.grey.shade(100),
                    borderRadius: const pw.BorderRadius.all(
                      pw.Radius.circular(6),
                    ),
                  ),
                  child: pw.Text(
                    'Presente este ticket para acceder al WiFi\nCódigo válido por 24 horas',
                    textAlign: pw.TextAlign.center,
                    style: pw.TextStyle(
                      fontSize: 8,
                      color: PdfColors.grey.shade(600),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );

    // Mostrar preview y opciones de impresión
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  static pw.Widget _buildInfoRow(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 2),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.SizedBox(
            width: 60,
            child: pw.Text(
              label,
              style: pw.TextStyle(
                fontSize: 9,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.grey.shade(600),
              ),
            ),
          ),
          pw.Expanded(
            child: pw.Text(
              value,
              style: pw.TextStyle(fontSize: 9, color: PdfColors.black),
            ),
          ),
        ],
      ),
    );
  }

  static String _getStatusText(TicketStatus status) {
    switch (status) {
      case TicketStatus.disponible:
        return 'Disponible';
      case TicketStatus.enUso:
        return 'En Uso';
      case TicketStatus.utilizado:
        return 'Utilizado';
      case TicketStatus.anulado:
        return 'Anulado';
    }
  }

  static String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}
