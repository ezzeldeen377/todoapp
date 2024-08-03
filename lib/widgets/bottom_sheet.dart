import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/app_colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:to_do_app/firestore_utils.dart';
import 'package:to_do_app/moduls/task.dart';
import 'package:to_do_app/provider/Appprovider.dart';
import 'package:to_do_app/widgets/my_text_form_field.dart';
import '../provider/list_provider.dart';
class MyBottomSheet extends StatefulWidget {

  @override
  State<MyBottomSheet> createState() => _MyBottomSheetState();
}

class _MyBottomSheetState extends State<MyBottomSheet> {
  var formkey = GlobalKey<FormState>();
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime= TimeOfDay.now();
  TextEditingController name = TextEditingController();
  TextEditingController description = TextEditingController();
   late ListProvider listProvider;

  @override
  Widget build(BuildContext context) {
     listProvider= Provider.of<ListProvider>(context);
    var provider = Provider.of<AppProvider>(context);

    return Padding(
      padding:  EdgeInsets.only(
          bottom:MediaQuery.of(context).viewInsets.bottom

      ),
      child: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10)
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(AppLocalizations.of(context)!.add_new_task,
                  style: provider.isDark() ?
                  Theme
                      .of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(
                      color: AppColors.whiteColor
                  ) :
                  Theme
                      .of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(
                      color: AppColors.blackColor
                  ),
                  textAlign: TextAlign.center,
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Form(
                      key: formkey,
                      child: Column(children: [
                        MyTextFormField(validator: (value) {
                          if (value!.isEmpty) {
                            return AppLocalizations.of(context)!.title_validation;
                          }
                          return null;
                        }, controller: name,
                          label:AppLocalizations.of(context)!.title,
                          prefixIcon: Icon(Icons.title),
                          iconColor: AppColors.blueColor,
                          floatingLabelStyleColor: AppColors.blueColor,
                        ),
                        SizedBox(height: 15,),
                        MyTextFormField(validator: (value) {
                          if (value!.trim().isEmpty) {
                            return AppLocalizations.of(context)!.description_vadidation;
                          }
                          return null;
                        }, controller: description,
                          label:AppLocalizations.of(context)!.description,
                          prefixIcon: Icon(Icons.description),
                          iconColor: AppColors.blueColor,
                          floatingLabelStyleColor: AppColors.blueColor,
                          maxLines: 3,
                          maxTextLength: 100,
                          buildCounter: (context, {required currentLength, required isFocused, required maxLength}) {
                              return Text('${currentLength}/${maxLength}',style: TextStyle(
                                fontSize: 12,
                                color: currentLength==maxLength?AppColors.redColor:AppColors.blueColor
                              ),);
                          },
                        ),
        
                      ],)),
                ),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(AppLocalizations.of(context)!.select_date, style: Theme
                                .of(context)
                                .textTheme
                                .bodyLarge,
                            ),
                            SizedBox(width: 15,),
                            InkWell(
                              onTap: () {
                                showCalender();
                              },
                              child: Text(
                                DateFormat.yMMMd(Localizations.localeOf(context).languageCode).format(selectedDate), style: Theme
                                  .of(context)
                                  .textTheme
                                  .titleMedium?.copyWith(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w200,
                                  color: AppColors.blueColor.withOpacity(.7)
                              ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),

                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(AppLocalizations.of(context)!.select_time, style: Theme
                                .of(context)
                                .textTheme
                                .bodyLarge,
                            ),
                            SizedBox(width: 15,),
                            InkWell(
                              onTap: () {
                                showClock();
                              },
                              child: Text(DateFormat.jm(Localizations.localeOf(context).languageCode).format(DateTime(1,1,1,selectedTime.hour,selectedTime.minute)), style: Theme
                                  .of(context)
                                  .textTheme
                                  .titleMedium?.copyWith(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w200,
                                  color: AppColors.blueColor.withOpacity(.7)
                              ),
                                textAlign: TextAlign.center,
                              ),
                            ),SizedBox(height: 10,),
                          ],
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: () {
                        add();
                        listProvider.initDataList();
                        setState(() {

                        });

                      },
                      padding: EdgeInsets.all(10),
                      icon: Icon(Icons.send, color: AppColors.whiteColor,size: 25,),
                      style: IconButton.styleFrom(

                        backgroundColor: AppColors.blueColor,
                        shape: CircleBorder(
                            side: BorderSide(
                                color: provider.isDark() ?
                                AppColors.darkColor
                                    : AppColors.whiteColor,
                                width: 3
                            )
                        ),

                      ),
                    ),
                  ],
                ),



              ],
            ),
          ),
        ),
      ),
    );
  }

  void showCalender() async {
    selectedDate = await showDatePicker(context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
      initialDate: selectedDate ,
    ) ?? selectedDate;
    setState(() {

    });
  }

  void add() {
    if (formkey.currentState?.validate() == true) {
          var task =Task(
              name: name.text, description: description.text, dateTime: selectedDate,hour: selectedTime.hour,min: selectedTime.minute );

          FirestoreUtils.addToFirestore(task);
          Navigator.pop(context);

    }
  }

  void showClock() async{

     selectedTime=await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now()

    )?? TimeOfDay.now();
     setState(() {

     });
  }


}