import 'package:flutter/material.dart';

class PaymentMethod extends StatelessWidget {
  final Function(String) onPaymentSelected;

  const PaymentMethod({super.key, required this.onPaymentSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Payment Method',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 16),
          ListTile(
            leading:
                const Icon(Icons.money_off), // Icon for 'When receive order'
            title: const Text('When receive order'),
            onTap: () {
              onPaymentSelected('When receive order');
              Navigator.pop(context);
            },
          ),
          const Divider(),
          ListTile(
            leading:
                const Icon(Icons.account_balance), // Icon for 'Smart Banking'
            title: const Text('Smart Banking'),
            onTap: () {
              onPaymentSelected('smart banking');
              Navigator.pop(context);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.payment), // Icon for 'E-Wallets'
            title: const Text('E-Wallets'),
            onTap: () {
              onPaymentSelected('online banking');
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
