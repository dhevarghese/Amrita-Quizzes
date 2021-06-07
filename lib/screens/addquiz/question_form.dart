import 'package:amrita_quizzes/models/Questions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class QuestionForm extends StatefulWidget{

  final int qNumber;
  final int maxScore;
  final Question editQ;
  const QuestionForm ({ Key key, this.qNumber, this.maxScore, this.editQ }): super(key: key);

  @override
  _QuestionState createState() => _QuestionState();

}

class _QuestionState extends State<QuestionForm>{

  var curIndex = 0;
  @override
  void initState(){
    super.initState();
    if(widget.editQ == null){
      radioOptions.add(_addOption(curIndex));
    }
    else{
      for(var option in widget.editQ.options){
        radioOptions.add(_addOption(curIndex, option));
        curIndex+=1;
      }
    }
  }
  List<FormBuilderFieldOption> radioOptions = [];
  List<FormBuilderFieldOption> _getRadioOptions(){
    return radioOptions;
  }

  Widget _addOption(var index, [var option]){
    return FormBuilderFieldOption(value: index, child: _rOption(index, option));
  }

  Widget _rOption(var index, [var option]){
    return Row(
      children: [
        Expanded(child: FormBuilderTextField(name: 'Question'+widget.qNumber.toString() + '_Option' + index.toString(),
            validator: FormBuilderValidators.required(context),
            initialValue: (option==null) ? null : option,
            decoration: InputDecoration(
              labelText: 'Option',
            )
        )
        ),
        SizedBox(width: 16),
        // we need add button at last friends row
        _addRemoveButton(index),
      ],
    );
  }

  Widget _addRemoveButton(int index){
    return InkWell(
      onTap: (){
        curIndex-=1;
        radioOptions.removeAt(index);
        setState((){});
      },
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(Icons.remove, color: Colors.white),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FormBuilderSlider(name: 'mark'+ widget.qNumber.toString(),
          min: 1.0,
          max: (widget.maxScore/2).roundToDouble(),
          initialValue: (widget.editQ?.mark == null) ? 1.0 : widget.editQ.mark.toDouble(),
          divisions: (widget.maxScore/2).round()-1,
          activeColor: Colors.blue,
          inactiveColor: Colors.lightBlueAccent,
          decoration: InputDecoration(
            //icon: Icon(Icons.question_answer, color: Colors.lightBlueAccent,),
            labelText: 'Marks',
            border: InputBorder.none,
          ),
        ),
        FormBuilderTextField(name: 'Question' + widget.qNumber.toString(),
            validator: FormBuilderValidators.required(context),
            initialValue: (widget.editQ == null) ? null : widget.editQ.question,
            maxLines: 2,
            decoration: InputDecoration(
              labelText: 'Question',
              hintText: 'ML Quiz',
              //border: OutlineInputBorder(),
            )
        ),
        FormBuilderRadioGroup(
          name: 'Question'+widget.qNumber.toString()+"_Correct_Choice",
          initialValue: (widget.editQ?.answer == null)? null : widget.editQ.answer,
          validator: FormBuilderValidators.required(context),
          options: _getRadioOptions(),
          decoration: const InputDecoration(border: InputBorder.none),
        ),
        TextButton(
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
          ),
          onPressed: () {
            curIndex+=1;
            radioOptions.add(_addOption(curIndex));
            setState((){});
          },
          child: Text("Add option"),
        ),
      ],
    );
  }
}