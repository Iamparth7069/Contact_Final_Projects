class utils {
  static final _emailregex  = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  static final _passregex = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$'); // should contain at least one Special character.{8,}");

  static bool isvalidemail(String email){
    return _emailregex.hasMatch(email);
  }
  static bool isvalidpassword(String password){
    return _passregex.hasMatch(password);
  }
  static bool isvalidmobile(String values){
    if(values.length != 10){
      values = "'Mobile Number must be of 10 digit'";
      return false;
    }else{
      return true;
    }
  }
}