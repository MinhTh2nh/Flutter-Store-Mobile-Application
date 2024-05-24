import 'dart:convert';
import 'package:http/http.dart' as http;

Future createPaymentIntent(
    {
    required String name,
    required String address,
    required String pin,
    required String city,
    required String state,
    required String country,
    required String currency,
    required String amount}) async {
    final url = Uri.parse('https://api.stripe.com/v1/payment_intents');
  final secretKey =
      "sk_test_51PJfH1EncpehfcF0Wv5iY17EuShye6L5XNj3Fu5Fr1Sena3FlzHJVvkW1xEWwU1fpGDS5b8FYTd45rSgasOxbdPS0074gU84sb";
  final body = {
    'amount': amount,
    'currency': currency.toLowerCase(),
    'automatic_payment_methods[enabled]': 'true',
    'description': "Test Donation",
    'shipping[name]': name,
    'shipping[address][line1]': address,
    'shipping[address][postal_code]': pin,
    'shipping[address][city]': city,
    'shipping[address][state]': state,
    'shipping[address][country]': country
  };

  final response = await http.post(url,
      headers: {
        "Authorization": "Bearer $secretKey",
        'Content-Type': 'application/x-www-form-urlencoded'
      },
      body: body);

  print(body);

  if (response.statusCode == 200) {
      return jsonDecode(response.body);
  } else {
      throw Exception('Failed to create payment intent');
  }
}
