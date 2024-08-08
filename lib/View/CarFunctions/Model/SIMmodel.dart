class SIMCard {
  final String carrierName;
  final String displayName;
  final int slotIndex;

  SIMCard({
    required this.carrierName,
    required this.displayName,
    required this.slotIndex,
  });

  factory SIMCard.fromJson(Map<Object?, Object?> json) {
    return SIMCard(
      carrierName: json['carrierName'] as String,
      displayName: json['displayName'] as String,
      slotIndex: int.parse(json['slotIndex'].toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'carrierName': carrierName,
      'displayName': displayName,
      'slotIndex': slotIndex.toString(),
    };
  }
}
