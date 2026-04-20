import 'package:flutter/material.dart';

class AssetSelector extends StatelessWidget {
  final String selectedAsset;
  final String selectedTimeframe;
  final ValueChanged<String> onAssetChanged;
  final ValueChanged<String> onTimeframeChanged;

  const AssetSelector({
    super.key,
    required this.selectedAsset,
    required this.selectedTimeframe,
    required this.onAssetChanged,
    required this.onTimeframeChanged,
  });

  static const List<String> assets = [
    'BTC/USD',
    'ETH/USD',
    'AAPL',
    'TSLA',
    'EUR/USD',
    'GBP/JPY'
  ];

  static const List<String> timeframes = [
    '1m',
    '5m',
    '15m',
    '1h',
    '4h',
    '1D'
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          // Asset Dropdown
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Theme.of(context).cardTheme.color,
              border: Border.all(color: const Color(0xFF30363D)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selectedAsset,
                icon: const Icon(Icons.keyboard_arrow_down, size: 20),
                dropdownColor: Theme.of(context).cardTheme.color,
                items: assets.map((String asset) {
                  return DropdownMenuItem<String>(
                    value: asset,
                    child: Text(
                      asset,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) onAssetChanged(val);
                },
              ),
            ),
          ),
          
          const SizedBox(width: 16),
          
          // Timeframe Selectors
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: timeframes.map((tf) {
                  final isSelected = tf == selectedTimeframe;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: InkWell(
                      onTap: () => onTimeframeChanged(tf),
                      borderRadius: BorderRadius.circular(6),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Theme.of(context).colorScheme.secondary.withOpacity(0.2)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: isSelected
                                ? Theme.of(context).colorScheme.secondary
                                : Colors.transparent,
                          ),
                        ),
                        child: Text(
                          tf,
                          style: TextStyle(
                            color: isSelected
                                ? Theme.of(context).colorScheme.secondary
                                : Colors.grey,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          
          // Indicators button
          OutlinedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Indicators menu')),
              );
            },
            icon: const Icon(Icons.analytics_outlined, size: 18),
            label: const Text('Indicators'),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xFF30363D)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
