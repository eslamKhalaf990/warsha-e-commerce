class OrderResponse {
  final int orderId;
  final String status;
  final double discount;
  final double delivery;
  final double totalPrice;
  final double downPayment;
  final String notes;
  final String orderSource;
  final String? paymentMethod; // Nullable
  final DateTime orderDate;
  final Customer customer;
  final List<OrderItem> orderItems;

  OrderResponse({
    required this.orderId,
    required this.status,
    required this.discount,
    required this.delivery,
    required this.totalPrice,
    required this.downPayment,
    required this.notes,
    required this.orderSource,
    this.paymentMethod,
    required this.orderDate,
    required this.customer,
    required this.orderItems,
  });

  // Factory constructor to create an instance from JSON
  factory OrderResponse.fromJson(Map<String, dynamic> json) {
    return OrderResponse(
      orderId: json['orderId'],
      status: json['status'],
      discount: (json['discount'] as num).toDouble(),
      delivery: (json['delivery'] as num).toDouble(),
      totalPrice: (json['totalPrice'] as num).toDouble(),
      downPayment: (json['downPayment'] as num).toDouble(),
      notes: json['notes'] ?? '',
      orderSource: json['orderSource'],
      paymentMethod: json['paymentMethod'],
      orderDate: DateTime.parse(json['orderDate']),
      customer: Customer.fromJson(json['customer']),
      orderItems: (json['orderItems'] as List)
          .map((item) => OrderItem.fromJson(item))
          .toList(),
    );
  }

  // Method to convert instance back to JSON
  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      'status': status,
      'discount': discount,
      'delivery': delivery,
      'totalPrice': totalPrice,
      'downPayment': downPayment,
      'notes': notes,
      'orderSource': orderSource,
      'paymentMethod': paymentMethod,
      'orderDate': orderDate.toIso8601String().split('T').first, // Keeps "YYYY-MM-DD" format
      'customer': customer.toJson(),
      'orderItems': orderItems.map((item) => item.toJson()).toList(),
    };
  }
}

class Customer {
  final int customerId;
  final String fullName;
  final String governorate;
  final String city;
  final String secondaryPhone;
  final String phone;
  final String address;

  Customer({
    required this.customerId,
    required this.fullName,
    required this.governorate,
    required this.city,
    required this.secondaryPhone,
    required this.phone,
    required this.address,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      customerId: json['customerId'],
      fullName: json['fullName'],
      governorate: json['governorate'],
      city: json['city'],
      secondaryPhone: json['secondaryPhone'],
      phone: json['phone'],
      address: json['address'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'customerId': customerId,
      'fullName': fullName,
      'governorate': governorate,
      'city': city,
      'secondaryPhone': secondaryPhone,
      'phone': phone,
      'address': address,
    };
  }
}

class OrderItem {
  final int productId;
  final String productName;
  final int quantity;
  final double unitPrice;

  OrderItem({
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.unitPrice,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      productId: json['productId'],
      productName: json['productName'],
      quantity: json['quantity'],
      unitPrice: (json['unitPrice'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'productName': productName,
      'quantity': quantity,
      'unitPrice': unitPrice,
    };
  }
}