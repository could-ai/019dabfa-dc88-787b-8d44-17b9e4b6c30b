import 'package:flutter/material.dart';
import '../widgets/trading_chart.dart';
import '../widgets/analysis_panel.dart';
import '../widgets/asset_selector.dart';
import '../widgets/app_header.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String _selectedAsset = 'BTC/USD';
  String _selectedTimeframe = '1h';

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = MediaQuery.of(context).size.width > 900;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(64),
        child: AppHeader(
          onLogin: () {
            // Mock login
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Login flow would open here')),
            );
          },
        ),
      ),
      body: isDesktop ? _buildDesktopLayout() : _buildMobileLayout(),
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left Column: Chart and Controls
        Expanded(
          flex: 7,
          child: Column(
            children: [
              AssetSelector(
                selectedAsset: _selectedAsset,
                selectedTimeframe: _selectedTimeframe,
                onAssetChanged: (val) => setState(() => _selectedAsset = val),
                onTimeframeChanged: (val) => setState(() => _selectedTimeframe = val),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 8, 16),
                  child: TradingChart(
                    asset: _selectedAsset,
                    timeframe: _selectedTimeframe,
                  ),
                ),
              ),
            ],
          ),
        ),
        // Right Column: Signals and Analysis
        Expanded(
          flex: 3,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 16, 16, 16),
            child: AnalysisPanel(
              asset: _selectedAsset,
              timeframe: _selectedTimeframe,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: AssetSelector(
            selectedAsset: _selectedAsset,
            selectedTimeframe: _selectedTimeframe,
            onAssetChanged: (val) => setState(() => _selectedAsset = val),
            onTimeframeChanged: (val) => setState(() => _selectedTimeframe = val),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              height: 400,
              child: TradingChart(
                asset: _selectedAsset,
                timeframe: _selectedTimeframe,
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: AnalysisPanel(
              asset: _selectedAsset,
              timeframe: _selectedTimeframe,
            ),
          ),
        ),
      ],
    );
  }
}
