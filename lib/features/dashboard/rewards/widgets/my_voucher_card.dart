import 'package:flutter/material.dart';
import 'package:runca/ui/color.dart';

import '../models/my_voucher_model.dart';
import 'my_voucher_card_footer.dart';
import 'my_voucher_card_header.dart';
import 'my_voucher_ticket_divider.dart';

class MyVoucherCard extends StatelessWidget {
  const MyVoucherCard({super.key, required this.voucher, required this.onTap});

  final MyVoucherSummary voucher;
  final VoidCallback onTap;

  static const double _radius = 20;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppPalette.baseWhite,
        borderRadius: BorderRadius.circular(_radius),
        border: Border.all(color: AppPalette.borderNeutral),
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(_radius),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 5),
                child: MyVoucherCardHeader(voucher: voucher),
              ),
              const MyVoucherTicketDivider(),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 7, 16, 11),
                child: MyVoucherCardFooter(voucher: voucher),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
