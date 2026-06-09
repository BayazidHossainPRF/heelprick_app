import 'package:flutter/material.dart';

import '../utils/dashboard_items.dart';

class DashboardCardWidget extends StatelessWidget {
  final String imageName;
  final List<DashboardItems> dataMap;
  final Color backgroundColor;
  const DashboardCardWidget({
    super.key,
    required this.imageName,
    required this.dataMap,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        child: Container(
          padding: EdgeInsets.all(8),
          child: Column(
            children: [
              Image.asset('assets/images/$imageName', width: MediaQuery.of(context).size.width*0.25,),
              Card(
                color: backgroundColor,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: dataMap.map((e) {
                      return Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(e.key.toString(), style: TextStyle(fontSize: 18),),
                              Text(e.value.toString(), style: TextStyle(fontSize: 18),),
                            ],
                          ),
                          Divider(color: Colors.grey.shade700),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
