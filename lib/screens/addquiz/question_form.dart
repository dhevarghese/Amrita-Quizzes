import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class QuestionForm extends StatefulWidget{

  final int qNumber;
  const QuestionForm ({ Key key, this.qNumber }): super(key: key);

  @override
  _QuestionState createState() => _QuestionState();

}

class _QuestionState extends State<QuestionForm>{

  var curIndex = 0;
  @override
  void initState(){
    super.initState();
    radioOptions.add(_addOption(curIndex));
  }
  List<FormBuilderFieldOption> radioOptions = [];
  List<FormBuilderFieldOption> _getRadioOptions(){
    return radioOptions;
  }

  Widget _addOption(var index){
    return FormBuilderFieldOption(value: index, child: _rOption(index));
  }

  Widget _rOption(var index){
    return Row(
      children: [
        Expanded(child: FormBuilderTextField(name: 'Question'+widget.qNumber.toString() + '_Option' + index.toString(),
            validator: FormBuilderValidators.required(context),
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
        FormBuilderTextField(name: 'Question' + widget.qNumber.toString(),
            validator: FormBuilderValidators.required(context),
            decoration: InputDecoration(
              labelText: 'Question',
              hintText: 'ML Quiz',
              //border: OutlineInputBorder(),
            )
        ),
        FormBuilderRadioGroup(
          name: 'Question'+widget.qNumber.toString()+"_Correct_Choice",
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