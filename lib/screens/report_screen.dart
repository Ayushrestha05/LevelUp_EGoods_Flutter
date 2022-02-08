import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:levelup_egoods/utilities/models/report.dart';
import 'package:levelup_egoods/utilities/size_config.dart';
import 'package:levelup_egoods/widgets/buttons.dart';
import 'package:levelup_egoods/widgets/form_fields.dart';
import 'package:provider/provider.dart';

class ReportScreen extends StatelessWidget {
  const ReportScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: Container(
            margin: EdgeInsets.symmetric(
                horizontal: rWidth(20), vertical: rWidth(10)),
            child: DefaultButton("Submit Report", () {})),
        body: ChangeNotifierProvider<Report>(
          create: (context) => Report(),
          child: const Body(),
        ),
      ),
    );
  }
}

class Body extends StatelessWidget {
  const Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final report = Provider.of<Report>(context);
    return SingleChildScrollView(
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
                  validator:
                      RequiredValidator(errorText: 'Please Enter a Title'),
                ),
                SizedBox(
                  height: rWidth(20),
                ),
                CustomTextFormField(
                  hintText: "Report Description",
                  maxLines: null,
                  validator: RequiredValidator(
                      errorText: 'Please Provide a Description'),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
