import 'package:flutter/material.dart';
import 'package:project_1_btl/repository/AuthRepository.dart';
import 'package:project_1_btl/screen/item/ItemUserInfo.dart';
import 'package:project_1_btl/services/AuthService.dart';
import 'package:project_1_btl/widgets/MyAppBar.dart';
import 'package:project_1_btl/widgets/MyButton.dart';
import 'package:project_1_btl/widgets/MyText.dart';
import 'package:project_1_btl/widgets/SnackBarHelper.dart';

class UserInformationScreen extends StatefulWidget {
  const UserInformationScreen({super.key});

  @override
  State<UserInformationScreen> createState() => _UserInformationScreenState();
}

class _UserInformationScreenState extends State<UserInformationScreen> {
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final AuthRepository authRepository = AuthRepository(AuthService());
  String? selectedGender;

  @override
  void initState() {
    super.initState();
    _loadUserInformation();

    // Lắng nghe thay đổi trên các trường nhập liệu
    userNameController.addListener(() => setState(() {}));
    phoneController.addListener(() => setState(() {}));
    addressController.addListener(() => setState(() {}));
  }

  Future<void> _loadUserInformation() async {
    try {
      final userInfo = await authRepository.getUserInformation();
      setState(() {
        userNameController.text = userInfo['fullName'] ?? '';
        phoneController.text = userInfo['phoneNumber'] ?? '';
        emailController.text = userInfo['email'] ?? '';
        addressController.text = userInfo['address'] ?? '';
        selectedGender = (userInfo['gender'] == 'Nam' || userInfo['gender'] == 'Nữ')
            ? userInfo['gender']
            : null;
      });
    } catch (error) {
      SnackBarHelper.showSimpleSnackBar(
        context: context,
        message: "Tải thông tin người dùng thất bại !",
      );
    }
  }

  void _saveChanges() async {
    final updatedUserInfo = {
      'fullName': userNameController.text,
      'phoneNumber': phoneController.text,
      'email': emailController.text,
      'address': addressController.text,
      'gender': selectedGender ?? '',
    };

    try {
      final result = await authRepository.updateUserInformation(updatedUserInfo);
      SnackBarHelper.showSimpleSnackBar(
        context: context,
        message: result,
      );
    } catch (error) {
      SnackBarHelper.showSimpleSnackBar(
        context: context,
        message: "$error",
      );
    }
  }

  // Kiểm tra xem nút Lưu thay đổi có được kích hoạt hay không
  bool _isSaveButtonEnabled() {
    return userNameController.text.isNotEmpty ||
        phoneController.text.isNotEmpty ||
        addressController.text.isNotEmpty ||
        selectedGender != null;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: MyAppBar(title: "Thông tin người dùng"),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 5),
              _buildTextFormField("Tên Người Dùng", userNameController, true),
              SizedBox(height: 5),
              _buildTextFormField("Số Điện Thoại", phoneController, true),
              SizedBox(height: 5),
              _buildTextFormField("Email", emailController, false),
              SizedBox(height: 5),
              _buildGenderDropdown(),
              SizedBox(height: 5),
              _buildTextFormField("Địa Chỉ", addressController, true),
              SizedBox(height: 30),
              InkWell(
                onTap: _isSaveButtonEnabled() ? _saveChanges : null,
                child: Opacity(
                  opacity: _isSaveButtonEnabled() ? 1.0 : 0.5,
                  child: MyButton(
                    size: size,
                    title: "Lưu thay đổi",
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField(String label, TextEditingController controller, bool isEditable) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Text(
              label,
              style: TextStyle(fontSize: 16, fontFamily: "Roboto-Light.ttf", fontWeight: FontWeight.w500),
            ),
          ),
          SizedBox(width: 5),
          Expanded(
            flex: 2,
            child: TextField(
              controller: controller,
              enabled: isEditable,
              showCursor: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius:
                  BorderRadius.all(Radius.circular(10.0)),
                  borderSide: BorderSide(
                    width: 0,
                    style: BorderStyle.none,
                  ),
                ),
                filled: true,
                fillColor: Color(0xFFF2F3F5),
                hintStyle: TextStyle(
                  color: Color(0xFF666666),
                  fontFamily: "Roboto-Light.ttf",
                  fontSize: 16,
                ),
                hintText: label,
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildGenderDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Text(
              'Giới Tính',
              style: TextStyle(fontSize: 16, fontFamily: "Roboto-Light.ttf", fontWeight: FontWeight.w500),
            ),
          ),
          SizedBox(width: 10),

          Expanded(
            flex: 2,
            child: DropdownButtonFormField<String>(
              value: selectedGender,
              items: ['','Nam', 'Nữ']
                  .map((gender) => DropdownMenuItem<String>(
                value: gender,
                child: MyText(size: 20, color: Colors.black, weight: FontWeight.w500,text: gender,family: "Roboto-Light.ttf",),
              ))
                  .toList(),
              onChanged: (newValue) {
                setState(() {
                  selectedGender = newValue;
                });
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
