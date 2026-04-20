import React, { useEffect, useRef } from 'react';
import { createChart, CrosshairMode } from 'lightweight-charts';

export const Chart = ({ asset }) => {
  const chartContainerRef = useRef();
  const chartRef = useRef();

  useEffect(() => {
    const handleResize = () => {
      if (chartRef.current && chartContainerRef.current) {
        chartRef.current.applyOptions({
          width: chartContainerRef.current.clientWidth,
          height: chartContainerRef.current.clientHeight,
        });
      }
    };

    const chartOptions = {
      layout: {
        background: { type: 'solid', color: '#161b22' },
        textColor: '#8b949e',
      },
      grid: {
        vertLines: { color: '#30363d' },
        horzLines: { color: '#30363d' },
      },
      crosshair: {
        mode: CrosshairMode.Normal,
      },
      timeScale: {
        timeVisible: true,
        secondsVisible: false,
      },
      width: chartContainerRef.current.clientWidth,
      height: chartContainerRef.current.clientHeight,
    };

    const chart = createChart(chartContainerRef.current, chartOptions);
    chartRef.current = chart;

    const areaSeries = chart.addAreaSeries({
      lineColor: '#2962ff',
      topColor: 'rgba(41, 98, 255, 0.4)',
      bottomColor: 'rgba(41, 98, 255, 0.0)',
      lineWidth: 2,
    });

    const fetchData = async () => {
      try {
        const response = await fetch(`http://localhost:5000/api/market-data/${asset}`);
        const data = await response.json();
        
        areaSeries.setData(data.sort((a, b) => a.time - b.time));
        chart.timeScale().fitContent();
      } catch (error) {
        console.error("Failed to fetch market data", error);
      }
    };

    fetchData();

    window.addEventListener('resize', handleResize);

    return () => {
      window.removeEventListener('resize', handleResize);
      chart.remove();
    };
  }, [asset]);

  return (
    <div className="w-full h-full relative" ref={chartContainerRef} />
  );
};
