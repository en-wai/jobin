import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopping_app/base/custom_loader.dart';
import 'package:shopping_app/base/custom_snackbar.dart';
import 'package:shopping_app/components/colors.dart';
import 'package:shopping_app/controllers/auth_controller.dart';
import 'package:shopping_app/models/signup_body.dart';
import 'package:shopping_app/routes/route_helper.dart';
import 'package:shopping_app/widgets/app_text_field.dart';
import 'package:shopping_app/widgets/big_text.dart';
class SignUpPage extends StatelessWidget {
   SignUpPage({Key? key}) : super(key: key);
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var nameController = TextEditingController();
  var phoneController = TextEditingController();
  @override
  Widget build(BuildContext context) {

    List images =[
      "g.png",
      "t.png",
      "f.png"
    ];

    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(

      backgroundColor: Colors.white,
      body:GetBuilder<AuthController>(builder: (authController) {
        return
         !authController.isLoading?  SingleChildScrollView(
             physics: BouncingScrollPhysics(),
             child: Column(
                children: [
                  Container(
                    width: w,
                    height: h * 0.25,
                    decoration: BoxDecoration(
                        color: Colors.white
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(height: h * 0.05,),
                          CircleAvatar(
                            backgroundColor: Colors.white70,
                            radius: 80,
                            backgroundImage: AssetImage(
                                "img/logo part 1.png"
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 20, right: 20),
                    width: w,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        SizedBox(height: 20,),
                        AppTextField(hintText:"Email", textController:emailController, icon: Icons.email,),
                        SizedBox(height: 20,),
                        AppTextField(hintText:"Password", textController:passwordController, icon:Icons.password_sharp),
                        SizedBox(height: 20,),
                        AppTextField(hintText:"Phone", textController:phoneController, icon:Icons.phone),
                        SizedBox(height: 20,),
                        AppTextField(hintText:"Name", textController:nameController, icon:Icons.person),
                        SizedBox(height: 20,),


                      ],
                    ),
                  ),
                  SizedBox(height: 20,),
                  GestureDetector(
                    onTap: () {
                      _register(authController);
                    },
                    child: Container(
                      width: w * 0.5,
                      height: h * 0.08,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: AppColors.mainColor
                      ),
                      child: Center(
                        child: BigText(
                          text:"Sign up",
                          size: 30,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10,),
                  RichText(
                      text: TextSpan(
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => Get.back(),
                          text: "Have an account?",
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.grey[500]
                          )
                      )
                  ),
                  SizedBox(height: w * 0.08),
                  RichText(text: TextSpan(
                    text: "Sign up using one of the following methods",
                    style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 16
                    ),

                  )),
                  Wrap(
                    children: List<Widget>.generate(
                        3,
                            (index) {
                          return GestureDetector(
                            onTap: () {

                            },
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: CircleAvatar(
                                radius: 30,
                                backgroundColor: Colors.transparent,
                                //backgroundColor: AppColors.mainColor,
                                child: CircleAvatar(
                                  radius: 25,
                                  backgroundImage: AssetImage(
                                      "img/" + images[index]
                                  ),
                                ),
                              ),
                            ),
                          );
                        }
                    ),
                  )
                ],
              ),
           ):CustomLoader();

      }));
    }

  void _register(AuthController authController) async {
    String _firstName = nameController.text.trim();
    String _email = emailController.text.trim();
    String _number = phoneController.text.trim();
    String _password = passwordController.text.trim();


    if (_firstName.isEmpty) {
      showCustomSnackBar("Type in your name", title:"Name");

    }else if (_email.isEmpty) {
      showCustomSnackBar("Type in your Email", title:"Email");
    }else if (!GetUtils.isEmail(_email)) {
      showCustomSnackBar("Type in correct Email", title:"Email");
    }else if (_number.isEmpty) {
      showCustomSnackBar("Type in your Phone Number", title:"Phone Number");
    }else if (_password.isEmpty) {
      showCustomSnackBar("Type in your Password", title:"Password");
    }else if (_password.length < 6) {
      showCustomSnackBar("Type in equal or more than 6 characters", title:"Password");

    }else {
      SignUpBody signUpBody = SignUpBody(fName: _firstName,
          email: _email,
          phone: _number, password: _password);
      authController.registration(signUpBody).then((status) async {
        if (status.isSuccess) {
            print("success registration");
            Get.offNamed(RouteHelper.getInitialRoute());
        }else {
          Get.snackbar("Wrong", "Something went wrong");

        }
      });
    }
  }
}
