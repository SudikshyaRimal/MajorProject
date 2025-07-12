class Job {
  final String id;
  final String category;
  final String subCategory;
  final String customerName;
  final String address;
  final DateTime scheduledDate;
  final String scheduledTime;
  final String duration;
  final String payment;
  final String description;
  final String customerPhone;
  final String specialInstructions;
  JobStatus status;

  Job({
    required this.id,
    required this.category,
    required this.subCategory,
    required this.customerName,
    required this.address,
    required this.scheduledDate,
    required this.scheduledTime,
    required this.duration,
    required this.payment,
    required this.description,
    required this.customerPhone,
    required this.specialInstructions,
    required this.status,
  });
}


enum JobStatus { pending, accepted, rejected }
