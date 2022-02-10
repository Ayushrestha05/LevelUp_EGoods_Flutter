import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:levelup_egoods/utilities/models/report.dart';
import 'package:levelup_egoods/utilities/size_config.dart';
import 'package:levelup_egoods/widgets/buttons.dart';
import 'package:levelup_egoods/widgets/form_fields.dart';
import 'package:provider/provider.dart';

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
              reportValidation();
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

  void reportValidation() {
    if (_reportFormKey.currentState?.validate() ?? false) {
      _reportFormKey.currentState?.save();
      print(questionType);
      print(questionTitle);
      print(questionDescription);
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
