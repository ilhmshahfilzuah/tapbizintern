class ChartData {
  ChartData(
    this.x,
    this.y,
    this.text,
  );
  final String x;
  final double y;
  final String text;
}

class ChartDataBar {
  ChartDataBar(this.x, this.high, this.low);
  final String x;
  final double high;
  final double low;
}

class ChartMultiData {
  ChartMultiData(this.x, this.y, this.y1);
  final String x;
  final double? y;
  final double? y1;
}
