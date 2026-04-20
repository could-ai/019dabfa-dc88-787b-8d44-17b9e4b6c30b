import React, { useState, useEffect } from 'react';
import { Activity, TrendingUp, TrendingDown, Clock, ShieldAlert } from 'lucide-react';
import { Chart } from './Chart';

const ASSETS = [
  { symbol: 'BTC/USD', name: 'Bitcoin', type: 'Crypto' },
  { symbol: 'ETH/USD', name: 'Ethereum', type: 'Crypto' },
  { symbol: 'AAPL', name: 'Apple Inc.', type: 'Stock' },
  { symbol: 'EUR/USD', name: 'Euro / US Dollar', type: 'Forex' }
];

const TIMEFRAMES = ['1m', '5m', '15m', '1h', '4h', '1D'];

const Dashboard = () => {
  const [selectedAsset, setSelectedAsset] = useState(ASSETS[0].symbol);
  const [timeframe, setTimeframe] = useState('1h');
  const [signalData, setSignalData] = useState(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const fetchSignal = async () => {
      setLoading(true);
      try {
        const response = await fetch(`http://localhost:5000/api/signals/${encodeURIComponent(selectedAsset)}`);
        const data = await response.json();
        setSignalData(data);
      } catch (error) {
        console.error("Failed to fetch signals", error);
      } finally {
        setLoading(false);
      }
    };

    fetchSignal();
    const interval = setInterval(fetchSignal, 60000); // refresh every minute
    return () => clearInterval(interval);
  }, [selectedAsset, timeframe]);

  return (
    <div className="flex flex-col h-screen bg-background text-textPrimary">
      {/* Header */}
      <header className="h-16 border-b border-border flex items-center px-6 justify-between bg-panel">
        <div className="flex items-center space-x-3">
          <Activity className="text-primary w-6 h-6" />
          <h1 className="text-xl font-bold">ProTrade Analysis</h1>
        </div>
        <div className="flex items-center space-x-4">
          <select 
            className="bg-background border border-border rounded px-3 py-1.5 text-sm outline-none focus:border-primary"
            value={selectedAsset}
            onChange={(e) => setSelectedAsset(e.target.value)}
          >
            {ASSETS.map(asset => (
              <option key={asset.symbol} value={asset.symbol}>
                {asset.symbol} - {asset.name}
              </option>
            ))}
          </select>
        </div>
      </header>

      {/* Main Content */}
      <main className="flex-1 flex flex-col lg:flex-row overflow-hidden">
        {/* Chart Section */}
        <div className="flex-1 flex flex-col min-h-[50vh] border-r border-border">
          <div className="h-12 border-b border-border flex items-center px-4 space-x-2 bg-panel">
            {TIMEFRAMES.map(tf => (
              <button 
                key={tf}
                onClick={() => setTimeframe(tf)}
                className={`px-3 py-1 text-sm rounded ${timeframe === tf ? 'bg-primary text-white' : 'text-textSecondary hover:text-white'}`}
              >
                {tf}
              </button>
            ))}
          </div>
          <div className="flex-1 bg-panel p-2">
             <Chart asset={selectedAsset} />
          </div>
        </div>

        {/* Sidebar Analysis Section */}
        <aside className="w-full lg:w-96 bg-panel p-6 overflow-y-auto flex flex-col space-y-6">
          <h2 className="text-lg font-bold border-b border-border pb-2">AI Analysis Engine</h2>
          
          {loading ? (
             <div className="flex justify-center items-center h-32">
               <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-primary"></div>
             </div>
          ) : signalData ? (
             <>
               {/* Signal Card */}
               <div className={`p-4 rounded-lg border flex flex-col space-y-3 ${signalData.status === 'Bullish' ? 'bg-buy/10 border-buy/30' : 'bg-sell/10 border-sell/30'}`}>
                 <div className="flex justify-between items-center">
                   <span className="text-sm font-semibold text-textSecondary uppercase tracking-wider">Trading Signal</span>
                   <span className={`px-2 py-1 rounded text-xs font-bold ${signalData.status === 'Bullish' ? 'bg-buy/20 text-buy' : 'bg-sell/20 text-sell'}`}>
                     {signalData.status}
                   </span>
                 </div>
                 <div className="flex items-center space-x-2">
                   {signalData.status === 'Bullish' ? <TrendingUp className="text-buy w-6 h-6" /> : <TrendingDown className="text-sell w-6 h-6" />}
                   <span className="text-2xl font-bold">{signalData.status === 'Bullish' ? 'BUY' : 'SELL'}</span>
                 </div>
                 <p className="text-sm text-textSecondary">{signalData.message}</p>
               </div>

               {/* Targets */}
               <div className="space-y-3">
                 <h3 className="font-semibold text-sm text-textSecondary uppercase tracking-wider">Entry & Targets</h3>
                 <div className="bg-background rounded-lg p-3 space-y-2 border border-border">
                   <div className="flex justify-between items-center text-sm">
                     <span className="text-textSecondary">Entry Zone</span>
                     <span className="font-mono">{signalData.entry.toLocaleString()}</span>
                   </div>
                   <div className="flex justify-between items-center text-sm">
                     <span className="text-textSecondary">Take Profit</span>
                     <span className="font-mono text-buy">{signalData.takeProfit.map(tp => tp.toLocaleString()).join(' / ')}</span>
                   </div>
                   <div className="flex justify-between items-center text-sm">
                     <span className="text-textSecondary">Stop Loss</span>
                     <span className="font-mono text-sell">{signalData.stopLoss.toLocaleString()}</span>
                   </div>
                 </div>
               </div>

               {/* Indicators */}
               <div className="space-y-3">
                 <h3 className="font-semibold text-sm text-textSecondary uppercase tracking-wider">Technical Indicators</h3>
                 <div className="bg-background rounded-lg p-3 grid grid-cols-2 gap-3 border border-border">
                    <div className="flex flex-col">
                      <span className="text-xs text-textSecondary">RSI (14)</span>
                      <span className="font-medium text-sm">{signalData.indicators.rsi}</span>
                    </div>
                    <div className="flex flex-col">
                      <span className="text-xs text-textSecondary">MACD</span>
                      <span className="font-medium text-sm">{signalData.indicators.macd}</span>
                    </div>
                    <div className="flex flex-col">
                      <span className="text-xs text-textSecondary">Trend</span>
                      <span className="font-medium text-sm">{signalData.indicators.trend}</span>
                    </div>
                    <div className="flex flex-col">
                      <span className="text-xs text-textSecondary">EMA 50</span>
                      <span className="font-medium text-sm">{signalData.indicators.ema50}</span>
                    </div>
                 </div>
               </div>

               {/* Disclaimer */}
               <div className="mt-auto pt-4 flex items-start space-x-2 text-xs text-textSecondary bg-background/50 p-3 rounded border border-border/50">
                 <ShieldAlert className="w-4 h-4 flex-shrink-0 mt-0.5" />
                 <p>This analysis is for informational purposes only and does not constitute financial advice. Trading carries significant risk.</p>
               </div>
             </>
          ) : (
            <div className="text-center text-textSecondary text-sm p-4">Unable to load signal data.</div>
          )}
        </aside>
      </main>
    </div>
  );
};

export default Dashboard;
