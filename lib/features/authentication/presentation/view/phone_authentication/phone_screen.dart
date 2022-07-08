import 'package:animate_do/animate_do.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:olx/core/constants/colors.dart';
import 'package:olx/core/constants/image_assets.dart';
import 'package:olx/features/authentication/presentation/provider/auth_provider.dart';
import 'package:provider/provider.dart';
import '../../../../../core/utils/config.dart';
import '../../provider/auth_states.dart';

class EnterPhone extends StatefulWidget {
  const EnterPhone({Key? key}) : super(key: key);

  @override
  _EnterPhoneState createState() => _EnterPhoneState();
}

class _EnterPhoneState extends State<EnterPhone> {
  TextEditingController phoneTextEditingController = TextEditingController();
  String? verificationId;
  String number = "";

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: FadeInDown(
          duration: const Duration(
            milliseconds: 400,
          ),
          child: Column(
            children: [
              const YMargin(100),
              Container(
                alignment: Alignment.center,
                width: 200,
                height: 66,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.contain,
                    image: AssetImage(ImagesAsset.olxLogo),
                  ),
                ),
              ),
              const YMargin(60),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Please enter your Mobile Number",
                      style: Config.b1(context)),
                  const YMargin(3.0),
                  Text("An OTP will be sent you for verification?",
                      style: Config.b3(context)),
                ],
              ),
              const YMargin(50),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Container(
                    padding: const EdgeInsets.only(left: 8.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.black.withOpacity(0.13)),
                    ),
                    child: Stack(
                      children: [
                        InternationalPhoneNumberInput(
                          onInputChanged: (PhoneNumber? num) {
                            setState(() {
                              number = num.toString();
                              // print(number);
                            });
                          },
                          onInputValidated: (bool value) {
                            // print(value);
                          },
                          selectorConfig: const SelectorConfig(
                            selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                          ),
                          ignoreBlank: false,
                          autoValidateMode: AutovalidateMode.disabled,
                          selectorTextStyle:
                              const TextStyle(color: Colors.black),
                          textFieldController: phoneTextEditingController,
                          formatInput: false,
                          maxLength: 10,
                          keyboardType: TextInputType.phone,
                          cursorColor: Colors.black,
                          inputDecoration: InputDecoration(
                            contentPadding:
                                const EdgeInsets.only(bottom: 15, left: 0),
                            border: InputBorder.none,
                            hintText: 'Phone Number',
                            hintStyle: TextStyle(
                                color: Colors.grey.shade500, fontSize: 16),
                          ),
                          onSaved: (PhoneNumber number) {
                            if (kDebugMode) {
                              print('On Saved: $number');
                            }
                          },
                        ),
                      ],
                    )),
              ),
              const YMargin(30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Container(
                  height: 50,
                  width: context.screenWidth(),
                  decoration: BoxDecoration(
                    color: OlxColor.olxPrimary,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: InkWell(
                    onTap: () {
                      state.verifyPhoneNumber(number).then((value) {
                        phoneTextEditingController.clear();
                      });
                      if (kDebugMode) {
                        print("HELLO $number");
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          state.phoneAuthState != PhoneAuthState.loading
                              ? "Next"
                              : "Loading",
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
