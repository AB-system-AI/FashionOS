import 'package:equatable/equatable.dart';

import 'package:fashion_pos_enterprise/core/business/domain/enums/business_enums.dart';
import 'package:fashion_pos_enterprise/core/business/events/domain_event_bus.dart';

// ---------------------------------------------------------------------------
// Sale events
// ---------------------------------------------------------------------------

class SaleCreatedEvent extends DomainEvent {
  const SaleCreatedEvent({
    required super.eventId,
    required super.occurredAt,
    required this.saleId,
    required this.employeeId,
    super.tenantId,
    super.storeId,
    super.correlationId,
  });

  final String saleId;
  final String employeeId;

  @override
  String get eventType => 'sale.created';

  @override
  List<Object?> get props => [...super.props, saleId, employeeId];
}

class SaleCompletedEvent extends DomainEvent {
  const SaleCompletedEvent({
    required super.eventId,
    required super.occurredAt,
    required this.saleId,
    required this.grandTotalMinor,
    required this.currencyCode,
    super.tenantId,
    super.storeId,
    super.correlationId,
  });

  final String saleId;
  final int grandTotalMinor;
  final String currencyCode;

  @override
  String get eventType => 'sale.completed';

  @override
  List<Object?> get props => [...super.props, saleId, grandTotalMinor, currencyCode];
}

class SaleCancelledEvent extends DomainEvent {
  const SaleCancelledEvent({
    required super.eventId,
    required super.occurredAt,
    required this.saleId,
    this.reason,
    super.tenantId,
    super.storeId,
    super.correlationId,
  });

  final String saleId;
  final String? reason;

  @override
  String get eventType => 'sale.cancelled';

  @override
  List<Object?> get props => [...super.props, saleId, reason];
}

class PaymentReceivedEvent extends DomainEvent {
  const PaymentReceivedEvent({
    required super.eventId,
    required super.occurredAt,
    required this.saleId,
    required this.paymentId,
    required this.amountMinor,
    super.tenantId,
    super.storeId,
    super.correlationId,
  });

  final String saleId;
  final String paymentId;
  final int amountMinor;

  @override
  String get eventType => 'payment.received';

  @override
  List<Object?> get props => [...super.props, saleId, paymentId, amountMinor];
}

class CashSessionClosedEvent extends DomainEvent {
  const CashSessionClosedEvent({
    required super.eventId,
    required super.occurredAt,
    required this.sessionId,
    required this.actualCashMinor,
    required this.differenceMinor,
    super.tenantId,
    super.storeId,
    super.correlationId,
  });

  final String sessionId;
  final int actualCashMinor;
  final int differenceMinor;

  @override
  String get eventType => 'cash_session.closed';

  @override
  List<Object?> get props => [...super.props, sessionId, actualCashMinor, differenceMinor];
}

// ---------------------------------------------------------------------------
// Product & inventory events
// ---------------------------------------------------------------------------

class ProductUpdatedEvent extends DomainEvent {
  const ProductUpdatedEvent({
    required super.eventId,
    required super.occurredAt,
    required this.productId,
    super.tenantId,
    super.correlationId,
  });

  final String productId;

  @override
  String get eventType => 'product.updated';

  @override
  List<Object?> get props => [...super.props, productId];
}

class StockChangedEvent extends DomainEvent {
  const StockChangedEvent({
    required super.eventId,
    required super.occurredAt,
    required this.variantId,
    required this.warehouseId,
    required this.quantityBefore,
    required this.quantityAfter,
    required this.movementType,
    super.tenantId,
    super.storeId,
    super.correlationId,
  });

  final String variantId;
  final String warehouseId;
  final double quantityBefore;
  final double quantityAfter;
  final String movementType;

  @override
  String get eventType => 'stock.changed';

  @override
  List<Object?> get props => [
        ...super.props,
        variantId,
        warehouseId,
        quantityBefore,
        quantityAfter,
        movementType,
      ];
}

// ---------------------------------------------------------------------------
// Customer & purchase events
// ---------------------------------------------------------------------------

class CustomerCreatedEvent extends DomainEvent {
  const CustomerCreatedEvent({
    required super.eventId,
    required super.occurredAt,
    required this.customerId,
    super.tenantId,
    super.correlationId,
  });

  final String customerId;

  @override
  String get eventType => 'customer.created';

  @override
  List<Object?> get props => [...super.props, customerId];
}

class PurchaseReceivedEvent extends DomainEvent {
  const PurchaseReceivedEvent({
    required super.eventId,
    required super.occurredAt,
    required this.purchaseId,
    required this.supplierId,
    super.tenantId,
    super.storeId,
    super.correlationId,
  });

  final String purchaseId;
  final String supplierId;

  @override
  String get eventType => 'purchase.received';

  @override
  List<Object?> get props => [...super.props, purchaseId, supplierId];
}

// ---------------------------------------------------------------------------
// Loyalty & promotion events
// ---------------------------------------------------------------------------

class LoyaltyTierChangedEvent extends DomainEvent {
  const LoyaltyTierChangedEvent({
    required super.eventId,
    required super.occurredAt,
    required this.customerId,
    required this.previousTier,
    required this.newTier,
    super.tenantId,
    super.correlationId,
  });

  final String customerId;
  final LoyaltyTier previousTier;
  final LoyaltyTier newTier;

  @override
  String get eventType => 'loyalty.tier_changed';

  @override
  List<Object?> get props => [...super.props, customerId, previousTier, newTier];
}

class PromotionAppliedEvent extends DomainEvent {
  const PromotionAppliedEvent({
    required super.eventId,
    required super.occurredAt,
    required this.promotionId,
    required this.discountMinor,
    super.tenantId,
    super.storeId,
    super.correlationId,
  });

  final String promotionId;
  final int discountMinor;

  @override
  String get eventType => 'promotion.applied';

  @override
  List<Object?> get props => [...super.props, promotionId, discountMinor];
}

/// Well-known domain event type constants.
abstract final class DomainEventTypes {
  static const saleCreated = 'sale.created';
  static const saleCompleted = 'sale.completed';
  static const saleCancelled = 'sale.cancelled';
  static const paymentReceived = 'payment.received';
  static const cashSessionClosed = 'cash_session.closed';
  static const productUpdated = 'product.updated';
  static const stockChanged = 'stock.changed';
  static const customerCreated = 'customer.created';
  static const purchaseReceived = 'purchase.received';
  static const loyaltyTierChanged = 'loyalty.tier_changed';
  static const promotionApplied = 'promotion.applied';
}
