import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app/base/custom_loader.dart';
import 'package:shopping_app/base/custom_snackbar.dart';
import 'package:shopping_app/components/colors.dart';
import 'package:shopping_app/controllers/auth_controller.dart';
import 'package:shopping_app/routes/route_helper.dart';
import 'package:shopping_app/screens/auth/sign_up_page.dart';
import 'package:get/get.dart';
import 'package:shopping_app/uitls/styles.dart';
import 'package:shopping_app/widgets/big_text.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  var _phoneController = TextEditingController();
  var _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(

      backgroundColor: Colors.white,
      body: GetBuilder<AuthController>(builder:( authController){
        return  ! authController.isLoading?SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
                    children: [
                      Container(
                        width: w,
                        height: h*0.2,
                        margin:  EdgeInsets.only(top:40, left: 40, right: 40, bottom: 20),
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage(
                                    "img/logo part 1.png"
                                ),
                                fit: BoxFit.fitHeight
                            )
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 20, right: 20),
                        width: w,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Hello",
                              style: TextStyle(
                                  fontSize: 70,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                            Text(
                              "Sign into your account",
                              style: TextStyle(
                                  fontSize: 20,
                                  color:Colors.grey[500]
                              ),
                            ),
                            SizedBox(height: 50,),
                            Container(
                              decoration: BoxDecoration(
                                  color:Colors.white,
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: [
                                    BoxShadow(
                                        blurRadius: 3,
                                        spreadRadius: 1,
                                        offset: Offset(1, 1),
                                        color:Colors.grey.withOpacity(0.2)
                                    )
                                  ]
                              ),
                              child: TextField(
                                controller: _phoneController,
                                decoration: InputDecoration(
                                    hintText: "Phone",
                                    prefixIcon: Icon(Icons.mobile_screen_share, color:AppColors.mainColor),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                        borderSide: BorderSide(
                                            color:Colors.white,
                                            width: 1.0
                                        )
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                        borderSide: BorderSide(
                                            color:Colors.white,
                                            width: 1.0
                                        )
                                    ),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15)
                                    )
                                ),
                              ),
                            ),
                            SizedBox(height: 20,),
                            Container(
                              decoration: BoxDecoration(
                                  color:Colors.white,
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: [
                                    BoxShadow(
                                        blurRadius: 10,
                                        spreadRadius: 7,
                                        offset: Offset(1, 1),
                                        color:Colors.grey.withOpacity(0.2)
                                    )
                                  ]
                              ),
                              child: TextField(
                                controller: _passwordController,
                                obscureText: true,
                                decoration: InputDecoration(
                                    hintText: "Password",
                                    prefixIcon: Icon(Icons.password, color:AppColors.mainColor),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                        borderSide: BorderSide(
                                            color:Colors.white,
                                            width: 1.0
                                        )
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                        borderSide: BorderSide(
                                            color:Colors.white,
                                            width: 1.0
                                        )
                                    ),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15)
                                    )
                                ),
                              ),
                            ),
                            SizedBox(height: 20,),
                            Row(
                              children: [
                                Expanded(child: Container(),),
                                Text(
                                  "Sign into your account",
                                  style: TextStyle(
                                      fontSize: 20,
                                      color:Colors.grey[500]
                                  ),
                                )
                              ],
                            ),

                          ],
                        ),
                      ),
                      SizedBox(height: 60,),
                      GestureDetector(
                        onTap: (){
                          _login(authController);
                        },
                        child: Container(
                          width: w*0.5,
                          height: h*0.08,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: AppColors.mainColor
                          ),
                          child:Center(
                            child: BigText(
                              text: 'Sign in',
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height:w*0.15),
                      RichText(text: TextSpan(
                          text:"Don\'t have an account?",
                          style: TextStyle(
                              color:Colors.grey[500],
                              fontSize: 20
                          ),
                          children: [
                            TextSpan(
                                text:" Create",
                                style: TextStyle(
                                    color:Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold
                                ),
                                recognizer: TapGestureRecognizer()..onTap=()=>Get.to(()=>SignUpPage())
                            )
                          ]
                      )
                      )
                    ],
                  ),
        ):CustomLoader();


      }),
    );
  }

  void _login(AuthController authController ) async {
    String _phone = _phoneController.text.trim();
    String _password = _passwordController.text.trim();

    bool _isValid = GetPlatform.isWeb ? true : false;

    if (_phone.isEmpty) {
      Get.snackbar("Phone", "Type in your phone");
    }else if (_password.isEmpty) {
      Get.snackbar("Password", "Type in your password");
    }else if (_password.length < 6) {
      Get.snackbar("Password", "More than 6");
    }else {
      authController.login(_phone, _password).then((status) async {
        if (status.isSuccess) {
          authController.saveUserNumberAndPassword(_phone, _password);
          String _token = status.message.substring(1, status.message.length);

            Get.toNamed(RouteHelper.getInitialRoute());

        }else {
          showCustomSnackBar(status.message);
        }
      });
    }
  }
}
