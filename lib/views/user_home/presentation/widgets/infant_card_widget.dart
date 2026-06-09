import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/localDB/models/heel_prick_blood_infent_model.dart';
import '../../../../core/theme/app_pallete.dart';

class InfantCardWidget extends StatelessWidget {
  final HeelPrickBloodInfantModel model;
  final bool isShort;
  final VoidCallback? onTap;

  const InfantCardWidget({
    super.key,
    required this.model,
    this.isShort = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [Colors.orange.shade50, Colors.orange.shade200],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: isShort ? _buildShortContent() : _buildFullContent(),
          ),
        ),
      ),
    );
  }

  // ================= SHORT VIEW =================
  Widget _buildShortContent() {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _chip(model.infantId ?? 'N/A'),
                const Spacer(),
                _syncStatus(),
              ],
            ),
            const SizedBox(height: 12),

            _infoRow(Icons.child_care, 'Child', model.childName),
            const SizedBox(height: 10),

            _infoRow(Icons.person, 'Mother', model.motherName),
            const SizedBox(height: 10),

            Row(
              children: [
                Expanded(child: _infoMini('Cluster', model.cluster)),
                Expanded(child: _infoMini('Sex', model.cSex)),
              ],
            ),
            const SizedBox(height: 10),

            Row(
              children: [
                Expanded(child: _infoMini('DOB', _formatDate(model.dob))),
                Expanded(child: _infoMini('Sample ID', model.sampleId)),
              ],
            ),
          ],
        ),
        // Row(
        //   children: [
        //     Container(
        //       padding: const EdgeInsets.all(8),
        //       decoration: BoxDecoration(
        //         color: Colors.green.shade50,
        //         borderRadius: BorderRadius.circular(12),
        //       ),
        //       child: Icon(Icons.phone, size: 18, color: Colors.green.shade700),
        //     ),
        // const SizedBox(width: 12),
        // Expanded(
        //   child: Column(
        //     crossAxisAlignment: CrossAxisAlignment.start,
        //     children: [
        //       Text(
        //         'Contact Number',
        //         style: TextStyle(
        //           fontSize: 10,
        //           color: Colors.grey.shade500,
        //           letterSpacing: 0.5,
        //         ),
        //       ),
        //       Text(
        //         model.mobile ?? 'N/A',
        //         style: const TextStyle(
        //           fontSize: 14,
        //           fontWeight: FontWeight.w600,
        //           color: AppPallete.primary,
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
        //   ],
        // ),
      ],
    );
  }

  // ================= FULL VIEW =================
  Widget _buildFullContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${model.childName} (${model.cSex ?? 'N/A'})',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppPallete.primary,
                  ),
                ),

                const SizedBox(height: 4),
                Text('Infant ID: ${model.infantId ?? 'N/A'}'),
                Text('Sample ID: ${model.sampleId ?? 'N/A'}'),
              ],
            ),
            const Spacer(),
            Expanded(
              child: InkWell(
                onTap: () {
                  // Handle contact number tap if needed
                  _makePhoneCall(model.mobile);
                },
                child: Card(
                  color: Colors.grey.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.green.shade50,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.phone,
                            size: 18,
                            color: Colors.green.shade700,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Contact Number',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey.shade500,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              Text(
                                model.mobile ?? 'N/A',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppPallete.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),
        Row(
          spacing: 12,
          children: [
            Expanded(
              child: _section('Child Information', Icons.child_care, [
                _row('Baby PID', model.childPid),
                _row('Baby CID', model.childCid),
                _row('DOB', _formatDate(model.dob)),
                _row('Visit Type', model.visitType),
              ]),
            ),
            Expanded(
              child: _section('Parents', Icons.family_restroom, [
                _row('Cluster', model.cluster),
                _row('Mother', model.motherName),
                _row('Mother CID', model.motherCid),
                _row('Father', model.fatherName),
              ]),
            ),
          ],
        ),

        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _row('Start Date', _formatDate(model.dueDate))),
            Expanded(child: _row('End Date', _formatDate(model.endDate))),
          ],
        ),
        const SizedBox(height: 8),
        if (model.syncDt != null && model.sendDt != 'null')
          Row(
            children: [
              Expanded(
                child: _row(
                  'Collection Date',
                  _formatDate(model.collectionDate),
                ),
              ),
              Expanded(child: _row('Send Date', _formatDate(model.sendDt))),
            ],
          ),
      ],
    );
  }

  // ================= UI HELPERS =================

  Widget _chip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppPallete.primary, Color(0xFF2980B9)],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
    );
  }

  Widget _syncStatus() {
    final isSynced = model.syncDt != null;

    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: isSynced ? Colors.green.shade100 : Colors.orange.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isSynced ? Icons.cloud_done : Icons.sync,
            size: 14,
            color: isSynced ? Colors.green : Colors.orange,
          ),
          const SizedBox(width: 4),
          Text(isSynced ? 'Synced' : 'Pending', style: TextStyle(fontSize: 10)),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String? value) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            '$label: ${value ?? 'N/A'}',
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }

  Widget _infoMini(String label, String? value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 10, color: Colors.grey)),
        Text(value ?? 'N/A', style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _section(String title, IconData icon, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 18, color: AppPallete.primary),
            const SizedBox(width: 6),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: AppPallete.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _row(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 130,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(child: Text(value ?? 'N/A')),
        ],
      ),
    );
  }

  String _formatDate(String? date) {
    if (date == null || date.isEmpty) return 'N/A';
    try {
      if (date.contains('-')) {
        final p = date.split('-');
        return '${p[2]}/${p[1]}/${p[0]}';
      }
      return date;
    } catch (_) {
      return date;
    }
  }

  void _makePhoneCall(String? mobile) async {
    if (mobile == null || mobile.isEmpty) return;
    final Uri launchUri = Uri(scheme: 'tel', path: mobile);
    await launchUrl(launchUri);
  }
}
