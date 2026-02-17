class LoginController {
  final String _validUsername = "admin";
  final String _validPassword = "123";

  //Fungsi pengeceka logic only
  //fungsi ini mengembalikkan true jika cocok, false jika salah

  bool login(String username, String password){
    if(username == _validUsername && password == _validPassword){
      return true;
    }
    return false;
  }

}