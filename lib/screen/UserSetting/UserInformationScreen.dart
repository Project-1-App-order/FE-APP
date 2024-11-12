import 'package:flutter/material.dart';
import 'package:project_1_btl/repository/AuthRepository.dart';
import 'package:project_1_btl/screen/item/ItemUserInfo.dart';
import 'package:project_1_btl/services/AuthService.dart';
import 'package:project_1_btl/widgets/MyAppBar.dart';
import '../../widgets/MyText.dart';

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
      // Xử lý lỗi khi lấy thông tin người dùng
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Không thể tải thông tin người dùng: $error')),
      );
    }
  }

  void _saveChanges() async {
    final updatedUserInfo = {
      'fullName': userNameController.text,
      'phoneNumber': phoneController.text,
      'email': emailController.text, // Đảm bảo không cập nhật email nếu server không cho phép
      'address': addressController.text,
      'gender': selectedGender ?? '',
    };

    try {
      final result = await authRepository.updateUserInformation(updatedUserInfo);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result)),
      );
    } catch (error) {
      // Xử lý lỗi khi lưu thông tin người dùng
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$error')),
      );
    }
  }

  bool _isSaveButtonEnabled() {
    return userNameController.text.isNotEmpty &&
        phoneController.text.isNotEmpty &&
        addressController.text.isNotEmpty &&
        selectedGender != null;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: MyAppBar(title: "Thông tin người dùng"),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Column(
            children: [

              SizedBox(height: 20),
              _buildTextFormField("Tên Người Dùng", userNameController, true),
              _buildTextFormField("Số Điện Thoại", phoneController, true),
              _buildTextFormField("Email", emailController, false),
              _buildGenderDropdown(), // Thêm phần dropdown giới tính
              _buildTextFormField("Địa Chỉ", addressController, true),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () => _saveChanges(),
                child: Text('Lưu thay đổi'),

              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField(String label, TextEditingController controller, bool isEditable) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Text(
              label,
              style: TextStyle(fontSize: 16),
            ),
          ),
          SizedBox(width: 5),
          Expanded(
            flex: 2,
            child: TextFormField(
              controller: controller,
              enabled: isEditable, // Thêm điều kiện cho phép chỉnh sửa
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget cho Dropdown giới tính
  Widget _buildGenderDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Text(
              'Giới Tính',
              style: TextStyle(fontSize: 16),
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
                child: Text(gender),
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
