class AdminRequest {
  final String id;
  final String requesterId;
  final String requestType; // exhibition, workshop, course
  final Map<String, dynamic>? requestData;
  final String status; // pending, approved, rejected
  final String createdAt;
  final String updatedAt;

  AdminRequest({
    required this.id,
    required this.requesterId,
    required this.requestType,
    this.requestData,
    this.status = 'pending',
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'requester_id': requesterId,
      'request_type': requestType,
      'request_data': requestData != null ? requestData.toString() : null,
      'status': status,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  factory AdminRequest.fromMap(Map<String, dynamic> map) {
    return AdminRequest(
      id: map['id'],
      requesterId: map['requester_id'],
      requestType: map['request_type'],
      // Basic implementation, parsing logic can be added later
      requestData: null,
      status: map['status'],
      createdAt: map['created_at'],
      updatedAt: map['updated_at'],
    );
  }

  AdminRequest copyWith({
    String? id,
    String? requesterId,
    String? requestType,
    Map<String, dynamic>? requestData,
    String? status,
    String? createdAt,
    String? updatedAt,
  }) {
    return AdminRequest(
      id: id ?? this.id,
      requesterId: requesterId ?? this.requesterId,
      requestType: requestType ?? this.requestType,
      requestData: requestData ?? this.requestData,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class AdminReport {
  final String id;
  final String reporterId;
  final String targetId;
  final String targetType; // post, comment, reel
  final String reason;
  final String status; // pending, resolved, dismissed
  final String createdAt;

  AdminReport({
    required this.id,
    required this.reporterId,
    required this.targetId,
    required this.targetType,
    required this.reason,
    this.status = 'pending',
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'reporter_id': reporterId,
      'target_id': targetId,
      'target_type': targetType,
      'reason': reason,
      'status': status,
      'created_at': createdAt,
    };
  }

  factory AdminReport.fromMap(Map<String, dynamic> map) {
    return AdminReport(
      id: map['id'],
      reporterId: map['reporter_id'],
      targetId: map['target_id'],
      targetType: map['target_type'],
      reason: map['reason'],
      status: map['status'],
      createdAt: map['created_at'],
    );
  }

  AdminReport copyWith({
    String? id,
    String? reporterId,
    String? targetId,
    String? targetType,
    String? reason,
    String? status,
    String? createdAt,
  }) {
    return AdminReport(
      id: id ?? this.id,
      reporterId: reporterId ?? this.reporterId,
      targetId: targetId ?? this.targetId,
      targetType: targetType ?? this.targetType,
      reason: reason ?? this.reason,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
