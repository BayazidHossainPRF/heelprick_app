import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/localDB/models/pending_infant_model.dart';

class PendingInfantCard extends StatelessWidget {
  final PendingInfantModel pendingInfant;
  final Function() onPressed;

  const PendingInfantCard({
    super.key,
    required this.pendingInfant,
    required this.onPressed,
  });

  Widget _infoItem(String label, String value) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
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

  Widget _sectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.blue),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.blue.shade50,
                  child: Icon(Icons.person, color: Colors.blue.shade700),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {
                          onPressed();
                        },
                        child: Text(
                          pendingInfant.womanName ?? 'N/A',
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'Woman ID: ${pendingInfant.siteWomanId ?? 'N/A'}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Cluster ${pendingInfant.cluster ?? 'N/A'}',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Colors.blue.shade700,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),

            // Woman Information
            _sectionTitle('Woman Information', Icons.person_outline),

            const SizedBox(height: 12),

            Row(
              children: [
                _infoItem('Household ID', pendingInfant.householdId ?? 'N/A'),
                _infoItem(
                  'Branch Woman ID',
                  pendingInfant.branchWomanId ?? 'N/A',
                ),
              ],
            ),

            Row(
              children: [
                _infoItem('Husband Name', pendingInfant.fatherName ?? 'N/A'),
                _infoItem('Pregnancy SL', pendingInfant.pregSl ?? 'N/A'),
              ],
            ),

            const Divider(height: 8),

            const SizedBox(height: 8),

            // Pregnancy Information
            _sectionTitle('Pregnancy Information', Icons.pregnant_woman),

            const SizedBox(height: 12),

            Row(
              children: [
                _infoItem(
                  'No. of Babies',
                  pendingInfant.numOfBabies?.toString() ?? 'N/A',
                ),
                _infoItem('Infant ID', pendingInfant.infantId ?? 'N/A'),
              ],
            ),

            const Divider(height: 8),

            const SizedBox(height: 8),

            // Baby Information
            _sectionTitle('Baby Information', Icons.child_care),

            const SizedBox(height: 12),

            Row(
              children: [
                _infoItem('Child Name', pendingInfant.childName ?? 'N/A'),
                _infoItem(
                  'Child Sex',
                  (pendingInfant.childSex == '1' ? 'Male' : 'Female'),
                ),
              ],
            ),

            Row(
              children: [
                _infoItem(
                  'Child DOB',
                  DateFormat('dd MMM yyyy').format(
                    DateTime.tryParse(pendingInfant.dob.toString()) ??
                        DateTime.parse('1909-09-09'),
                  ),
                ),
                _infoItem('Child PID', pendingInfant.childPid ?? 'N/A'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
