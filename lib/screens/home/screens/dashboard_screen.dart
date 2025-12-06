import 'package:flutter/material.dart';
import 'package:hellenic_shipping_services/screens/home/widgets/home_overview.dart';
import 'package:hellenic_shipping_services/screens/widget/components/custom_scafold.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return CustomScafold(
      children: [
        SliverFillRemaining(
          hasScrollBody: false,
          child: Center(child: HomeOverview()),
        ),
      ],
    );
  }
}
