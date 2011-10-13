class window.LedgerChartView extends Backbone.View
  el: "#ledger_overview"

  initialize: ->
    this.ids = this.options.ids
    this.render()

  render: ->
    _this = this
    url = "/ledgers/last_thirty_days"

    $.get(url, (data) ->
      _this.chart(data)
    )

  chart: (data) ->
    dataTable = new google.visualization.DataTable()
    dataTable.addColumn('string', 'Date')
    dataTable.addColumn('number', name) for name in data.names
    dataTable.addRows(data.info)

    chart = new google.visualization.AreaChart(this.$(".chart")[0])
    chart.draw(dataTable, {
      width: 820,
      height: 400,
      vAxis:{baseline:0, textStyle: {color: "#FFF"}},
      hAxis: {textStyle: {color: "#FFF"}}
      legend:'none',
      colors: ["#bac2ca"],
      lineWidth: 2,
      pointSize: 4,
      legend: "bottom",
      legendTextStyle: {color: "#FFF"},
      gridlineColor: "#1c2125",
      backgroundColor: {fill: "#2B3238"},
      chartArea: {left:50, top:20, width:"90%", height:"80%"}
    })

window.overviewChartFor = (ids) =>
  new OverviewChart({ids: ids})

