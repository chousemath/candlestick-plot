google.charts.load('current', {'packages':['corechart']});
google.charts.setOnLoadCallback(drawChart);

function korbitToGoogle(korbitData) {
  return [`${korbitData.start} - ${korbitData.end}`, korbitData.low, korbitData.open, korbitData.close, korbitData.high];
}

function drawChart() {
  var data;
  $.getJSON('https://raw.githubusercontent.com/chousemath/candlestick-plot/master/data/data.json', function(json) {
    data = google.visualization.arrayToDataTable(json.map(korbitToGoogle), true);
  }).done(function() {
    var options = {
      title : 'Korbit Transactions',
      legend:'none',
      explorer: {axis: 'horizontal', keepInBounds: true}
    };
    var chart = new google.visualization.CandlestickChart(document.getElementById('chart_div'));
    chart.draw(data, options);
  });
}
