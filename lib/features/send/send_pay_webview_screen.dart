import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:go_router/go_router.dart';
import '../../data/repos/pesapal_repo.dart';
import '../../widgets/pressable.dart';
import '../../core/theme/tokens_spacing.dart';

/// WebView screen for Pesapal payment flow
///
/// Implements PRD Section 7 WebView UX:
/// - Show spinner while loading redirect_url
/// - Top bar "Back to Yole"
/// - On navigation to callback_url → call get status → route to success/failure
class SendPayWebViewScreen extends StatefulWidget {
  const SendPayWebViewScreen({
    super.key,
    required this.redirectUrl,
    required this.orderTrackingId,
    required this.pesapalRepo,
  });

  final String redirectUrl;
  final String orderTrackingId;
  final PesapalRepository pesapalRepo;

  @override
  State<SendPayWebViewScreen> createState() => _SendPayWebViewScreenState();
}

class _SendPayWebViewScreenState extends State<SendPayWebViewScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;
  bool _hasNavigatedToCallback = false;

  @override
  void initState() {
    super.initState();
    _initializeWebView();
  }

  void _initializeWebView() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() {
              _isLoading = true;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false;
            });
          },
          onNavigationRequest: (NavigationRequest request) {
            // Check if navigation is to callback URL
            if (_isCallbackUrl(request.url) && !_hasNavigatedToCallback) {
              _hasNavigatedToCallback = true;
              _handleCallbackNavigation();
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.redirectUrl));
  }

  bool _isCallbackUrl(String url) {
    // Check if URL matches the callback URL pattern
    // This should match the PESAPAL_CALLBACK_URL from environment
    return url.contains('callback') || url.contains('pesapal_callback');
  }

  Future<void> _handleCallbackNavigation() async {
    try {
      // Show loading state
      setState(() {
        _isLoading = true;
      });

      // Get transaction status from Pesapal
      final status = await widget.pesapalRepo.getTransactionStatus(
        orderTrackingId: widget.orderTrackingId,
      );

      // Route to success or failure based on status
      if (mounted) {
        if (widget.pesapalRepo.isTransactionCompleted(status)) {
          context.go('/send/success');
        } else if (widget.pesapalRepo.isTransactionFailed(status) ||
            widget.pesapalRepo.isTransactionReversed(status) ||
            widget.pesapalRepo.isTransactionInvalid(status)) {
          context.go('/send/failure');
        } else {
          // Still pending, show pending state
          context.go('/send/pending');
        }
      }
    } catch (e) {
      // Handle error - could be network issue or API error
      if (mounted) {
        context.go('/send/failure');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
        leading: Pressable(
          onPressed: () {
            // Show confirmation dialog before canceling
            _showCancelDialog();
          },
          child: const Icon(Icons.arrow_back),
        ),
        actions: [
          Pressable(
            onPressed: () {
              _showCancelDialog();
            },
            child: Padding(
              padding: SpacingTokens.lgHorizontal,
              child: Text(
                'Cancel',
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            Container(
              color: Theme.of(context).colorScheme.surface,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Processing payment...',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _showCancelDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Payment'),
        content: const Text(
          'Are you sure you want to cancel this payment? You will be returned to the send flow.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Continue Payment'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.go('/send/review');
            },
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}
