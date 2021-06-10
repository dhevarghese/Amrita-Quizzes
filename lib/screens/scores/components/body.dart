
import 'package:amrita_quizzes/models/Quiz.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Body extends StatefulWidget {
  final Map scoresData;
  final Map moreScoreData;
  final Quiz quizInfo;
  Body(this.quizInfo, this.scoresData, this.moreScoreData, {Key key}) : super(key: key);

  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<BarChartGroupData> barData = [];
    for(int temp = 0; temp<widget.scoresData.length; temp++){
      int score = (widget.scoresData.values.elementAt(temp) == null) ? 0 : widget.scoresData.values.elementAt(temp)[0];
      barData.add(
          BarChartGroupData(
            x: temp,
            barRods: [
              BarChartRodData(y: score.toDouble(), colors: (widget.scoresData.values.elementAt(temp) == null)? [Colors.lightBlueAccent, Colors.redAccent] : (widget.scoresData.values.elementAt(temp)[0] /widget.scoresData.values.elementAt(temp)[1] > 0.80) ? [Colors.lightBlueAccent, Colors.greenAccent] : (widget.scoresData.values.elementAt(temp)[0] /widget.scoresData.values.elementAt(temp)[1] > 0.50) ? [Colors.lightBlueAccent, Colors.amber[400]] : [Colors.lightBlueAccent, Colors.redAccent])
            ],
            showingTooltipIndicators: [0],
          )
      );
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(int.parse('0x'+widget.quizInfo.color)),
        iconTheme: IconThemeData(
            color: Colors.white
        ),
        title: Text("Report", style: TextStyle(
            color: Colors.white
        ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(8),
          child: Column(
            children: [
              Card(
                  margin: EdgeInsets.fromLTRB(16.0,16,16,0),
                  shadowColor: Colors.redAccent,
                  child: ListTile(
                    leading: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Icon(Icons.info,
                          color: Colors.redAccent
                      ),
                    ),
                    title: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text("NA Students have not yet attempted the Quiz! ", style: TextStyle(color: Colors.redAccent),),
                    ),
                  )
              ),
              Card(
                  margin: EdgeInsets.fromLTRB(16.0,16,16,0),
                  shadowColor: Colors.lightBlueAccent,
                  child: ListTile(
                    leading: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Icon(Icons.elevator,
                          color: Colors.lightBlueAccent
                      ),
                    ),
                    title: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(widget.moreScoreData["NAC"].toString() + " out of " + widget.scoresData.length.toString() + " invited have taken the quiz", style: TextStyle(color: Colors.lightBlueAccent),),
                    ),
                  )
              ),
              Card(
                  margin: EdgeInsets.fromLTRB(16.0,16,16,0),
                  shadowColor: Colors.greenAccent,
                  child: ListTile(
                    leading: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Icon(Icons.bubble_chart,
                          color: Colors.greenAccent
                      ),
                    ),
                    title: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text("The average score is " + (widget.moreScoreData["total_Score"]/widget.moreScoreData["takers_Count"]).toString() +"\nPerformances visualised below", style: TextStyle(color: Colors.green),),
                    ),
                  )
              ),
              SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.fromLTRB(12,0,12,0),
                child: AspectRatio(
                  aspectRatio: 1.7,
                  child: Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                    color: const Color(0xff2c4260),
                    child: BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.spaceAround,
                        maxY: double.parse((widget.moreScoreData["Max_Score"]+5).toString()),
                        barTouchData: BarTouchData(
                          enabled: false,
                          touchTooltipData: BarTouchTooltipData(
                            tooltipBgColor: Colors.transparent,
                            tooltipPadding: const EdgeInsets.all(0),
                            tooltipMargin: 8,
                            getTooltipItem: (
                                BarChartGroupData group,
                                int groupIndex,
                                BarChartRodData rod,
                                int rodIndex,
                                ) {
                              return BarTooltipItem(
                                rod.y.round().toString(),
                                TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            },
                          ),
                        ),
                        titlesData: FlTitlesData(
                          show: true,
                          bottomTitles: SideTitles(
                            showTitles: true,
                            getTextStyles: (value) => const TextStyle(
                                color: Color(0xff7589a2), fontWeight: FontWeight.bold, fontSize: 14),
                            margin: 20,
                            getTitles: (double value) {
                              return widget.scoresData.keys.elementAt(value.toInt());
                            },
                          ),
                          leftTitles: SideTitles(showTitles: false),
                        ),
                        borderData: FlBorderData(
                          show: false,
                        ),
                        barGroups: barData,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                height: 300,
                child: getScores(),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget getScores(){
    return ListView.builder(
      itemCount: widget.scoresData.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
          child: Card(
            color: (widget.scoresData.values.elementAt(index) == null ) ? Colors.redAccent : (widget.scoresData.values.elementAt(index)[0] /widget.scoresData.values.elementAt(index)[1] > 0.80) ? Colors.greenAccent : (widget.scoresData.values.elementAt(index)[0] /widget.scoresData.values.elementAt(index)[1] > 0.50) ? Colors.amber[400] : Colors.redAccent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: ListTile(
              title: Text('${widget.scoresData.keys.elementAt(index)}' , style: TextStyle(color: Colors.white),),
              trailing: (widget.scoresData.values.elementAt(index) == null ) ? Text("NA", style: TextStyle(color: Colors.white),) : Text('${widget.scoresData.values.elementAt(index)[0]} / ${widget.scoresData.values.elementAt(index)[1]}', style: TextStyle(color: Colors.white),),
            ),
          ),
        );
      },
    );
  }
}