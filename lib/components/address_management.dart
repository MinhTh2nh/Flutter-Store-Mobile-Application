import 'package:flutter/material.dart';
import '../constants.dart';
import '../model/customer_detail.dart';

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

  List<Address> deliveryAddresses = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchAddress();
  }

  Future<void> _fetchAddress() async {
    try {
      List<CustomerDetail> addresses =
          await CustomerDetail.fetchAddress(globalCustomerId!);
      setState(() {
        deliveryAddresses = addresses
            .map((detail) =>
                Address(address: detail.address, phoneNumber: detail.phone))
            .toList();
      });
    } catch (e) {
      print('Failed to load address: $e');
      // Handle error: Show a snackbar or display an error message
    }
  }

  void addAddress(Address address) {
    setState(() {
      deliveryAddresses.add(address);
    });
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });
      try {
        await CustomerDetail.createAddress(
            _phoneNumber, '$_street, $_city, $_country', globalCustomerId!);

        await _fetchAddress();
        // ignore: use_build_context_synchronously
        Navigator.of(context).pop();
      } catch (e) {
        print('Failed to create address: $e');
        // Handle error: Show a snackbar or display an error message
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
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
                            onPressed: _isLoading ? null : _submitForm,
                            child: _isLoading
                                ? const CircularProgressIndicator()
                                : const Text('Add'),
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
