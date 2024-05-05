import 'package:flutter/material.dart';

class AddressManagement extends StatefulWidget {
  final void Function(String address, String phoneNumber)? onAddressSelected;

  const AddressManagement({super.key, this.onAddressSelected});

  @override
  // ignore: library_private_types_in_public_api
  _AddressManagementState createState() => _AddressManagementState();
}

class _AddressManagementState extends State<AddressManagement> {
  final _formKey = GlobalKey<FormState>();
  String _country = '';
  String _city = '';
  String _street = '';
  String _phoneNumber = '';

  List<Address> deliveryAddresses = [
    Address(
      address: '123 Main St, New York, NY',
      phoneNumber: '123-456-7890',
    ),
    Address(
      address: '456 Elm St, New York, NY',
      phoneNumber: '123-456-7890',
    ),
  ];

  void addAddress(Address address) {
    setState(() {
      deliveryAddresses.add(address);
    });
  }

  void removeAddress(int index) {
    setState(() {
      deliveryAddresses.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Delivery Addresses',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    backgroundColor: Colors.teal.shade200,
                    foregroundColor: Colors.white),
                child: const Text(
                  'Add New Address',
                  style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Add Address'),
                        content: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              TextFormField(
                                decoration:
                                    const InputDecoration(labelText: 'Country'),
                                onSaved: (value) {
                                  _country = value ?? '';
                                },
                              ),
                              TextFormField(
                                decoration:
                                    const InputDecoration(labelText: 'City'),
                                onSaved: (value) {
                                  _city = value ?? '';
                                },
                              ),
                              TextFormField(
                                decoration:
                                    const InputDecoration(labelText: 'Street'),
                                onSaved: (value) {
                                  _street = value ?? '';
                                },
                              ),
                              TextFormField(
                                decoration: const InputDecoration(
                                    labelText: 'Phone Number'),
                                onSaved: (value) {
                                  _phoneNumber = value ?? '';
                                },
                              ),
                            ],
                          ),
                        ),
                        actions: <Widget>[
                          TextButton(
                            child: const Text('Cancel'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            child: const Text('Add'),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                addAddress(Address(
                                    address: '$_street, $_city, $_country',
                                    phoneNumber: _phoneNumber));
                                Navigator.of(context).pop();
                              }
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: deliveryAddresses.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(deliveryAddresses[index].address),
                  subtitle: Text(deliveryAddresses[index].phoneNumber),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      removeAddress(index);
                    },
                  ),
                  onTap: () {
                    widget.onAddressSelected!(deliveryAddresses[index].address,
                        deliveryAddresses[index].phoneNumber);
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class Address {
  final String address;
  final String phoneNumber;

  Address({required this.address, required this.phoneNumber});
}
