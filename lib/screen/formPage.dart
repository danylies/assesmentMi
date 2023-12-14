import 'dart:convert';
import 'dart:developer';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class FormPage extends StatefulWidget {
  const FormPage({super.key});
  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  bool loading = false;
  final RegExp _alphaRegex = RegExp(r'^[a-zA-Z]+$');
  final RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  String outputData = "", titleoutputData = "";
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController numberContact = TextEditingController();
  TextEditingController email = TextEditingController();

  Future<void> getData(
      firstNameData, lastNameData, numberContactData, emailData) async {
    try {
      setState(() {
        loading = true;
      });
      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };
      final response = await http.get(
          Uri.parse(
              "https://integration.micaresvc.com/interviewapi/AssessmentTestRSVP?ApiKey=123456&FirstName=$firstNameData&LastName=$lastNameData&ContactNo=$numberContactData&Email=$emailData"),
          headers: headers);
      setState(() {
        final data = response.body.toString();
        if (data.isEmpty) {
          titleoutputData = "SORRY";
          outputData =
              "This system is currently experiencing technical difficulties. Please try again later.";
        } else if (data.toString() ==
            "Thank you for your submission. RSVP form was submitted successfully.") {
          titleoutputData = "THANK YOU";
          outputData = data.toString();
        } else {
          titleoutputData = "SORRY";
          outputData =
              "This system is currently experiencing technical difficulties. Please try again later.";
        }
        loading = false;
        dialogForm();
        print("test : $data");
      });
    } catch (e) {
      setState(() {
        titleoutputData = "SORRY";
        outputData =
            "This system is currently experiencing technical difficulties. Please try again later.";
        dialogForm();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.red[400],
      ),
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              color: Colors.red[400],
              width: double.infinity,
              height: 250,
              child: const Column(
                children: [
                  Text(
                    "RSVP FORM",
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: 40,
                    child: VerticalDivider(thickness: 1, color: Colors.white),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Kindly respond by February 06,2021",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  Text(
                    "We look forward to celebrate with you",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w300,
                        color: Colors.white),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 180, left: 20, right: 20),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      constraints: const BoxConstraints(maxHeight: 480),
                      padding: const EdgeInsets.all(40.0),
                      width: double.infinity,
                      //height: MediaQuery.of(context).size.height / 1.8,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 2,
                            offset: const Offset(
                                0, 0), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                            "Please enter all the fields",
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.blue,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Expanded(
                            child: TextFormField(
                              controller: firstName,
                              decoration: const InputDecoration(
                                  labelText: 'First Name',
                                  hintText: 'Enter First Name',
                                  isDense: true),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(_alphaRegex),
                              ],
                            ),
                          ),
                          const SizedBox(
                              height: 40.0), // Add spacing between text fields
                          Expanded(
                            child: TextFormField(
                              controller: lastName,
                              decoration: const InputDecoration(
                                labelText: 'Last Name',
                                hintText: 'Enter Last Name',
                              ),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(_alphaRegex),
                              ],
                            ),
                          ),
                          const SizedBox(
                              height: 40.0), // Add spacing between text fields
                          Expanded(
                            child: TextFormField(
                              controller: numberContact,
                              decoration: const InputDecoration(
                                labelText: 'Contact Number',
                                hintText: 'Enter Contact Number',
                              ),
                              keyboardType: TextInputType.number,
                              // inputFormatters: [
                              //   FilteringTextInputFormatter.allow(
                              //       _phoneNumberRegex),
                              //   LengthLimitingTextInputFormatter(14),
                              // ],
                            ),
                          ),
                          const SizedBox(height: 40.0),
                          Expanded(
                            child: TextFormField(
                              controller: email,
                              decoration: InputDecoration(
                                labelText: 'Email',
                                hintText: 'Enter Email',
                              ),
                              keyboardType: TextInputType.emailAddress,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        //fixedSize: Size(200, 50)
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      onPressed: loading
                          ? null
                          : () {
                              if (firstName.text.toString().isEmpty ||
                                  lastName.text.toString().isEmpty ||
                                  numberContact.text.toString().isEmpty ||
                                  email.text.toString().isEmpty) {
                                showToast(context,
                                    'Please fill out all required fields before proceeding');
                              } else if (numberContact.text.length < 8 ||
                                  numberContact.text.length > 12) {
                                showToast(context,
                                    'Please fill out number contact again');
                              } else if (!emailRegex.hasMatch(email.text)) {
                                showToast(
                                    context, 'Please fill out email again');
                              } else {
                                getData(
                                    firstName.text.toString(),
                                    lastName.text.toString(),
                                    numberContact.text.toString(),
                                    email.text.toString());
                              }

                              // print(firstName.text.toString() +
                              //     "  " +
                              //     lastName.text.toString() +
                              //     "  " +
                              //     numberContact.text.toString() +
                              //     "  " +
                              //     email.text.toString());
                            },
                      child: loading
                          ? const Center(
                              child: SizedBox(
                                width: 40,
                                height: 20,
                                child: LoadingIndicator(
                                  indicatorType: Indicator.ballPulse,
                                  colors: [
                                    Colors.white,
                                  ],
                                  strokeWidth: 1,
                                ),
                              ),
                            )
                          : Text("Submit"),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future dialogForm() {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          title: Text(
            titleoutputData.toString(),
            style: const TextStyle(
                color: Colors.blue, fontSize: 16, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          content: Text(
            outputData.toString(),
            style: const TextStyle(
              fontSize: 13,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[
            Center(
              child: ConstrainedBox(
                constraints: BoxConstraints.tightFor(
                    width: MediaQuery.of(context).size.width / 2.2,
                    height: MediaQuery.of(context).size.height / 18),
                child: ElevatedButton(
                  onPressed: () {
                    firstName.clear();
                    lastName.clear();
                    numberContact.clear();
                    email.clear();
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Ok",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    textStyle: const TextStyle(fontSize: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        );
      },
    );
  }

  void showToast(BuildContext context, String message) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }
}
