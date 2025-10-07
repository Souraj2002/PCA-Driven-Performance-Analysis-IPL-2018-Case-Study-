import React, { useState, useMemo } from 'react';
import { BarChart, Bar, XAxis, YAxis, CartesianGrid, Tooltip, Legend, ResponsiveContainer, ScatterChart, Scatter, LineChart, Line } from 'recharts';
import { TrendingUp, Users, Award, Calculator } from 'lucide-react';

const IPLPlayerRanking = () => {
  const [activeTab, setActiveTab] = useState('batsmen');
  const [methodTab, setMethodTab] = useState('ahp');

  // Top 20 Batsmen Data (from document)
  const batsmenData = [
    { name: 'Kane Williamson', runs: 735, avg: 52.5, sr: 142.44, fours: 64, sixes: 28, fifties: 8, boundaryPct: 17.83 },
    { name: 'Rishabh Pant', runs: 684, avg: 52.61, sr: 173.6, fours: 68, sixes: 37, fifties: 5, boundaryPct: 26.65 },
    { name: 'KL Rahul', runs: 659, avg: 54.91, sr: 158.41, fours: 66, sixes: 32, fifties: 6, boundaryPct: 23.56 },
    { name: 'Ambati Rayudu', runs: 602, avg: 43, sr: 149.75, fours: 53, sixes: 34, fifties: 3, boundaryPct: 21.64 },
    { name: 'Shane Watson', runs: 555, avg: 39.64, sr: 154.59, fours: 44, sixes: 35, fifties: 2, boundaryPct: 22.01 },
    { name: 'Jos Buttler', runs: 548, avg: 54.8, sr: 155.24, fours: 52, sixes: 21, fifties: 5, boundaryPct: 20.68 },
    { name: 'Virat Kohli', runs: 530, avg: 48.18, sr: 139.1, fours: 52, sixes: 18, fifties: 4, boundaryPct: 18.37 },
    { name: 'Suryakumar Yadav', runs: 512, avg: 36.57, sr: 133.33, fours: 61, sixes: 16, fifties: 4, boundaryPct: 20.05 },
    { name: 'Dinesh Karthik', runs: 498, avg: 49.8, sr: 147.77, fours: 49, sixes: 16, fifties: 2, boundaryPct: 19.29 },
    { name: 'Shikhar Dhawan', runs: 497, avg: 38.23, sr: 136.91, fours: 59, sixes: 14, fifties: 4, boundaryPct: 20.11 },
    { name: 'Chris Lynn', runs: 491, avg: 32.73, sr: 130.23, fours: 56, sixes: 18, fifties: 3, boundaryPct: 19.63 },
    { name: 'AB de Villiers', runs: 480, avg: 53.33, sr: 174.54, fours: 39, sixes: 30, fifties: 6, boundaryPct: 25.09 },
    { name: 'MS Dhoni', runs: 455, avg: 75.83, sr: 150.66, fours: 24, sixes: 30, fifties: 3, boundaryPct: 17.88 },
    { name: 'Suresh Raina', runs: 445, avg: 37.08, sr: 132.44, fours: 46, sixes: 12, fifties: 4, boundaryPct: 17.26 },
    { name: 'Sanju Samson', runs: 441, avg: 31.5, sr: 137.81, fours: 30, sixes: 19, fifties: 3, boundaryPct: 15.31 },
    { name: 'Shreyas Iyer', runs: 411, avg: 37.36, sr: 132.58, fours: 29, sixes: 21, fifties: 4, boundaryPct: 16.13 },
    { name: 'Evin Lewis', runs: 382, avg: 29.38, sr: 138.4, fours: 32, sixes: 24, fifties: 2, boundaryPct: 20.29 },
    { name: 'Ajinkya Rahane', runs: 370, avg: 28.46, sr: 118.21, fours: 39, sixes: 5, fifties: 1, boundaryPct: 14.06 },
    { name: 'Chris Gayle', runs: 368, avg: 40.88, sr: 146.03, fours: 30, sixes: 27, fifties: 3, boundaryPct: 22.62 },
    { name: 'Sunil Narine', runs: 357, avg: 22.31, sr: 189.89, fours: 40, sixes: 23, fifties: 2, boundaryPct: 33.51 }
  ];

  // Top 20 Bowlers Data (from document)
  const bowlersData = [
    { name: 'Andrew Tye', wickets: 24, avg: 18.66, econ: 8, sr: 14 },
    { name: 'Rashid Khan', wickets: 21, avg: 21.8, econ: 6.73, sr: 19.42 },
    { name: 'Siddarth Kaul', wickets: 21, avg: 26.04, econ: 8.28, sr: 18.85 },
    { name: 'Umesh Yadav', wickets: 20, avg: 20.9, econ: 7.86, sr: 15.95 },
    { name: 'Trent Boult', wickets: 18, avg: 25.88, econ: 8.84, sr: 17.55 },
    { name: 'Hardik Pandya', wickets: 18, avg: 21.16, econ: 8.92, sr: 14.22 },
    { name: 'Sunil Narine', wickets: 17, avg: 27.47, econ: 7.65, sr: 21.52 },
    { name: 'Kuldeep Yadav', wickets: 17, avg: 24.58, econ: 8.14, sr: 18.11 },
    { name: 'Jasprit Bumrah', wickets: 17, avg: 21.88, econ: 6.88, sr: 19.05 },
    { name: 'Shardul Thakur', wickets: 16, avg: 26.93, econ: 9.23, sr: 17.5 },
    { name: 'Mayank Markande', wickets: 15, avg: 24.53, econ: 8.36, sr: 17.6 },
    { name: 'Jofra Archer', wickets: 15, avg: 21.66, econ: 8.36, sr: 15.53 },
    { name: 'Shakib Al Hasan', wickets: 14, avg: 32.57, econ: 8, sr: 24.42 },
    { name: 'Dwayne Bravo', wickets: 14, avg: 38.07, econ: 9.96, sr: 22.92 },
    { name: 'Piyush Chawla', wickets: 14, avg: 29.42, econ: 8.4, sr: 21 },
    { name: 'Mujeeb Ur Rahman', wickets: 14, avg: 20.64, econ: 6.99, sr: 17.71 },
    { name: 'Mitchell McClenaghan', wickets: 14, avg: 23.71, econ: 8.3, sr: 17.14 },
    { name: 'Andre Russell', wickets: 13, avg: 27.3, econ: 9.38, sr: 17.46 },
    { name: 'Krunal Pandya', wickets: 12, avg: 23.66, econ: 7.07, sr: 20.08 },
    { name: 'Yuzvendra Chahal', wickets: 12, avg: 30.25, econ: 7.26, sr: 25 }
  ];

  // AHP Method Rankings
  const ahpBatsmenRankings = useMemo(() => {
    return batsmenData.map(player => {
      const rating = Math.pow(player.runs, 0.33) * Math.pow(player.sr, 0.37) * Math.pow(player.boundaryPct, 0.30);
      return { ...player, rating };
    }).sort((a, b) => b.rating - a.rating).map((p, i) => ({ ...p, rank: i + 1 }));
  }, []);

  const ahpBowlersRankings = useMemo(() => {
    return bowlersData.map(player => {
      const rating = Math.pow(player.econ, 0.37) * Math.pow(player.sr, 0.33) * Math.pow(player.avg, 0.30);
      return { ...player, rating };
    }).sort((a, b) => a.rating - b.rating).map((p, i) => ({ ...p, rank: i + 1 }));
  }, []);

  // PCA Method Rankings (simplified - using weighted combination)
  const pcaBatsmenRankings = useMemo(() => {
    return batsmenData.map(player => {
      const rating = player.runs * 0.459 + player.avg * 0.416 + player.sr * 0.25 + 
                     player.fours * 0.433 + player.sixes * 0.429 + player.fifties * 0.427;
      return { ...player, rating };
    }).sort((a, b) => b.rating - a.rating).map((p, i) => ({ ...p, rank: i + 1 }));
  }, []);

  const pcaBowlersRankings = useMemo(() => {
    return bowlersData.map(player => {
      const rating = player.wickets * (-0.477) + player.avg * 0.59 + 
                     player.econ * 0.35 + player.sr * 0.549;
      return { ...player, rating };
    }).sort((a, b) => a.rating - b.rating).map((p, i) => ({ ...p, rank: i + 1 }));
  }, []);

  const currentBatsmenData = methodTab === 'ahp' ? ahpBatsmenRankings : pcaBatsmenRankings;
  const currentBowlersData = methodTab === 'ahp' ? ahpBowlersRankings : pcaBowlersRankings;

  const topPerformers = activeTab === 'batsmen' 
    ? currentBatsmenData.slice(0, 10) 
    : currentBowlersData.slice(0, 10);

  return (
    <div className="w-full max-w-7xl mx-auto p-6 bg-gradient-to-br from-blue-50 to-indigo-50">
      <div className="bg-white rounded-lg shadow-xl p-6 mb-6">
        <div className="flex items-center justify-between mb-6">
          <div>
            <h1 className="text-3xl font-bold text-gray-800 flex items-center gap-3">
              <Award className="text-yellow-500" size={36} />
              IPL 2018 Player Ranking System
            </h1>
            <p className="text-gray-600 mt-2">Advanced Analytics using AHP & PCA Methodologies</p>
          </div>
        </div>

        {/* Method Selection */}
        <div className="flex gap-4 mb-6">
          <button
            onClick={() => setMethodTab('ahp')}
            className={`px-6 py-3 rounded-lg font-semibold transition-all ${
              methodTab === 'ahp'
                ? 'bg-blue-600 text-white shadow-lg'
                : 'bg-gray-200 text-gray-700 hover:bg-gray-300'
            }`}
          >
            <Calculator className="inline mr-2" size={20} />
            AHP Method
          </button>
          <button
            onClick={() => setMethodTab('pca')}
            className={`px-6 py-3 rounded-lg font-semibold transition-all ${
              methodTab === 'pca'
                ? 'bg-indigo-600 text-white shadow-lg'
                : 'bg-gray-200 text-gray-700 hover:bg-gray-300'
            }`}
          >
            <TrendingUp className="inline mr-2" size={20} />
            PCA Method
          </button>
        </div>

        {/* Category Selection */}
        <div className="flex gap-4 mb-6">
          <button
            onClick={() => setActiveTab('batsmen')}
            className={`flex-1 px-6 py-3 rounded-lg font-semibold transition-all ${
              activeTab === 'batsmen'
                ? 'bg-green-600 text-white shadow-lg'
                : 'bg-gray-200 text-gray-700 hover:bg-gray-300'
            }`}
          >
            <Users className="inline mr-2" size={20} />
            Batsmen Rankings
          </button>
          <button
            onClick={() => setActiveTab('bowlers')}
            className={`flex-1 px-6 py-3 rounded-lg font-semibold transition-all ${
              activeTab === 'bowlers'
                ? 'bg-red-600 text-white shadow-lg'
                : 'bg-gray-200 text-gray-700 hover:bg-gray-300'
            }`}
          >
            <Users className="inline mr-2" size={20} />
            Bowlers Rankings
          </button>
        </div>

        {/* Method Description */}
        <div className="bg-blue-50 border-l-4 border-blue-500 p-4 mb-6 rounded">
          <h3 className="font-bold text-blue-900 mb-2">
            {methodTab === 'ahp' ? 'Analytic Hierarchy Process (AHP)' : 'Principal Component Analysis (PCA)'}
          </h3>
          <p className="text-blue-800 text-sm">
            {methodTab === 'ahp' 
              ? activeTab === 'batsmen'
                ? 'Weighted formula: Runs^0.33 × Strike Rate^0.37 × Boundary%^0.30 (Higher is better)'
                : 'Weighted formula: Economy^0.37 × Strike Rate^0.33 × Average^0.30 (Lower is better)'
              : activeTab === 'batsmen'
                ? 'PCA weights: Runs(0.459) + Avg(0.416) + SR(0.25) + 4s(0.433) + 6s(0.429) + 50s(0.427)'
                : 'PCA weights: Wickets(-0.477) + Avg(0.59) + Econ(0.35) + SR(0.549)'
            }
          </p>
        </div>

        {/* Rankings Chart */}
        <div className="bg-white rounded-lg p-6 mb-6">
          <h3 className="text-xl font-bold mb-4 text-gray-800">
            Top 10 {activeTab === 'batsmen' ? 'Batsmen' : 'Bowlers'} - {methodTab.toUpperCase()} Rankings
          </h3>
          <ResponsiveContainer width="100%" height={400}>
            <BarChart data={topPerformers} layout="vertical">
              <CartesianGrid strokeDasharray="3 3" />
              <XAxis type="number" />
              <YAxis dataKey="name" type="category" width={150} />
              <Tooltip 
                content={({ active, payload }) => {
                  if (active && payload && payload[0]) {
                    const data = payload[0].payload;
                    return (
                      <div className="bg-white p-4 border border-gray-300 rounded shadow-lg">
                        <p className="font-bold">{data.name}</p>
                        <p className="text-sm">Rank: {data.rank}</p>
                        <p className="text-sm">Rating: {data.rating.toFixed(2)}</p>
                        {activeTab === 'batsmen' ? (
                          <>
                            <p className="text-sm">Runs: {data.runs}</p>
                            <p className="text-sm">Avg: {data.avg}</p>
                            <p className="text-sm">SR: {data.sr}</p>
                          </>
                        ) : (
                          <>
                            <p className="text-sm">Wickets: {data.wickets}</p>
                            <p className="text-sm">Avg: {data.avg}</p>
                            <p className="text-sm">Econ: {data.econ}</p>
                          </>
                        )}
                      </div>
                    );
                  }
                  return null;
                }}
              />
              <Legend />
              <Bar dataKey="rating" fill={activeTab === 'batsmen' ? '#10b981' : '#ef4444'} name="Performance Rating" />
            </BarChart>
          </ResponsiveContainer>
        </div>

        {/* Detailed Rankings Table */}
        <div className="bg-white rounded-lg p-6 overflow-x-auto">
          <h3 className="text-xl font-bold mb-4 text-gray-800">Detailed Rankings</h3>
          <table className="w-full text-sm">
            <thead className="bg-gray-100">
              <tr>
                <th className="p-3 text-left">Rank</th>
                <th className="p-3 text-left">Player</th>
                <th className="p-3 text-right">Rating</th>
                {activeTab === 'batsmen' ? (
                  <>
                    <th className="p-3 text-right">Runs</th>
                    <th className="p-3 text-right">Avg</th>
                    <th className="p-3 text-right">SR</th>
                    <th className="p-3 text-right">4s/6s</th>
                  </>
                ) : (
                  <>
                    <th className="p-3 text-right">Wickets</th>
                    <th className="p-3 text-right">Avg</th>
                    <th className="p-3 text-right">Econ</th>
                    <th className="p-3 text-right">SR</th>
                  </>
                )}
              </tr>
            </thead>
            <tbody>
              {topPerformers.map((player, idx) => (
                <tr key={idx} className={idx % 2 === 0 ? 'bg-gray-50' : ''}>
                  <td className="p-3 font-bold">{player.rank}</td>
                  <td className="p-3">{player.name}</td>
                  <td className="p-3 text-right font-semibold">{player.rating.toFixed(2)}</td>
                  {activeTab === 'batsmen' ? (
                    <>
                      <td className="p-3 text-right">{player.runs}</td>
                      <td className="p-3 text-right">{player.avg}</td>
                      <td className="p-3 text-right">{player.sr}</td>
                      <td className="p-3 text-right">{player.fours}/{player.sixes}</td>
                    </>
                  ) : (
                    <>
                      <td className="p-3 text-right">{player.wickets}</td>
                      <td className="p-3 text-right">{player.avg}</td>
                      <td className="p-3 text-right">{player.econ}</td>
                      <td className="p-3 text-right">{player.sr}</td>
                    </>
                  )}
                </tr>
              ))}
            </tbody>
          </table>
        </div>

        {/* Key Insights */}
        <div className="mt-6 grid grid-cols-1 md:grid-cols-2 gap-4">
          <div className="bg-gradient-to-r from-green-100 to-green-50 p-4 rounded-lg border border-green-200">
            <h4 className="font-bold text-green-900 mb-2">Key Insight - Batsmen</h4>
            <p className="text-sm text-green-800">
              {methodTab === 'ahp' 
                ? 'Strike rate and boundary percentage heavily influence T20 rankings. Aggressive batsmen rank higher despite lower total runs.'
                : 'First principal component explains 75% of variance, with strong loadings on runs, fours, and sixes.'
              }
            </p>
          </div>
          <div className="bg-gradient-to-r from-red-100 to-red-50 p-4 rounded-lg border border-red-200">
            <h4 className="font-bold text-red-900 mb-2">Key Insight - Bowlers</h4>
            <p className="text-sm text-red-800">
              {methodTab === 'ahp'
                ? 'Economy rate is the most critical factor in T20 bowling, followed by strike rate. Wicket-taking ability must balance with run control.'
                : 'PCA reveals wickets, economy, and strike rate are highly correlated. First component captures 66% of bowling performance variance.'
              }
            </p>
          </div>
        </div>
      </div>
    </div>
  );
};

export default IPLPlayerRanking;