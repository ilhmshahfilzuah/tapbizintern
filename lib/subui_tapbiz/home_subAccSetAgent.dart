import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../subconfig/AppSettings.dart';

class PageAccSetAgent extends StatefulWidget {
  @override
  _PageAccSetAgentState createState() => _PageAccSetAgentState();
}

class _PageAccSetAgentState extends State<PageAccSetAgent> with SingleTickerProviderStateMixin {
  String? userGroupidQuery;
  String? userGroupQuery;
  String? userQuery;
  String? userFlagdelQuery;
  String? userNFCTAGidQuery;
  String? userQueryAction;
  String? userQueryActionField;
  String? userQueryActionFieldName;

  TextEditingController dataObjController = TextEditingController();
  String dataObj = '';

  String? actionQuery;
  String? actionTextQuery;

  var _formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Text('PageAccSetAgent'),
        Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0),
          child: _addForm(),
        )
      ],
    );
  }

  Widget _addForm() {
    userQueryActionFieldName = 'Agent Verification Code';
    dataObj = dataObjController.text;
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // SizedBox(height: 30),
          // Text('$userQueryActionField'),
          Padding(
            padding: EdgeInsets.only(top: 30.0, bottom: 5.0),
            child: TextFormField(
              minLines: 1, //Normal textInputField will be displayed
              maxLines: 6, // when user presses enter it will adapt to it
              controller: dataObjController,
              validator: (value) => value!.isEmpty ? 'Enter $userQueryActionFieldName' : null,
              onFieldSubmitted: (value) {
                if (_formKey.currentState!.validate()) {
                  // _updateHadir(dataICNOSIRI!);
                }
              },

              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(8.0),
                labelText: '$userQueryActionFieldName',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
              onChanged: (value) {
                updateObj();
              },
            ),
          ),
          (actionTextQuery == null) ? Container() : Text('$actionTextQuery'),
          Text('  '),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 25,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith((states) {
                        return AppSettings.ColorMain;
                        // return Colors.grey;
                      }),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Submit", style: TextStyle(color: Colors.white, fontSize: 16.0, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    onPressed: () {
                      // setState(() {
                      //   actionTextQuery = null;
                      // });
                      // if (_formKey.currentState!.validate()) {
                      //   if (actionQuery == 'AddGroup') {
                      //     _addDb_Group();
                      //   }
                      //   if (actionQuery == 'AddCard') {
                      //     _addDb_UserDemo();
                      //   }
                      // }
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  updateObj() {
    setState(() {
      dataObj = dataObjController.text;
    });
  }
}
