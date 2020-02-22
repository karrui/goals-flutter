import 'package:Reify/shared/widgets/buttons/squircle_icon_button.dart';
import 'package:Reify/shared/widgets/buttons/squircle_text_button.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../../shared/widgets/app_nav_bar.dart';

class TipJarScreen extends StatefulWidget {
  @override
  _TipJarScreenState createState() => _TipJarScreenState();
}

class _TipJarScreenState extends State<TipJarScreen> {
  InAppPurchaseConnection _iap = InAppPurchaseConnection.instance;
  bool _isIapAvailable = true;

  List<ProductDetails> _products = [];

  /// Updates to purchases
  StreamSubscription<List<PurchaseDetails>> _subscription;

  @override
  void initState() {
    _initIap();
    super.initState();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  void _initIap() async {
    _isIapAvailable = await _iap.isAvailable();
    await _getProduct();

    final Stream purchaseUpdates =
        InAppPurchaseConnection.instance.purchaseUpdatedStream;
    _subscription = purchaseUpdates.listen((purchases) {
      // _handlePurchaseUpdates(purchases);
    });
  }

  _getProduct() async {
    const Set<String> _kIds = {
      'reify_tip_jar_0_99',
      'reify_tip_jar_2_99',
      'reify_tip_jar_4_99',
      'reify_tip_jar_9_99'
    };
    final ProductDetailsResponse response =
        await _iap.queryProductDetails(_kIds);
    if (response.notFoundIDs.isNotEmpty) {
      // Handle the error.
      print(response.notFoundIDs);
    }

    setState(() {
      _products = response.productDetails;
    });
  }

  Widget buildProductRow(ProductDetails productDetail) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            productDetail.title,
            style: Theme.of(context)
                .textTheme
                .subtitle2
                .copyWith(color: Theme.of(context).buttonColor),
          ),
          SquircleTextButton(
            text: productDetail.price,
            onPressed: () {
              print("click");
              // purchaseItem(productDetail);
            },
          ),
        ],
      ),
    );
  }

  Widget buildProductRowMock() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            "Small tip mock",
            style: Theme.of(context)
                .textTheme
                .subtitle2
                .copyWith(color: Theme.of(context).buttonColor),
          ),
          SquircleTextButton(
            text: "\$1.48",
            onPressed: () {
              print("click");
              // purchaseItem(productDetail);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            AppNavBar(
              title: 'Tip Jar',
              canGoBack: true,
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    "If you have found this app useful, you can leave a tip to show your appreciation and support further development. You are not obligated in any way whatsoever; I am happy to have you just using my app and hope that this app has helped make achieving your goals more fun and painless! Thank you for even coming to this page and reading this! 🎉",
                    style: Theme.of(context).textTheme.subtitle2.copyWith(
                        height: 1.4, fontSize: 17, fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  for (var prod in _products) buildProductRow(prod),
                  buildProductRowMock(),
                  buildProductRowMock(),
                  buildProductRowMock(),
                  buildProductRowMock(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
