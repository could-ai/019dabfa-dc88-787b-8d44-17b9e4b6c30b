import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';

class TradingChart extends StatefulWidget {
  final String asset;
  final String timeframe;

  const TradingChart({
    super.key,
    required this.asset,
    required this.timeframe,
  });

  @override
  State<TradingChart> createState() => _TradingChartState();
}

class _TradingChartState extends State<TradingChart> {
  List<FlSpot> priceData = [];
  List<FlSpot> ema50Data = [];
  List<FlSpot> ema200Data = [];

  @override
  void initState() {
    super.initState();
    _generateMockData();
  }

  @override
  void didUpdateWidget(covariant TradingChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.asset != widget.asset || oldWidget.timeframe != widget.timeframe) {
      _generateMockData();
    }
  }

  void _generateMockData() {
    final random = Random(widget.asset.hashCode ^ widget.timeframe.hashCode);
    double price = 45000.0 + random.nextDouble() * 5000;
    
    List<FlSpot> newPriceData = [];
    List<FlSpot> newEma50 = [];
    List<FlSpot> newEma200 = [];
    
    for (int i = 0; i < 100; i++) {
      price += (random.nextDouble() - 0.48) * 500; // Slight upward bias
      newPriceData.add(FlSpot(i.toDouble(), price));
      
      // Lagging mock moving averages
      newEma50.add(FlSpot(i.toDouble(), price - 200 + random.nextDouble() * 50));
      newEma200.add(FlSpot(i.toDouble(), price - 800 + random.nextDouble() * 20));
    }
    
    setState(() {
      priceData = newPriceData;
      ema50Data = newEma50;
      ema200Data = newEma200;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (priceData.isEmpty) return const Center(child: CircularProgressIndicator());

    final minY = priceData.map((e) => e.y).reduce(min) - 1000;
    final maxY = priceData.map((e) => e.y).reduce(max) + 1000;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Text(
                  widget.asset,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 12),
                Text(
                  '\$${priceData.last.y.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: priceData.last.y > priceData.first.y
                        ? const Color(0xFF00C853)
                        : const Color(0xFFFF5252),
                  ),
                ),
                const Spacer(),
                _buildLegendItem('Price', const Color(0xFF2962FF)),
                const SizedBox(width: 12),
                _buildLegendItem('EMA 50', Colors.orange),
                const SizedBox(width: 12),
                _buildLegendItem('EMA 200', Colors.purple),
              ],
            ),
            const SizedBox(height: 24),
            Expanded(
              child: LineChart(
                LineChartData(
                  minY: minY,
                  maxY: maxY,
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: true,
                    getDrawingHorizontalLine: (value) => const FlLine(
                      color: Color(0xFF30363D),
                      strokeWidth: 1,
                      dashArray: [5, 5],
                    ),
                    getDrawingVerticalLine: (value) => const FlLine(
                      color: Color(0xFF30363D),
                      strokeWidth: 1,
                      dashArray: [5, 5],
                    ),
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 60,
                        getTitlesWidget: (value, meta) {
                          return Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              value.toStringAsFixed(0),
                              style: const TextStyle(color: Colors.grey, fontSize: 12),
                            ),
                          );
                        },
                      ),
                    ),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    // EMA 200
                    LineChartBarData(
                      spots: ema200Data,
                      isCurved: true,
                      color: Colors.purple,
                      barWidth: 2,
                      dotData: const FlDotData(show: false),
                    ),
                    // EMA 50
                    LineChartBarData(
                      spots: ema50Data,
                      isCurved: true,
                      color: Colors.orange,
                      barWidth: 2,
                      dotData: const FlDotData(show: false),
                    ),
                    // Price
                    LineChartBarData(
                      spots: priceData,
                      isCurved: true,
                      color: const Color(0xFF2962FF),
                      barWidth: 2,
                      dotData: const FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        color: const Color(0xFF2962FF).withOpacity(0.1),
                      ),
                    ),
                  ],
                  lineTouchData: LineTouchData(
                    touchTooltipData: LineTouchTooltipData(
                      tooltipBgColor: const Color(0xFF161B22),
                      getTooltipItems: (touchedSpots) {
                        return touchedSpots.map((spot) {
                          return LineTooltipItem(
                            spot.y.toStringAsFixed(2),
                            const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          );
                        }).toList();
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }
}
