import 'dart:convert';
import 'package:alert/alert.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:levelup_egoods/utilities/auth.dart';
import 'package:levelup_egoods/utilities/constants.dart';
import 'package:levelup_egoods/utilities/models/report.dart';
import 'package:levelup_egoods/utilities/size_config.dart';
import 'package:levelup_egoods/widgets/buttons.dart';
import 'package:levelup_egoods/widgets/form_fields.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

int? questionType = 0;
String? questionTitle = "";
String? questionDescription = "";

class ReportScreen extends StatelessWidget {
  ReportScreen({Key? key}) : super(key: key);
  final _reportFormKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: Container(
            margin: EdgeInsets.symmetric(
                horizontal: rWidth(20), vertical: rWidth(10)),
            child: DefaultButton("Submit Report", () {
              reportValidation(context);
            })),
        body: ChangeNotifierProvider<Report>(
          create: (context) => Report(),
          child: Body(
            formkey: _reportFormKey,
          ),
        ),
      ),
    );
  }

  void reportValidation(BuildContext context) async {
    if (_reportFormKey.currentState?.validate() ?? false) {
      _reportFormKey.currentState?.save();
      final auth = Provider.of<Auth>(context, listen: false);

      var response =
          await http.post(Uri.parse('$apiUrl/submit-report'), headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${auth.userToken}'
      }, body: {
        'question_type': '$questionType',
        'title': '$questionTitle',
        'description': '$questionDescription',
      });
      var decode = jsonDecode(response.body);
      if (response.statusCode == 201) {
        Alert(message: decode['message']).show();
        Navigator.pop(context);
      } else {
        Alert(message: decode['message']).show();
      }
    }
  }
}

class Body extends StatelessWidget {
  final Key? formkey;
  Body({Key? key, this.formkey}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final report = Provider.of<Report>(context);
    return SingleChildScrollView(
      child: Form(
        key: formkey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: rWidth(200),
              width: MediaQuery.of(context).size.width,
              child: Image.asset(
                'assets/images/report-header.jpg',
                fit: BoxFit.cover,
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(
                  horizontal: rWidth(20), vertical: rWidth(24)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Report",
                    style: TextStyle(
                        fontFamily: "Outfit",
                        fontSize: rWidth(32),
                        fontWeight: FontWeight.w300),
                  ),
                  SizedBox(
                    height: rWidth(20),
                  ),
                  CustomDropDown(
                    labelText: "Choose a Report",
                    dropDownItemList: report.decodeReportCategoryList,
                    onChanged: (value) {
                      print(value);
                    },
                    onSaved: (value) {
                      questionType = value;
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Please select a Report Category';
                      } else {
                        return null;
                      }
                    },
                  ),
                  SizedBox(
                    height: rWidth(20),
                  ),
                  CustomTextFormField(
                    hintText: "Report Title",
                    onSaved: (value) {
                      questionTitle = value;
                    },
                    maxLines: 1,
                    validator:
                        RequiredValidator(errorText: 'Please Enter a Title'),
                  ),
                  SizedBox(
                    height: rWidth(20),
                  ),
                  CustomTextFormField(
                    hintText: "Report Description",
                    maxLines: null,
                    onSaved: (value) {
                      questionDescription = value;
                    },
                    validator: RequiredValidator(
                        errorText: 'Please Provide a Description'),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
