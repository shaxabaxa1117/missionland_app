// quote_challenge_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:missionland_app/feature/screen_time/data/app_info_data.dart';
import '../services/restriction_service.dart';
import '../data/app_info_data.dart';
import 'package:missionland_app/app/home_page.dart';

class QuoteChallengeScreen extends StatefulWidget {
  final String appName;
  final double currentEmission;
  final double limit;

  const QuoteChallengeScreen({
    Key? key,
    required this.appName,
    required this.currentEmission,
    required this.limit,
  }) : super(key: key);

  @override
  State<QuoteChallengeScreen> createState() => _QuoteChallengeScreenState();
}

class _QuoteChallengeScreenState extends State<QuoteChallengeScreen> 
    with SingleTickerProviderStateMixin {
  
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  
  final TextEditingController _quoteController = TextEditingController();
  final FocusNode _quoteFocusNode = FocusNode();
  bool _isQuoteValid = false;
  String _targetQuote = "We do not inherit the Earth from our ancestors, we borrow it from our children";
  String _typedText = "";

  // Famous environmental quotes database
  final List<String> _environmentalQuotes = [
    "We do not inherit the Earth from our ancestors, we borrow it from our children",
    "The Earth does not belong to us; we belong to the Earth",
    "What we are doing to the forests of the world is but a mirror reflection of what we are doing to ourselves",
    "The environment is where we all meet; where we all have a mutual interest",
    "Climate change is no longer some far-off problem; it is happening here, it is happening now",
    "The greatest threat to our planet is the belief that someone else will save it",
    "The Earth is what we all have in common",
    "Nature is not a place to visit, it is home",
    "There are no passengers on spaceship Earth, we are all crew",
    "The climate crisis has already been solved. We already have the facts and solutions",
  ];

  @override
  void initState() {
    super.initState();
    
    // 전체화면 설정
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    
    // 애니메이션 설정
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));
    
    _animationController.forward();
    
    // Select random quote
    _environmentalQuotes.shuffle();
    _targetQuote = _environmentalQuotes.first;
    
    // Quote input listener
    _quoteController.addListener(_validateQuote);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _quoteController.dispose();
    _quoteFocusNode.dispose();
    // 시스템 UI 복원
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  void _validateQuote() {
    final input = _quoteController.text.trim();
    _typedText = input;
    
    // Check if input matches the target quote (case insensitive, allow minor variations)
    final normalizedTarget = _targetQuote.toLowerCase().replaceAll(RegExp(r'[^\w\s]'), '');
    final normalizedInput = input.toLowerCase().replaceAll(RegExp(r'[^\w\s]'), '');
    
    setState(() {
      _isQuoteValid = normalizedTarget == normalizedInput;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false, // 뒤로가기 차단
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  
                  // Title
                  Text(
                    'Wait!',
                    style: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.w900,
                      color: Colors.black,
                      height: 1.1,
                    ),
                  ),
                  

                  Text(
                    'Are you trying to\nuse ${widget.appName}?',
                    style: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                      height: 1.1,
                    ),
                  ),

                  const SizedBox(height: 20),

                  Text(
                    'Type this quote below to continue:',
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.black87,
                      height: 1.4,
                    ),
                  ),

                  // Quote to type
                  _buildQuoteDisplay(),
                  
                  const SizedBox(height: 20),
                  
                  // Subtitle with CO2 info and current status
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.black87,
                        height: 1.4,
                      ),
                      children: [
                        TextSpan(
                          text: 'You can reduce ${(AppInfoData.appMetadata[widget.appName]?.emitRate ?? 150).toStringAsFixed(0)} g of CO₂ per hour\nby not using ${widget.appName}.\nCurrent usage: ',
                        ),
                        TextSpan(
                          text: '${widget.currentEmission.toStringAsFixed(1)}g / ${widget.limit.toStringAsFixed(1)}g',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: widget.currentEmission > widget.limit * 0.8 ? Colors.orange : Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 60),
                  
                  const Spacer(),
                  
                  // Continue button (only visible when quote is completed)
                  if (_isQuoteValid)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          onPressed: _allowAccess,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: const Text(
                            'Continue to App',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuoteDisplay() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Display the quote with typed characters highlighted
          RichText(
            text: TextSpan(
              style: const TextStyle(
                fontSize: 18,
                color: Colors.black,
                height: 1.5,
              ),
              children: _buildQuoteSpans(),
            ),
          ),
          
          const SizedBox(height: 30),
          
          // Text input field
          TextField(
            controller: _quoteController,
            focusNode: _quoteFocusNode,
            maxLines: 3,
            autofocus: true,
            decoration: InputDecoration(
              hintText: 'Start typing the sentence above...',
              hintStyle: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 16,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: _isQuoteValid ? Colors.green : Colors.blue,
                  width: 2,
                ),
              ),
              filled: true,
              fillColor: Colors.grey.shade50,
              contentPadding: const EdgeInsets.all(16),
            ),
            style: const TextStyle(
              fontSize: 16,
              height: 1.4,
            ),
          ),
          
          const SizedBox(height: 15),
          
          // Progress indicator
          LinearProgressIndicator(
            value: _typedText.length / _targetQuote.length,
            backgroundColor: Colors.grey.shade200,
            valueColor: AlwaysStoppedAnimation<Color>(
              _isQuoteValid ? Colors.green : Colors.blue,
            ),
          ),
          
          const SizedBox(height: 10),
          
          // Status text
          Text(
            _isQuoteValid 
                ? '✓ Quote completed! You can now continue.'
                : 'Type the environmental quote above to continue...',
            style: TextStyle(
              fontSize: 14,
              color: _isQuoteValid ? Colors.green : Colors.grey.shade600,
              fontWeight: _isQuoteValid ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  List<TextSpan> _buildQuoteSpans() {
    List<TextSpan> spans = [];
    
    for (int i = 0; i < _targetQuote.length; i++) {
      Color textColor;
      Color? backgroundColor;
      
      if (i < _typedText.length) {
        // Character has been typed
        if (_typedText[i].toLowerCase() == _targetQuote[i].toLowerCase()) {
          // Correct character
          textColor = Colors.black;
          backgroundColor = Colors.green.withOpacity(0.2);
        } else {
          // Incorrect character
          textColor = Colors.red;
          backgroundColor = Colors.red.withOpacity(0.1);
        }
      } else {
        // Not yet typed
        textColor = Colors.grey.shade400;
      }
      
      spans.add(TextSpan(
        text: _targetQuote[i],
        style: TextStyle(
          color: textColor,
          backgroundColor: backgroundColor,
          fontWeight: backgroundColor != null ? FontWeight.w500 : FontWeight.normal,
        ),
      ));
    }
    
    return spans;
  }

  void _allowAccess() async {
    if (!_isQuoteValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please complete typing the environmental quote first!'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // 시스템 UI 복원
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    // Allow access to the app (you can customize this logic)
    SystemNavigator.pop();
  }
}