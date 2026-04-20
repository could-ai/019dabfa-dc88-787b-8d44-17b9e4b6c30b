const express = require('express');
const cors = require('cors');

const app = express();
app.use(cors());
app.use(express.json());

// Market data endpoint
app.get('/api/market-data/:asset', (req, res) => {
  const { asset } = req.params;
  
  // Generate mock price data
  const data = [];
  let currentPrice = 45000;
  
  for(let i = 0; i < 100; i++) {
    currentPrice += (Math.random() - 0.48) * 500;
    data.push({
      time: new Date(Date.now() - (100 - i) * 3600000).getTime() / 1000,
      value: currentPrice,
    });
  }

  res.json(data);
});

// Signals endpoint
app.get('/api/signals/:asset', (req, res) => {
  const { asset } = req.params;
  const isBullish = Math.random() > 0.5;

  res.json({
    asset: asset,
    status: isBullish ? "Bullish" : "Bearish",
    entry: isBullish ? 45200 : 44800,
    takeProfit: isBullish ? [46000, 47500] : [44000, 43500],
    stopLoss: isBullish ? 44500 : 45500,
    confidence: "High",
    indicators: {
      rsi: isBullish ? 65 : 35,
      macd: isBullish ? "Positive" : "Negative",
      trend: isBullish ? "Up" : "Down",
      ema50: "Support",
      bollinger: "Expanding"
    },
    message: isBullish 
      ? "Market is bullish due to RSI above 60 and price above 200 EMA."
      : "Bearish divergence detected. Price has fallen below support levels."
  });
});

const PORT = process.env.PORT || 5000;
app.listen(PORT, () => console.log(`Backend server running on port ${PORT}`));
