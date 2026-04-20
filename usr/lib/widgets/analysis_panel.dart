import 'package:flutter/material.dart';

class AnalysisPanel extends StatelessWidget {
  final String asset;
  final String timeframe;

  const AnalysisPanel({
    super.key,
    required this.asset,
    required this.timeframe,
  });

  @override
  Widget build(BuildContext context) {
    // Generate some mock signals based on the asset string length/hash
    final isBullish = asset.length % 2 == 0;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildSignalCard(isBullish),
        const SizedBox(height: 16),
        _buildAIInsights(isBullish),
        const SizedBox(height: 16),
        _buildIndicatorsList(),
      ],
    );
  }

  Widget _buildSignalCard(bool isBullish) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Trading Signal',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: isBullish ? const Color(0xFF00C853).withOpacity(0.1) : const Color(0xFFFF5252).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isBullish ? const Color(0xFF00C853) : const Color(0xFFFF5252),
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                isBullish ? 'BUY / LONG' : 'SELL / SHORT',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: isBullish ? const Color(0xFF00C853) : const Color(0xFFFF5252),
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildTargetRow('Entry', isBullish ? '45,200.00' : '44,800.00', Colors.white),
            const SizedBox(height: 8),
            _buildTargetRow('Take Profit', isBullish ? '46,500.00' : '43,500.00', const Color(0xFF00C853)),
            const SizedBox(height: 8),
            _buildTargetRow('Stop Loss', isBullish ? '44,500.00' : '45,500.00', const Color(0xFFFF5252)),
          ],
        ),
      ),
    );
  }

  Widget _buildTargetRow(String label, String value, Color valueColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey)),
        Text(
          value,
          style: TextStyle(fontWeight: FontWeight.bold, color: valueColor),
        ),
      ],
    );
  }

  Widget _buildAIInsights(bool isBullish) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.auto_awesome, color: Color(0xFF2962FF), size: 20),
                SizedBox(width: 8),
                Text(
                  'AI Insights',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              isBullish
                  ? 'Market is bullish due to RSI holding above 50 and price breaking the 50 EMA. Momentum favors buyers.'
                  : 'Bearish divergence detected on MACD. Price has fallen below support levels and 200 EMA.',
              style: const TextStyle(height: 1.5, color: Colors.white70),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Colors.amber.withOpacity(0.5)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.warning_amber_rounded, color: Colors.amber, size: 16),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'This is not financial advice.',
                      style: TextStyle(color: Colors.amber, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIndicatorsList() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Technical Indicators',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildIndicatorRow('RSI (14)', '62.5', 'Bullish', const Color(0xFF00C853)),
            const Divider(color: Color(0xFF30363D)),
            _buildIndicatorRow('MACD', 'Positive', 'Bullish', const Color(0xFF00C853)),
            const Divider(color: Color(0xFF30363D)),
            _buildIndicatorRow('50 EMA', '44,950', 'Support', Colors.grey),
            const Divider(color: Color(0xFF30363D)),
            _buildIndicatorRow('Bollinger Bands', 'Expanding', 'Volatile', Colors.orange),
          ],
        ),
      ),
    );
  }

  Widget _buildIndicatorRow(String name, String value, String status, Color statusColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 2,
            child: Text(name, style: const TextStyle(color: Colors.grey)),
          ),
          Expanded(
            flex: 2,
            child: Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
          ),
          Expanded(
            flex: 1,
            child: Text(
              status,
              textAlign: TextAlign.right,
              style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
