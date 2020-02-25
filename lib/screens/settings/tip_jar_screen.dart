import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../../shared/widgets/app_nav_bar.dart';
import '../../shared/widgets/buttons/squircle_text_button.dart';
import '../../utils/notification_util.dart';
import 'mad_lad_screen.dart';

class TipJarScreen extends StatefulWidget {
  @override
  _TipJarScreenState createState() => _TipJarScreenState();
}

class _TipJarScreenState extends State<TipJarScreen> {
  InAppPurchaseConnection _iap = InAppPurchaseConnection.instance;

  final Set<String> _kProductIds = {
    'reify_tip_jar_0_99',
    'reify_tip_jar_2_99',
    'reify_tip_jar_4_99',
    'reify_tip_jar_9_99'
  };

  bool _isIapAvailable = true;
  bool _isLoading = true;
  bool _isPurchasePending = false;
  bool _madladActuallyBoughtIap = false;
  List<ProductDetails> _products = [];

  /// Updates to purchases
  StreamSubscription<List<PurchaseDetails>> _subscription;

  @override
  void initState() {
    final Stream purchaseUpdates =
        InAppPurchaseConnection.instance.purchaseUpdatedStream;
    _subscription = purchaseUpdates.listen((purchaseDetailsList) {
      _listenToPurchaseUpdated(purchaseDetailsList);
    }, onDone: () {
      _subscription.cancel();
    }, onError: (error) {
      // handle error here.
    });

    initStoreInfo();
    super.initState();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  Future<void> initStoreInfo() async {
    final bool isAvailable = await _iap.isAvailable();
    // Store not available, return immediately
    if (!isAvailable) {
      setState(() {
        _isIapAvailable = isAvailable;
        _products = [];
        _isLoading = false;
      });
      return;
    }

    final QueryPurchaseDetailsResponse pastPurchaseResponse =
        await _iap.queryPastPurchases();
    for (var pastPurchase in pastPurchaseResponse.pastPurchases) {
      if (pastPurchase.pendingCompletePurchase) {
        await InAppPurchaseConnection.instance.completePurchase(pastPurchase);
      }
    }

    final ProductDetailsResponse response =
        await _iap.queryProductDetails(_kProductIds);

    if (response.error != null) {
      NotificationUtil.showFailureToast(response.error.message);
      setState(() {
        _isIapAvailable = isAvailable;
        _products = response.productDetails;
        _isLoading = false;
      });
      return;
    }

    setState(() {
      _products = response.productDetails;
      _isLoading = false;
    });
  }

  void purchaseItem(ProductDetails productDetails) {
    final PurchaseParam purchaseParam =
        PurchaseParam(productDetails: productDetails);
    InAppPurchaseConnection.instance
        .buyConsumable(purchaseParam: purchaseParam, autoConsume: true);
  }

  void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
      switch (purchaseDetails.status) {
        case PurchaseStatus.pending:
          setState(() {
            _isPurchasePending = true;
          });
          break;
        case PurchaseStatus.error:
          setState(() {
            _isPurchasePending = false;
          });
          break;
        case PurchaseStatus.purchased:
          setState(() {
            _isPurchasePending = false;
            _madladActuallyBoughtIap = true;
          });
          break;
      }
      if (purchaseDetails.pendingCompletePurchase) {
        await InAppPurchaseConnection.instance
            .completePurchase(purchaseDetails);
      }
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
            enabled: !_isPurchasePending,
            text: productDetail.price,
            onPressed: () {
              purchaseItem(productDetail);
            },
          ),
        ],
      ),
    );
  }

  Widget buildIapScreen() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
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
            Expanded(
              child: _isLoading
                  ? SpinKitThreeBounce(
                      color: Theme.of(context).disabledColor,
                      size: 20.0,
                    )
                  : _isIapAvailable
                      ? ListView(
                          children: <Widget>[
                            for (var prod in _products) buildProductRow(prod),
                          ],
                        )
                      : Text("Unable to load :("),
            ),
          ],
        ),
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
              disabled: _isPurchasePending,
            ),
            _madladActuallyBoughtIap ? MadLadScreen() : buildIapScreen(),
          ],
        ),
      ),
    );
  }
}
