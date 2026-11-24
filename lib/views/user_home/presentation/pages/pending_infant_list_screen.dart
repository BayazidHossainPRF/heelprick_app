import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heel_prick_blood_collection/core/localDB/models/pending_infant_model.dart';
import '../../../../controllers/pending_infant_controller.dart';
import '../widgets/pending_infant_card_widget.dart';

class PendingInfantListScreen extends StatefulWidget {
  const PendingInfantListScreen({super.key});

  @override
  State<PendingInfantListScreen> createState() =>
      _PendingInfantListScreenState();
}

class _PendingInfantListScreenState extends State<PendingInfantListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  initState() {
    super.initState();
    PendingInfantController.to.downloadPendingInfantList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pending Infant List'),
        actions: [
          SizedBox(
            child: Obx(
              () => PendingInfantController.to.isLoading
                  ? const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    )
                  : Text(
                      _getFilteredList().length.toString(),
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                    ),
            ),
          ),
          const SizedBox(width: 16),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by mother pid or name...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _searchQuery = '';
                          });
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey.shade100,
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              },
            ),
          ),
        ),
      ),
      body: Obx(() {
        if (PendingInfantController.to.isLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (PendingInfantController.to.infants.isEmpty) {
          return const Center(child: Text('No pending infants found.'));
        } else {
          return ListView.builder(
            itemCount: _getFilteredList().length,
            itemBuilder: (context, index) {
              final infant = _getFilteredList()[index];
              return PendingInfantCard(
                pendingInfant: infant,
                onPressed: () {
                  _showOpenWarningDialog(context, _getFilteredList()[index]);
                },
              );
            },
          );
        }
      }),
    );
  }

  List<PendingInfantModel> _getFilteredList() {
    if (_searchQuery.isEmpty) {
      return PendingInfantController.to.infants;
    }

    return PendingInfantController.to.infants.where((infant) {
      return infant.siteWomanId?.toLowerCase().contains(_searchQuery) == true ||
          infant.womanName?.toLowerCase().contains(_searchQuery) == true;
    }).toList();
  }

  void _showOpenWarningDialog(BuildContext context, PendingInfantModel model) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text('Warning'),
          content: Text(
            'You are about to open the pending infant card for ${model.womanName ?? 'N/A'}. '
            'Please ensure that if you open the screening and enrollment form, you need to complete from your tab and upcomming all vsit will complete form this tab. Are you sure you want to proceed?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await Future.delayed(const Duration(seconds: 1));
                // LoaderWidget.show(context: context);
                await PendingInfantController.to.sendRequestForEnrollment(
                  model,
                );
                // Navigator.of(context).pop();
                // Get.offAllNamed(AppRoutes.HOMESCREEN);
              },
              child: const Text('Request for Enrollment Form'),
            ),
          ],
        );
      },
    );
  }

  // void _showLoadingDialog(BuildContext context) {
  //   // send a request
  //   showDialog(
  //     context: context,
  //     barrierDismissible:
  //         false, // Prevents closing the dialog by tapping outside
  //     builder: (context) {
  //       return AlertDialog(
  //         title: const Text('Please Wait'),
  //         content: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: const [
  //             Text(
  //               'Your request is being processed. This may take a few seconds. Please ensure you have a stable internet connection.',
  //             ),
  //             SizedBox(width: 20),
  //             CircularProgressIndicator(),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }
}
