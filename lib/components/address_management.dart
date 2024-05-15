// ignore_for_file: avoid_print, use_build_context_synchronously

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
            .map((detail) => Address(
                cdId: detail.cdId,
                address: detail.address,
                phoneNumber: detail.phone))
            .toList();
      });
    } catch (e) {
      print('Failed to load address: $e');
      // Handle error: Show a snackbar or display an error message
    }
  }

  // void addAddress(Address address) {
  //   setState(() {
  //     deliveryAddresses.add(address);
  //   });
  // }

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
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Color.fromARGB(255, 78, 204, 82),
            content: Text('Address create successfully'),
            duration: Duration(seconds: 2),
          ),
        );
      } catch (e) {
        // Show error snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text('Failed to create address: $e'),
            duration: const Duration(seconds: 2),
          ),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _updateForm(int cdId) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });
      try {
        await CustomerDetail.updateAddress(
            cdId, _phoneNumber, '$_street, $_city, $_country');

        await _fetchAddress();
        Navigator.of(context).pop();

        // Show success snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Color.fromARGB(255, 78, 204, 82),
            content: Text('Customer detail updated successfully'),
            duration: Duration(seconds: 2),
          ),
        );
      } catch (e) {
        print('Failed to update address: $e');

        // Show error snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text('Failed to update customer detail: $e'),
            duration: const Duration(seconds: 2),
          ),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _deleteAddress(int cdId) async {
    try {
      await CustomerDetail.deleteAddress(cdId);
      await _fetchAddress();

      // Show success snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Color.fromARGB(255, 78, 204, 82),
          content: Text('Address deleted successfully'),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      print('Failed to delete address: $e');

      // Show error snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text('Failed to delete address: $e'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void removeAddress(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Confirm Delete',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text('Are you sure you want to delete this address?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final cdId = deliveryAddresses[index].cdId;
              _deleteAddress(cdId);
              Navigator.of(context).pop();
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showAddOrUpdateDialog({Address? address}) {
    if (address != null) {
      setState(() {
        _country = address.address.split(', ').last;
        _city = address.address.split(', ')[1];
        _street = address.address.split(', ').first;
        _phoneNumber = address.phoneNumber;
      });
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            address == null ? 'Add Address' : 'Update Address',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextFormField(
                  initialValue: _country,
                  decoration: const InputDecoration(labelText: 'Country'),
                  onSaved: (value) {
                    _country = value ?? '';
                  },
                ),
                TextFormField(
                  initialValue: _city,
                  decoration: const InputDecoration(labelText: 'City'),
                  onSaved: (value) {
                    _city = value ?? '';
                  },
                ),
                TextFormField(
                  initialValue: _street,
                  decoration: const InputDecoration(labelText: 'Street'),
                  onSaved: (value) {
                    _street = value ?? '';
                  },
                ),
                TextFormField(
                  initialValue: _phoneNumber,
                  decoration: const InputDecoration(labelText: 'Phone Number'),
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
              onPressed: _isLoading
                  ? null
                  : () async {
                      if (address == null) {
                        await _submitForm();
                      } else {
                        await _updateForm(address.cdId);
                      }
                    },
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : Text(address == null ? 'Add' : 'Update'),
            ),
          ],
        );
      },
    );
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
                  _showAddOrUpdateDialog();
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
                    print('cd_id: ${deliveryAddresses[index].cdId}');
                    _showAddOrUpdateDialog(address: deliveryAddresses[index]);
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
}

class Address {
  final int cdId;
  final String address;
  final String phoneNumber;

  Address({
    required this.cdId,
    required this.address,
    required this.phoneNumber,
  });
}
