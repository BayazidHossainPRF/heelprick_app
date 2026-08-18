import 'package:flutter/material.dart';
import 'package:heel_prick_blood_collection/core/localDB/models/enrollment_form_model.dart';
import 'package:intl/intl.dart';

class EnrollmentCardWidget extends StatelessWidget {
  final EnrollmentFormModel model;
  final Function() onTab;
  const EnrollmentCardWidget({
    super.key,
    required this.model,
    required this.onTab,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: onTab,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: Colors.blue.shade50,
                        child: Text(
                          'W${model.visitWeek}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${model.q104} (${model.infantId})',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Child PID: ${model.q102})',
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Text('PID BRANCH: ${model.q602}'),
                ],
              ),
            ),
            const SizedBox(height: 12),
            // _sectionTitle('', Icons.person_outline),
            Row(
              children: [
                _infoItem('Mother', model.q103 ?? 'N/A'),
                _infoItem('Father', model.father ?? 'N/A'),
              ],
            ),
            Row(
              children: [
                _infoItem(
                  'DOB',
                  DateFormat(
                    'dd MMM yyyy',
                  ).format(DateTime.parse(model.dob ?? '1909-09-09')),
                ),
                _infoItem(
                  'Start Date',
                  DateFormat('dd MMM yyyy').format(
                    DateTime.parse(model.dob ?? '1909-09-09').add(
                      Duration(days: (int.parse(model.visitWeek ?? '1') - 1)) *
                          7,
                    ),
                  ),
                ),
                _infoItem(
                  'End Date',
                  DateFormat('dd MMM yyyy').format(
                    DateTime.parse(model.dob ?? '1909-09-09').add(
                      Duration(
                        days: ((int.parse(model.visitWeek ?? '1') - 1) * 7) + 6,
                      ),
                    ),
                  ),
                ),
                _infoItem('Phone', model.phone ?? 'N/A'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoItem(String label, String value) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 12, color: Colors.black),
            ),
            const SizedBox(height: 3),
            Text(
              value.isEmpty ? 'N/A' : value,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  // Widget _sectionTitle(String title, IconData icon) {
  //   return Row(
  //     children: [
  //       Icon(icon, size: 18, color: Colors.blue),
  //       const SizedBox(width: 8),
  //       Text(
  //         title,
  //         style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
  //       ),
  //     ],
  //   );
  // }
}
