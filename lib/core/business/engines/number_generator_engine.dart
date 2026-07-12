import 'package:fashion_pos_enterprise/core/business/domain/entities/rule_models.dart';
import 'package:fashion_pos_enterprise/core/business/domain/enums/business_enums.dart';
import 'package:fashion_pos_enterprise/core/business/contracts/sequence_store.dart';
import 'package:fashion_pos_enterprise/core/result/result.dart';
import 'package:fashion_pos_enterprise/core/errors/failure.dart';

/// Generates configurable document numbers (invoice, PO, SKU, etc.).
class NumberGeneratorEngine {
  NumberGeneratorEngine(this._sequenceStore, {Map<DocumentNumberType, NumberSequenceFormat>? formats})
      : _formats = formats ?? _defaultFormats;

  final SequenceStore _sequenceStore;
  final Map<DocumentNumberType, NumberSequenceFormat> _formats;

  static final Map<DocumentNumberType, NumberSequenceFormat> _defaultFormats = {
    DocumentNumberType.invoice: const NumberSequenceFormat(type: DocumentNumberType.invoice, prefix: 'INV-', padding: 6),
    DocumentNumberType.purchase: const NumberSequenceFormat(type: DocumentNumberType.purchase, prefix: 'PO-', padding: 6),
    DocumentNumberType.customer: const NumberSequenceFormat(type: DocumentNumberType.customer, prefix: 'CUS-', padding: 5, includeDate: false),
    DocumentNumberType.supplier: const NumberSequenceFormat(type: DocumentNumberType.supplier, prefix: 'SUP-', padding: 5, includeDate: false),
    DocumentNumberType.returnOrder: const NumberSequenceFormat(type: DocumentNumberType.returnOrder, prefix: 'RET-', padding: 6),
    DocumentNumberType.exchange: const NumberSequenceFormat(type: DocumentNumberType.exchange, prefix: 'EXC-', padding: 6),
    DocumentNumberType.receipt: const NumberSequenceFormat(type: DocumentNumberType.receipt, prefix: 'RCP-', padding: 6),
    DocumentNumberType.saleOrder: const NumberSequenceFormat(type: DocumentNumberType.saleOrder, prefix: 'SO-', padding: 6),
    DocumentNumberType.cashSession: const NumberSequenceFormat(type: DocumentNumberType.cashSession, prefix: 'CS-', padding: 6),
    DocumentNumberType.layaway: const NumberSequenceFormat(type: DocumentNumberType.layaway, prefix: 'LAY-', padding: 6),
    DocumentNumberType.barcode: const NumberSequenceFormat(type: DocumentNumberType.barcode, prefix: 'BC', padding: 10, includeDate: false),
    DocumentNumberType.sku: const NumberSequenceFormat(type: DocumentNumberType.sku, prefix: 'SKU-', padding: 8, includeDate: false),
  };

  void registerFormat(NumberSequenceFormat format) {
    _formats[format.type] = format;
  }

  Future<Result<GeneratedNumber>> next({
    required DocumentNumberType type,
    required String tenantId,
    String? storeId,
    DateTime? at,
  }) async {
    final format = _formats[type];
    if (format == null) {
      return Error(ValidationFailure(message: 'No format registered for $type', code: 'invalid_sequence'));
    }

    final sequence = await _sequenceStore.nextSequence(
      tenantId: tenantId,
      storeId: storeId,
      documentType: type,
    );

    final generatedAt = at ?? DateTime.now().toUtc();
    return Success(
      GeneratedNumber(
        type: type,
        value: format.format(sequence, generatedAt),
        sequence: sequence,
        generatedAt: generatedAt,
      ),
    );
  }
}
